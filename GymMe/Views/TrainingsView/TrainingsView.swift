//
//  TrainingsView.swift
//  GymMe
//
//  Created by Максим Троицкий on 13.03.2024.
//

import SwiftUI
import WrappingStack
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI
import SwiftData

struct TrainingsView: View {
    //    var trainingController = TrainingController()
    @State private var trainingIdToScroll: UUID?
    @ObservedObject private var trainingsViewModel: TrainingsViewModel = .init()
    @Environment(\.dismiss) var dismiss
    @Query private var trainings: [TrainingEntity]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        
                    }, label: {
                        
                        Image(systemName: "")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(AppConstants.accentOrangeColor)
                            .frame(width: 30)
                        
                    })
                    Spacer()
                    Text("Trainings")
                        .font(.title2)
                        .bold()
                        .opacity(0.6)
                    Spacer()
                    
                    NavigationLink(destination: CreateTrainingView(trainingsViewModel: trainingsViewModel)
                        .modelContainer(for: TrainingEntity.self), label: {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(AppConstants.accentOrangeColor)
                            .frame(width: 30)
                    })
                    
                }
                .padding()
//                .vSpacing(.top)
                if (FirebaseManager.shared.currentUser?.trainings.count != 0) {
                    ScrollView {
                        ScrollViewReader { scrollReader in
                            LazyVStack(alignment: .leading, pinnedViews: .sectionHeaders) {
                                let sectionTrainings = trainingsViewModel.getMonthSectionTrainings(for: FirebaseManager.shared.currentUser!.trainings)
                                
                                ForEach(sectionTrainings.indices, id: \.self) { sectionIndex in
                                    if sectionIndex == 0 || sectionIndex > 0 && sectionTrainings[sectionIndex - 1].first!.trainingDate.yearsBetween(date: sectionTrainings[sectionIndex].last!.trainingDate) >= 1 {
                                        if (sectionTrainings[sectionIndex].first != nil) {
                                            yearSectionHeader(firstTraining: sectionTrainings[sectionIndex].first!)
                                        }
                                    }
                                    Section(header: sectionHeader(firstTraining: sectionTrainings[sectionIndex].first!)) {
                                        WrappingHStack (alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
                                            let trainings = sectionTrainings[sectionIndex]
                                            ForEach(trainings) { training in
                                                NavigationLink(destination: TrainingInfoView(training: training)) {
                                                    TrainingCell(for: training)
                                                        .id(training.id)
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                                
                            }
                            .onAppear {
                                if let trainingID = FirebaseManager.shared.currentUser?.trainings.last?.id {
                                    scrollTo(trainingId: trainingID, anchor: .bottom, shouldAnimate: false, scrollReader: scrollReader)
                                }
                            }
                            .padding(.leading, 10)
                        }
                    }
                    .navigationBarBackButtonHidden()
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(.bottom, 20)
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            Text("Add trainings and their info will be placed here")
                                .font(.title)
                                .foregroundStyle(AppConstants.accentBlueColor)
                                .fontWeight(.medium)
                                .opacity(0.6)
                                .multilineTextAlignment(.center)
                                .opacity(0.8)
                        }
                        .padding()
                        Spacer()
                    }
                    .vSpacing(.top)
                }
                
                
            }
        }
    }
    
    func scrollTo(trainingId: String?, anchor: UnitPoint? = nil, shouldAnimate: Bool, scrollReader: ScrollViewProxy) {
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
    
//    @ViewBuilder
//    func Header() -> some View {
//        HStack {
//            Button(action: {
//                
//            }, label: {
//                
//                Image(systemName: "calendar")
//                    .resizable()
//                    .scaledToFit()
//                    .foregroundColor(AppConstants.accentOrangeColor)
//                    .frame(width: 30)
//                
//            })
//            Spacer()
//            Text("Trainings")
//                .font(.title2)
//                .bold()
//                .opacity(0.6)
//            Spacer()
//            Button(action: {
//                
//            }, label: {
//                NavigationLink(destination: CreateTrainingView()) {
//                    Image(systemName: "square.and.pencil")
//                        .resizable()
//                        .scaledToFit()
//                        .foregroundColor(AppConstants.accentOrangeColor)
//                        .frame(width: 30)
//                }
//            })
//        }
//    }
    
    @ViewBuilder
    func TrainingCell(for training: Training) -> some View {
        @State var screenWidth = UIScreen.main.bounds.size.width
        let padding: CGFloat = 10
        let size = (screenWidth - padding * 5) / 4
        
        if training.trainingImage == "" {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(training.trainingDate.format("d"))")
                            .font(.title)
                            .fontWeight(.semibold)
                        Text("\(training.trainingDate.format("MMMM"))")
                    }
                    Spacer()
//                        .font(.title3)
                }
                .foregroundStyle(.white)

            .padding(.leading)
            .frame(width: size, height: size)
            .background(AppConstants.accentBlueColor)
            .cornerRadius(10)
        } else {
            WebImage(url: URL(string: training.trainingImage ?? ""))
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
    
}

//#Preview {
//    TrainingsView()
//}
