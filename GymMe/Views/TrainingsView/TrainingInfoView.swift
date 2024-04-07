//
//  TrainingInfoView.swift
//  GymMe
//
//  Created by Максим Троицкий on 04.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI
import WrappingStack

struct TrainingInfoView: View {
    @State var training: Training
    @State var screenWidth = UIScreen.main.bounds.size.width
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 0) {
                        if training.trainingImage != "" {
                            WebImage(url: URL(string: training.trainingImage!))
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(20)
                                .clipped()
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(AppConstants.accentBlueColor, lineWidth: 2)
                                })
                                .padding(.horizontal, 16)
                            
                        } else {
                            Text("There is no photo of the event")
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(AppConstants.accentBlueColor)
                                        .opacity(0.5)
                                        .frame(width: screenWidth - 32, height: 200)
                                })
                                .frame(width: screenWidth - 100, height: 200)
                                .hSpacing(.center)
                        }
                        HStack {
                            Text(training.trainingName)
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        .padding()
                        HStack {
                            Text("Exercises:")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(AppConstants.accentBlueColor)
                            Spacer()
                            //                        Button(action: {
                            //
                            //                        }, label: {
                            //                            Image(systemName: "plus")
                            //                                .font(.title2)
                            //                                .foregroundStyle(AppConstants.accentOrangeColor)
                            //                        })
                        }
                        .padding(.horizontal)
                        ExercisesInfoView(training: training)
                            .padding()
                        HStack {
                            if (training.trainingNote != "") {
                                Text("Notes:")
                                    .font(.title2)
                                    .bold()
                                    .foregroundStyle(AppConstants.accentBlueColor)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        HStack {
                            Text(training.trainingNote)
                                .foregroundStyle(.secondary)
                                .fontWeight(.light)
                                .padding(.horizontal)
                            Spacer()
                        }
                        .padding(.vertical)
                        
                    }
                    .frame(width: UIScreen.main.bounds.size.width)
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(training.trainingDate.format("d MMMM YYYY"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { // trail
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                })
            }
        }
    }
}

