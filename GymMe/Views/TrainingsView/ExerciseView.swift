//
//  ExerciseView.swift
//  GymMe
//
//  Created by Максим Троицкий on 04.04.2024.
//

import SwiftUI

struct ExerciseView: View {
    @State var exercise: Exercise
    var body: some View {
        VStack(alignment: .leading) {
            Text(exercise.name)
                .font(.title2)
                .bold()
            handleExerciseParametrs(exercise: exercise)
            if exercise.notes != "" {
                Text("Notes:")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 2)
                Text(exercise.notes)
                    .foregroundStyle(.secondary)
                    .fontWeight(.light)
            }
        }
        .padding()
        .padding(.horizontal, 8)
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentBlueColor, lineWidth: 2)
        })
        .padding(2)
    }
    
    @ViewBuilder
    func handleExerciseParametrs(exercise: Exercise) -> some View {
        VStack {
            
            // Time
            if (exercise.time != nil) {
                HStack {
                    Text("Total time:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppConstants.accentOrangeColor)
                    
                    Spacer()
                    HStack(spacing: 2) {
                        Text(String(format: "%.2f", exercise.time!))
                        Text("min")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 2)
                    .padding(6)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AppConstants.accentOrangeColor)
                    })
                }
            }
            
            // Distance
            if (exercise.distance != nil) {
                HStack {
                    Text("Total distance:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppConstants.accentOrangeColor)
                    
                    Spacer()
                    HStack(spacing: 2) {
                        Text(String(format: "%.2f", exercise.distance!))
                        Text("km")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 2)
                    .padding(6)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AppConstants.accentOrangeColor)
                    })
                }
            }
            
            // Weight
            if (exercise.weight != nil) {
                HStack {
                    Text("Weight:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppConstants.accentOrangeColor)
                    
                    Spacer()
                    HStack(spacing: 2) {
                        Text(String(format: "%.2f", exercise.weight!))
                        Text("kg")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 2)
                    .padding(6)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AppConstants.accentOrangeColor)
                    })
                }
            }
            
            // Sets
            if (exercise.sets != nil) {
                HStack {
                    Text("Sets:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppConstants.accentOrangeColor)
                    
                    Spacer()
                    HStack(spacing: 2) {
                        Text("\(exercise.sets!)")
                        Text("sets")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 2)
                    .padding(6)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AppConstants.accentOrangeColor)
                    })
                }
            }
            
            // Reps
            if (exercise.repetitions != nil) {
                HStack {
                    Text("Repetitions:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppConstants.accentOrangeColor)
                    
                    Spacer()
                    HStack(spacing: 2) {
                        Text("\(exercise.repetitions!)")
                        Text("reps.")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 2)
                    .padding(6)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AppConstants.accentOrangeColor)
                    })
                }
            }
        }
    }
}

//#Preview {
//    ExerciseView()
//}
