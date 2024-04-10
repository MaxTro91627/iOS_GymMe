//
//  CreateTrainingView.swift
//  GymMe
//
//  Created by Максим Троицкий on 03.04.2024.
//

import SwiftUI

struct CreateTrainingView: View {
    @ObservedObject var trainingsViewModel: TrainingsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var shouldShowImagePicker = false
    @State var trainingName: String = ""
    @State var textNotes: String = ""
    @State var showError = false
    @State var plusButtonTabbed = false
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        shouldShowImagePicker.toggle()
                    }, label: {
                        if let image = trainingsViewModel.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                                .clipped()
                                .cornerRadius(10)
                        } else {
                            Text("Add Photo")
                                .multilineTextAlignment(.center)
                                .frame(width: 90, height: 90)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(AppConstants.accentBlueColor)
                                })
                        }
                    })
                    
                    TextField("Enter training's name", text: $trainingsViewModel.trainingName, axis: .vertical)
                        .lineLimit(2)
                        .padding(.horizontal, 6)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .opacity(0.6)
                    
                    if showError && trainingsViewModel.trainingName == ""  {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(AppConstants.accentOrangeColor)
                        
                    }
                }
                ScrollView {
                    
                    HStack {
                        Text("Exercises")
                            .padding(.vertical)
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Button(action: {
                            plusButtonTabbed.toggle()
                        }, label: {
                            Image(systemName: "plus")
                                .foregroundStyle(AppConstants.accentOrangeColor)
                                .font(.title2)
                        })
                    }
                    VStack() {
                        ForEach(trainingsViewModel.currentExercises) { exercise in
                            ExerciseView(exercise: exercise)
                        }
                    }
                    Text("Notes:")
                        .font(.title2)
                        .bold()
                        .hSpacing(.leading)
                    TextField("Describe your training experience ", text: $trainingsViewModel.trainingNote, axis: .vertical)
                        .multilineTextAlignment(.leading)
                        .lineLimit(6)
                    
                }
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(AppConstants.accentOrangeColor)
                    })
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        trainingsViewModel.addTraining()
                        dismiss()
                    }, label: {
                        Text("Add training")
                            .bold()
                            .foregroundStyle(.white)
                            .padding(8)
                            .padding(.horizontal, 20)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppConstants.accentOrangeColor)
                            })
                    })
                }
            }
            
            
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $trainingsViewModel.image)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $plusButtonTabbed, content: {
            AddExerciseView(trainingsViewModel: trainingsViewModel, plusButtonTabbed: $plusButtonTabbed)
        })
        .navigationBarBackButtonHidden()
        
    }
    
}

//#Preview {
//    CreateTrainingView()
//}