struct ExercisesInfoView: View {
    @State var training: Training
    @State var fullInfoIdxs: [Int] = []
    @State var screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        
        VStack(spacing: 20) {
            ForEach(training.exercises) { exercise in
                VStack {
                    let idx = training.exercises.firstIndex(where: {exercise.id == $0.id} )!
                    if (fullInfoIdxs.contains(idx)) {
                        //                    ZStack {
                        ExerciseView(exercise: exercise)
                            .frame(width: screenWidth - 32)
                        //                    }
                            .onTapGesture {
                                print(screenWidth)
                                let rmIdx = fullInfoIdxs.firstIndex(of: training.exercises.firstIndex(where: {exercise.id == $0.id} )!)!
                                withAnimation(.easeInOut) {
                                    fullInfoIdxs.remove(at: rmIdx)
                                }
                            }
                        
                            .padding(.bottom, 3)
                    } else {
                        HStack {
                            ShortExcerciseInfo(exercise: exercise)
                                .padding(.bottom, 8)
                                .frame(width: screenWidth - 32)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(AppConstants.accentBlueColor)
                                })
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        fullInfoIdxs.append(training.exercises.firstIndex(where: {exercise.id == $0.id} )!)
                                    }
                                }
                        }
                        
                    }
                    //                } else {
                    //                    ShortExcerciseInfo(exercise: exercise)
                    //                        .onTapGesture {
                    //                            fullInfo.toggle()
                    //                        }
                }
            }
            
        }
        .frame(width: screenWidth)
    }
    //        Text("text")
    
    @ViewBuilder
    func ShortExcerciseInfo(exercise: Exercise) -> some View {
        VStack {
            Text(exercise.name)
                .font(.title2)
                .bold()
                .padding(.top, 8)
                .padding(.leading)
                .hSpacing(.leading)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], alignment: .center, spacing: 10) {
                if exercise.time != nil {
                    Text("\(String(format: "%.2f", exercise.time!)) min")
                        .lineLimit(1)
                        .padding(4)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(AppConstants.accentOrangeColor)
                        })
                }
                if exercise.distance != nil {
                    Text("\(String(format: "%.2f", exercise.distance!)) km")
                        .lineLimit(1)
                        .padding(4)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(AppConstants.accentOrangeColor)
                        })
                }
                if exercise.weight != nil {
                    Text("\(String(exercise.weight!)) kg")
                        .lineLimit(1)
                        .padding(4)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(AppConstants.accentOrangeColor)
                        })
                }
                if exercise.sets != nil {
                    Text("\(String(exercise.sets!)) sets")
                        .lineLimit(1)
                        .padding(4)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(AppConstants.accentOrangeColor)
                        })
                }
                if exercise.repetitions != nil {
                    Text("\(String(exercise.repetitions!)) rep.")
                        .lineLimit(1)
                        .padding(4)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(AppConstants.accentOrangeColor)
                        })
                }
            }
            .padding(.leading, 10)
            .padding(.bottom, 5)
        }
    }
    
    @ViewBuilder
    func HandleShortInfo(exercise: Exercise) -> some View {
        HStack {
            if exercise.time != nil {
                Text("\(String(format: "%.2f", exercise.time!)) min")
            }
            if exercise.time != nil {
                Text("\(String(format: "%.2f", exercise.time!)) min")
            }
            if exercise.time != nil {
                Text("\(String(format: "%.2f", exercise.time!)) min")
            }
            if exercise.time != nil {
                Text("\(String(format: "%.2f", exercise.time!)) min")
            }
            if exercise.time != nil {
                Text("\(String(format: "%.2f", exercise.time!)) min")
            }
            
        }
    }
    
    @ViewBuilder
    func FullExcerciseInfo(exercise: Exercise) -> some View {
        VStack {
            Text(exercise.name)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.leading)
            HandleFullInfo(exercise: exercise)
                .padding()
            
        }
        .padding()
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentBlueColor)
        })
    }
    
    @ViewBuilder
    func HandleFullInfo(exercise: Exercise) -> some View {
        VStack {
            
            // Time
            if (exercise.time != nil) {
                HStack {
                    Text("Total time:")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                        .fontWeight(.semibold)
                        .font(.title3)
                    Spacer()
                    HStack(spacing: 2) {
                        Text("\(exercise.time!)")
                            .foregroundStyle(.primary)
                        Text("min")
                            .foregroundStyle(.secondary)
                    }
                    .padding(2)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppConstants.accentOrangeColor)
                    })
                }
            }
            
            // Distance
            if (exercise.distance != nil) {
                HStack {
                    Text("Total distance:")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                        .fontWeight(.semibold)
                        .font(.title3)
                    Spacer()
                    HStack(spacing: 2) {
                        Text("\(exercise.distance!)")
                            .foregroundStyle(.primary)
                        Text("km")
                            .foregroundStyle(.secondary)
                    }
                    .padding(2)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppConstants.accentOrangeColor)
                    })
                }
            }
            
            // Weight
            if (exercise.weight != nil) {
                HStack {
                    Text("Weight:")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                        .fontWeight(.semibold)
                        .font(.title3)
                    Spacer()
                    HStack(spacing: 2) {
                        Text("\(exercise.weight!)")
                            .foregroundStyle(.primary)
                        Text("kg")
                            .foregroundStyle(.secondary)
                    }
                    .padding(2)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppConstants.accentOrangeColor)
                    })
                }
            }
            
            // Sets
            if (exercise.sets != nil) {
                HStack {
                    Text("Sets:")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                        .fontWeight(.semibold)
                        .font(.title3)
                    Spacer()
                    HStack(spacing: 2) {
                        Text("\(exercise.sets!)")
                            .foregroundStyle(.primary)
                        Text("sets")
                            .foregroundStyle(.secondary)
                    }
                    .padding(2)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppConstants.accentOrangeColor)
                    })
                }
            }
            
            // Reps
            if (exercise.repetitions != nil) {
                HStack {
                    Text("Repetitions:")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                        .fontWeight(.semibold)
                        .font(.title3)
                    Spacer()
                    HStack(spacing: 2) {
                        Text(String(exercise.repetitions!))
                            .foregroundStyle(.primary)
                        Text("rep.")
                            .foregroundStyle(.secondary)
                    }
                    .padding(2)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppConstants.accentOrangeColor)
                    })
                }
            }
            
        }
    }
}
//#Preview {
//    TrainingInfoView()
//}
