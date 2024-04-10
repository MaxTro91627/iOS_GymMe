//
//  AddExerciseView.swift
//  GymMe
//
//  Created by Максим Троицкий on 04.04.2024.
//

import SwiftUI

struct AddExerciseView: View {
    @ObservedObject var trainingsViewModel: TrainingsViewModel
    
    @Binding var plusButtonTabbed: Bool
    @State var exerciseName: String = ""
    @State var noteText: String = ""
    
    @State var time: Float?
    @State var distance: Float?
    @State var weight: Float?
    @State var sets: Int?
    @State var reps: Int?
    
    @State var timeText: String = ""
    @State var distanceText: String = ""
    @State var weightText: String = ""
    @State var setsText: String = ""
    @State var repsText: String = ""

    @State var showError: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 3)
                        .opacity(0.4)
                }
                .padding(.top, 12)
                HStack {
                    TextField("Enter the name of exercise", text: $exerciseName) {
                        UIApplication.shared.endEditing()
                    }
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .font(.title2)
                        .padding(.top, 18)
                    if showError && exerciseName == "" {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(AppConstants.accentOrangeColor)
                    }
                }
                HStack {
                    Text("Exercise parametrs")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundStyle(AppConstants.accentBlueColor)
                        .hSpacing(.leading)
                    if showError && (time == nil && distance == nil && weight == nil && sets == nil && reps == nil) {
                        Spacer()
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(AppConstants.accentOrangeColor)
                    }
                }
                HandleParametrs()
                Text("Notes")
                    .hSpacing(.leading)
                    .fontWeight(.semibold)
                    .font(.title2)
                    .foregroundStyle(AppConstants.accentBlueColor)
                TextField("Describe your exercise experience", text: $noteText, axis: .vertical)
                    .foregroundStyle(.secondary)
                    .bold()
            }
            .padding(.horizontal)
            Button(action: {
                if exerciseName == "" ||
                    (time == nil && distance == nil && weight == nil && sets == nil && reps == nil) {
                    showError = true
                } else {
                    trainingsViewModel.addExercise(exercise: Exercise(id: UUID().uuidString, name: exerciseName, time: time, distance: distance, weight: weight, sets: sets, repetitions: reps, notes: noteText))
                    plusButtonTabbed = false
                    exerciseName = ""
                    noteText = ""
                    time = nil
                    distance = nil
                    weight = nil
                    sets = nil
                    reps = nil
                    timeText = ""
                    distanceText = ""
                    weightText = ""
                    setsText = ""
                    repsText = ""
                }
            }, label: {
                Text("Add exercise")
                    .padding(8)
                    .padding(.horizontal, 20)
                    .bold()
                    .foregroundStyle(.white)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppConstants.accentOrangeColor)
                    })
            })
            
        }
        
    }
    
    @ViewBuilder
    func HandleParametrs() -> some View {
        VStack {
            
            // Time
            if self.time == nil {
                HStack {
                    Button(action: {
                        self.time = 0.5
                    }, label: {
                        Text("+ Add total time")
                            .bold()
                    })
                    .foregroundColor(.secondary)
                    .bold()
                    Spacer()
                }
                .padding(.bottom, 3)
            } else {
                HStack {
                    Text("Total time:")
                        .fontWeight(.semibold)
                    Spacer()
                    HStack(spacing: 0) {
                        TextField("0.5", text: self.$timeText) {
                            UIApplication.shared.endEditing()
                        }
                            .frame(width: 43)
                            .keyboardType(.numbersAndPunctuation)
                            .onChange(of: timeText) {
                                if (Float(timeText.replacingOccurrences(of: ",", with: ".")) != nil) {
                                    self.time = Float(timeText.replacingOccurrences(of: ",", with: "."))
                                }
                            }
                        Text("min")
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 10)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AppConstants.accentOrangeColor)
                        
                    })
                    Button(action: {
                        self.time = nil
                        timeText = ""
                    }, label: {
                        Image(systemName: "minus.circle")
                            .foregroundStyle(.red)
                    })
                }
            }
            
            // Distance
            if self.distance == nil {
                HStack {
                    Button(action: {
                        self.distance = 0.33
                    }, label: {
                        Text("+ Add total distance")
                            .bold()
                    })
                    .foregroundColor(.secondary)
                    .bold()
                    Spacer()
                }
                .padding(.vertical, 3)
            } else {
                HStack {
                    Text("Total distance:")
                        .fontWeight(.semibold)
                    Spacer()
                    HStack {
                        TextField("0.33", text: self.$distanceText) {
                            UIApplication.shared.endEditing()
                        }
                            .frame(width: 43)
                            .keyboardType(.numbersAndPunctuation)
                            .onChange(of: distanceText) {
                                if Float(distanceText.replacingOccurrences(of: ",", with: ".")) != nil {
                                    self.distance = Float(distanceText.replacingOccurrences(of: ",", with: "."))
                                }
                            }
                        Text("km")
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 10)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AppConstants.accentOrangeColor)
                    })
                    Button(action: {
                        self.distance = nil
                        distanceText = ""
                    }, label: {
                        Image(systemName: "minus.circle")
                            .foregroundStyle(.red)
                    })
                }
            }
            
            // Weight
            if self.weight == nil {
                HStack {
                    Button(action: {
                        self.weight = 7.5
                    }, label: {
                        Text("+ Add weight")
                            .bold()
                    })
                    .foregroundColor(.secondary)
                    .bold()
                    Spacer()
                }
                .padding(.vertical, 3)
            } else {
                HStack {
                    Text("Weight:")
                        .fontWeight(.semibold)
                    Spacer()
                    HStack {
                        TextField("7.5", text: self.$weightText) {
                            UIApplication.shared.endEditing()
                        }
                            .frame(width: 43)
                            .keyboardType(.numbersAndPunctuation)
                            .onChange(of: weightText) {
                                if Float(weightText.replacingOccurrences(of: ",", with: ".")) != nil {
                                    self.weight = Float(weightText.replacingOccurrences(of: ",", with: "."))
                                }
                            }
                        Text("kg")
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 10)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AppConstants.accentOrangeColor)
                        
                    })
                    Button(action: {
                        self.weight = nil
                        weightText = ""
                    }, label: {
                        Image(systemName: "minus.circle")
                            .foregroundStyle(.red)
                    })
                }
            }
            
            // Sets
            if self.sets == nil {
                HStack {
                    Button(action: {
                        self.sets = 1
                    }, label: {
                        Text("+ Add sets")
                            .bold()
                    })
                    .foregroundColor(.secondary)
                    .bold()
                    Spacer()
                }
                .padding(.vertical, 3)
            } else {
                HStack {
                    Text("Sets:")
                        .fontWeight(.semibold)
                    Spacer()
                    HStack {
                        TextField("1", text: self.$setsText) {
                            UIApplication.shared.endEditing()
                        }
                            .frame(width: 20)
                            .keyboardType(.numbersAndPunctuation)
                            .onChange(of: setsText) {
                                if Int(setsText.replacingOccurrences(of: ",", with: ".")) != nil {
                                    self.sets = Int(setsText.replacingOccurrences(of: ",", with: "."))
                                }
                            }
                        Text("sets")
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 10)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AppConstants.accentOrangeColor)
                        
                    })
                    Button(action: {
                        self.sets = nil
                        setsText = ""
                    }, label: {
                        Image(systemName: "minus.circle")
                            .foregroundStyle(.red)
                    })
                }
            }
            
            // Reps
            if self.reps == nil {
                HStack {
                    Button(action: {
                        self.reps = 1
                    }, label: {
                        Text("+ Add repetitions")
                            .bold()
                    })
                    .foregroundColor(.secondary)
                    .bold()
                    Spacer()
                }
                .padding(.top, 3)
            } else {
                HStack {
                    Text("Repetitions:")
                        .fontWeight(.semibold)
                    Spacer()
                    HStack {
                        TextField("1", text: self.$repsText) {
                            UIApplication.shared.endEditing()
                        }
                            .frame(width: 20)
                            .keyboardType(.numbersAndPunctuation)
                            .onChange(of: repsText) {
                                if (Int(repsText.replacingOccurrences(of: ",", with: ".")) != nil) {
                                    self.reps = Int(repsText.replacingOccurrences(of: ",", with: "."))
                                }
                            }
                        Text("rep.")
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 10)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AppConstants.accentOrangeColor)
                        
                    })
                    Button(action: {
                        self.reps = nil
                        repsText = ""
                    }, label: {
                        Image(systemName: "minus.circle")
                            .foregroundStyle(.red)
                    })
                }
            }
        }
        .padding()
                        
    }
}

//#Preview {
//    AddExerciseView()
//}
