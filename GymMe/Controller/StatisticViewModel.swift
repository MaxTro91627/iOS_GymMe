//
//  StatisticViewModel.swift
//  GymMe
//
//  Created by Максим Троицкий on 06.04.2024.
//

import Foundation

class StatisticViewModel: ObservableObject {
    @Published var maxTime: Float = 0.0
    @Published var maxDistance: Float = 0.0
    @Published var maxReps: Float = 0
    
    @Published var maxTimeByPeriod: Float = 0.0
    @Published var maxDistanceByPeriod: Float = 0.0
    @Published var maxRepsByPeriod: Float = 0
    
    @Published var totalTimeByPeriod: Float = 0.0
    @Published var totalDistanceByPeriod: Float = 0.0
    @Published var totalRepsByPeriod: Float = 0
    
    @Published var averageTimeByPeriod: Float = 0.0
    @Published var averageDistanceByPeriod: Float = 0.0
    @Published var averageRepsByPeriod: Float = 0
    
    @Published var exerciseCounter = 0
    @Published var eventCount = 0
    
    @Published var trainings: [Training]
    @Published var trainingsInPeriod: [Training] = []
    
    init(trainings: [Training]) {
        self.trainings = trainings
        countMax()
    }
    
    func getExercises() {
        self.totalTimeByPeriod = 0.0
        self.totalDistanceByPeriod = 0.0
        self.totalRepsByPeriod = 0
        
        self.averageTimeByPeriod = 0.0
        self.averageDistanceByPeriod = 0.0
        self.averageRepsByPeriod = 0.0
        
        
        exerciseCounter = 0
        var timeCounter = 0
        var distanceCounter = 0
        var repsCounter = 0
        for training in trainingsInPeriod {
            for exercise in training.exercises {
                if (exercise.time != nil) {
                    self.totalTimeByPeriod += exercise.time!
                    timeCounter += 1
                }
                if (exercise.distance != nil) {
                    self.totalDistanceByPeriod += exercise.distance!
                    distanceCounter += 1
                }
                if (exercise.repetitions != nil) {
                    var rep = exercise.repetitions!
                    if exercise.sets != nil {
                        rep *= exercise.sets!
                    }
                    self.totalRepsByPeriod += Float(rep)
                    repsCounter += 1
                }
                self.exerciseCounter += 1
            }
        }
        if timeCounter != 0 {
            self.averageTimeByPeriod = totalTimeByPeriod / Float(timeCounter)
        }
        if distanceCounter != 0 {
            self.averageDistanceByPeriod = totalDistanceByPeriod / Float(distanceCounter)
        }
        if repsCounter != 0 {
            self.averageRepsByPeriod = totalRepsByPeriod / Float(repsCounter)
        }
    }
 
    func getTrainingsInPeriod(start startDate: Date, end endDate: Date) {
        trainingsInPeriod.removeAll()
        let trains = self.trainings.filter({ $0.trainingDate <= endDate && $0.trainingDate >= startDate })
        self.trainingsInPeriod = trains
    }
    
    func getEventsInPeriod(start startDate: Date, end endDate: Date, events: [EventModel]) {
        self.eventCount = events.filter({ $0.eventDate <= endDate && $0.eventDate >= startDate }).count
    }
    
    func wasEvent(off: Int, events: [EventModel]) -> Bool {
        let day = Date().daysAgo(days: off).startOfDay()
        for event in events {
            if event.eventDate == day {
                return true
            }
            if event.eventDate.daysBetween(date: .now) > 70 {
                return false
            }
        }
        return false
    }
    
    func countMax() {
        for training in trainings {
            var time: Float = 0.0
            var dist: Float = 0.0
            var repet: Float = 0.0
            for exercise in training.exercises {
                if exercise.time != nil {
                    time += exercise.time!
                }
                if exercise.distance != nil {
                    dist += exercise.distance!
                }
                if exercise.repetitions != nil {
                    var rep = exercise.repetitions!
                    if exercise.sets != nil {
                        rep *= exercise.sets!
                    }
                    repet += Float(rep)
                }
            }
            if time > self.maxTime {
                self.maxTime = time
            }
            if dist > self.maxDistance {
                self.maxDistance = dist
            }
            if repet > self.maxReps {
                self.maxReps = repet
            }
        }
    }
    
    func countStat(for training: Training) -> Float {
        var stat = 0.0
        for exercise in training.exercises {
            if exercise.time != nil {
                stat += Double(exercise.time! / maxTime)
            }
            if exercise.distance != nil {
                stat += Double(exercise.distance! / maxDistance)
            }
            if exercise.repetitions != nil {
                var rep = exercise.repetitions!
                if exercise.sets != nil {
                    rep *= exercise.sets!
                }
                stat += Double(Float(rep) / maxReps)
            }
        }
        return Float(stat)
    }
    
    func countTenWeeks() -> [Float] {
        var dayStat: Float = 0.0
        var statList: [Float] = []
        for off in 0..<70 {
            dayStat = 0
            let offDay = Date().daysAgo(days: off)
            if let idx = trainings.firstIndex(where: {$0.trainingDate.startOfDay() == offDay}) {
                let training = trainings[idx]
                dayStat = countStat(for: training)
            }
            statList.append(dayStat)
        }
        return statList
    }
}
