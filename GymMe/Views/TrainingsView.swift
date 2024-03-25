//
//  TrainingsView.swift
//  GymMe
//
//  Created by Максим Троицкий on 13.03.2024.
//

import SwiftUI
import WrappingStack

struct TrainingsView: View {
    var trainingController = TrainingController()
    @State private var trainingIdToScroll: UUID?
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollViewReader { scrollReader in
                    LazyVStack(alignment: .leading, pinnedViews: .sectionHeaders) {
                        let sectionTrainings = trainingController.getMonthSectionTrainings(for: trainingController.getSortedTrainings())
                        
                        ForEach(sectionTrainings.indices, id: \.self) { sectionIndex in
                            if sectionIndex == 0 || sectionIndex > 0 && sectionTrainings[sectionIndex - 1].first!.trainingDate.yearsBetween(date: sectionTrainings[sectionIndex].last!.trainingDate) >= 1 {
                                yearSectionHeader(firstTraining: sectionTrainings[sectionIndex].first!)
                            }
                            Section(header: sectionHeader(firstTraining: sectionTrainings[sectionIndex].first!)) {
                                WrappingHStack (alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
                                    let trainings = sectionTrainings[sectionIndex]
                                    ForEach(trainings) { training in
                                        TrainingCell(for: training)
                                            .id(training.id)
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    .onAppear {
                        if let trainingID = trainingController.getSortedTrainings().last?.id {
                            scrollTo(trainingId: trainingID, anchor: .bottom, shouldAnimate: false, scrollReader: scrollReader)
                        }
                    }
                    .padding(.leading, 10)
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Trainings")
                        .font(.title2)
                        .bold()
                        .opacity(0.6)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        
                    }, label: {
                        
                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(AppConstants.accentOrangeColor)
                            .frame(width: 30)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(AppConstants.accentOrangeColor)
                            .frame(width: 30)
                    })
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    func scrollTo(trainingId: UUID, anchor: UnitPoint? = nil, shouldAnimate: Bool, scrollReader: ScrollViewProxy) {
        DispatchQueue.main.async {
            withAnimation(shouldAnimate ? Animation.easeIn : nil) {
                scrollReader.scrollTo(trainingId, anchor: anchor)
            }
        }
    }
    
    func sectionHeader(firstTraining training: Training) -> some View {
        VStack (alignment: .center) {
            HStack {
                Text(training.trainingDate.format("MMMM"))
                    .font(.title2)
                Spacer()
            }
            .padding(.horizontal, 6)
            .frame(height: 30)
            .background()
        }
    }
    
    func yearSectionHeader(firstTraining training: Training) -> some View {
        VStack (alignment: .center) {
            HStack {
                Text(training.trainingDate.format("YYYY"))
                    .font(.title)
                    .foregroundColor(AppConstants.accentBlueColor)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.horizontal, 6)
            .frame(height: 30)
            .background()
            .padding(.top, 8)
        }
    }
    
    @ViewBuilder
    func TrainingCell(for training: Training) -> some View {
        @State var screenWidth = UIScreen.main.bounds.size.width
        let padding: CGFloat = 10
        let size = (screenWidth - padding * 5) / 4
        
        Image("InfoImage")
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipped()
            .overlay(content: {
                Text(training.trainingDate.format("dd MMM"))
                    .padding(.horizontal, 4)
                    .frame(width: size, height: size / 4)
                    .background(content: {
                        Rectangle()
                            .fill(.black)
                            .opacity(0.6)
                    })
                    .foregroundColor(.white)
//                    .fontWeight(./*semibold*/)
                    .font(.system(size: size / 4.5 - 4))
                    .vSpacing(.bottom)
            })
            .cornerRadius(10)
    }
    
}

#Preview {
    TrainingsView()
}
