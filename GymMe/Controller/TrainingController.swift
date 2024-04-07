//
//  TrainingController.swift
//  GymMe
//
//  Created by Максим Троицкий on 15.03.2024.
//

import Foundation

class TrainingController {
    private var trainings : [Training]
    
    init() {
        self.trainings = []
    }
//    init() {
//        self.trainings = [
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -1, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -2, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -3, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -4, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -50, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -100, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -30, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -40, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -60, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -70, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -80, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -90, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -35, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -21, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -25, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -18, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -12, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -112, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -132, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -133, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -134, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -135, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -136, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -137, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: -138, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note"),
//            Training(id: UUID(), trainingDate: Calendar.current.date(byAdding: .day, value: 0, to: .now)!, trainingName: "First Training", exercises: [Exercise(excerciseNotes: "Excercise Note", excerciseWeight: 20.5, excerciseRepetitions: 12, excerciseSets: 3, excerciseName: "Excercise Name")], triningNote: "Training Note")
//            
//        ]
//    }
}

extension TrainingController {
    func getTrainings() -> [Training] {
        return trainings
    }
    
    func getSortedTrainings() -> [Training] {
        let sortedTrainings = trainings.sorted {
            $0.trainingDate < $1.trainingDate
        }
        return sortedTrainings
    }
    
    func getMonthSectionTrainings(for selectedTrainings: [Training]) -> [[Training]] {
        var res = [[Training]]()
        var tmp = [Training]()
//        let sortedTrainings = selectedTrainings.sorted {
//            $0.trainingDate < $1.trainingDate
//        }
        for training in selectedTrainings {
            if let firstTraining = tmp.first {
                let monthsBetween = firstTraining.trainingDate.monthsBetween(date: training.trainingDate)
                if monthsBetween >= 1 {
                    res.append(tmp)
                    tmp.removeAll()
                    tmp.append(training)
                } else {
                    tmp.append(training)
                }
            } else {
                tmp.append(training)
            }
        }
        res.append(tmp)
        return res
    }
    
    func getYearSectionTrainings() -> [[Training]] {
        var res = [[Training]]()
        var tmp = [Training]()
        let sortedTrainings = getSortedTrainings()
        for training in sortedTrainings {
            if let firstTraining = tmp.first {
                let yearsBetween = firstTraining.trainingDate.yearsBetween(date: training.trainingDate)
                if yearsBetween >= 1 {
                    res.append(tmp)
                    tmp.removeAll()
                    tmp.append(training)
                } else {
                    tmp.append(training)
                }
            } else {
                tmp.append(training)
            }
        }
        res.append(tmp)
        return res
    }
}
