//
//  StatisticView.swift
//  GymMe
//
//  Created by Максим Троицкий on 07.04.2024.
//

import SwiftUI

struct StatisticView: View {
    @ObservedObject var statisticViewModel: StatisticViewModel
    @State var startDate: Date = .now
    @State var endDate: Date = .now
    @State var lovedEvents: [EventModel]
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack {
                Text("Choose period")
                    .font(.title)
                    .bold()
                    .foregroundStyle(AppConstants.accentOrangeColor)
                    .hSpacing(.leading)
                    .padding(.horizontal)
                DatePickers()
                    .padding(12)
                    .tint(AppConstants.accentBlueColor)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppConstants.accentBlueColor)
                    })
                    .padding(.horizontal)
                    .onChange(of: startDate) {
                        withAnimation(.easeInOut) {
                            statisticViewModel.getTrainingsInPeriod(start: startDate, end: endDate)
                            statisticViewModel.getEventsInPeriod(start: startDate, end: endDate, events: lovedEvents)
                            statisticViewModel.getExercises()
                        }

                    }
                    .onChange(of: endDate) {
                        withAnimation(.easeInOut) {
                            statisticViewModel.getTrainingsInPeriod(start: startDate, end: endDate)
                            statisticViewModel.getExercises()
                            statisticViewModel.getEventsInPeriod(start: startDate, end: endDate, events: lovedEvents)
                        }
                    }
                ScrollView {
                    Text("Statistics for the period")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.secondary)
                        .hSpacing(.leading)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    Text("\(startDate.format("dd MMM YYYY")) - \(endDate.format("dd MMM YYYY")):")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(AppConstants.accentBlueColor)
                        .hSpacing(.leading)
                        .padding(.horizontal)
                    StatisticInfoView()
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: 2)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .foregroundStyle(AppConstants.lightAccentBlueColor)
                    ExercisesStatisticInfoView()
                }
                Spacer()
            }
            .onAppear() {
                statisticViewModel.getTrainingsInPeriod(start: startDate, end: endDate)
                statisticViewModel.getExercises()
                statisticViewModel.getEventsInPeriod(start: startDate, end: endDate, events: lovedEvents)            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                })
            }
        }
    }
    
    @ViewBuilder
    func StatisticInfoView() -> some View {
        @State var screenWidth = UIScreen.main.bounds.size.width
        HStack {
            VStack {
                Text("Count of trainings:")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Text("\(statisticViewModel.trainingsInPeriod.count)")
                    .padding(.top, 4)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(AppConstants.accentBlueColor)
            }
            .frame(maxWidth: (screenWidth - 32) / 3)
            Divider()
                .frame(maxHeight: 100)
            VStack {
                Text("Count of events:")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Text("\(statisticViewModel.eventCount)")
                    .padding(.top, 4)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(AppConstants.accentBlueColor)
            }
            .frame(maxWidth: (screenWidth - 32) / 3)
            Divider()
                .frame(maxHeight: 100)
            VStack {
                Text("Count of exercises:")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Text("\(statisticViewModel.exerciseCounter)")
                    .padding(.top, 4)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(AppConstants.accentBlueColor)
            }
            .frame(maxWidth: (screenWidth - 32) / 3)
        }
        .padding(.horizontal, 4)
        .padding(.vertical)
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentBlueColor)
        })
        .padding(.horizontal)
        .padding(.top)
        
    }
    
    @ViewBuilder
    func ExercisesStatisticInfoView() -> some View {
        HStack {
            VStack(alignment: .trailing) {
                HStack {
                    Text("Total")
                        .font(.title)
                        .bold()
                        .foregroundStyle(AppConstants.accentOrangeColor)
                    Divider()
                    Text("Avg.")
                        .font(.title)
                        .bold()
                        .foregroundStyle(AppConstants.accentBlueColor)
                }
                HStack {
                    Text("Time:")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(String(format: "%.2f",statisticViewModel.totalTimeByPeriod))
                        .bold()
                        .padding(6)
                        .padding(.horizontal, 10)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppConstants.accentOrangeColor)
                        })
                    Text(String(format: "%.2f",statisticViewModel.averageTimeByPeriod))
                        .bold()
                        .padding(6)
                        .padding(.horizontal, 10)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppConstants.accentBlueColor)
                        })
                }
                HStack {
                    Text("Distance:")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(String(format: "%.2f",statisticViewModel.totalDistanceByPeriod))
                        .bold()
                        .padding(6)
                        .padding(.horizontal, 10)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppConstants.accentOrangeColor)
                        })
                    Text(String(format: "%.2f",statisticViewModel.averageDistanceByPeriod))
                        .bold()
                        .padding(6)
                        .padding(.horizontal, 10)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppConstants.accentBlueColor)
                        })
                }
                HStack {
                    Text("Repetitions:")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(String(format: "%.2f",statisticViewModel.totalRepsByPeriod))
                        .bold()
                        .padding(6)
                        .padding(.horizontal, 10)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppConstants.accentOrangeColor)
                        })
                    Text(String(format: "%.2f",statisticViewModel.averageRepsByPeriod))
                        .bold()
                        .padding(6)
                        .padding(.horizontal, 10)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppConstants.accentBlueColor)
                        })
                }
                    
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func DatePickers() -> some View {
        HStack {
            VStack {
                DatePicker("Choose start date", selection: $startDate, in: ...Date(), displayedComponents: .date)
                Divider()
                DatePicker("Choose end date", selection: $endDate, in: PartialRangeFrom(.now), displayedComponents: .date)
            }
        }
    }
}

//#Preview {
//    StatisticView()
//}
