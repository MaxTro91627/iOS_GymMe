//
//  TrainingViewModel.swift
//  GymMe
//
//  Created by Максим Троицкий on 03.04.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

class TrainingsViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var personModel: PersonModel?
    @Published var trainings: [Training] = []
    @Published var currentExercises: [Exercise] = []
    
    @Published var trainingName: String = ""
    @Published var trainingNote: String = ""
    @Published var id: String = ""

    
    @Published var image: UIImage?
    
    init() {
        fetchCurrentUser()
    }
    
    func clearFields() {
        trainingName = ""
        trainingNote = ""
        currentExercises = []
        image = nil
    }
    
    func getTraining() -> TrainingEntity {
        var currentExerciseEntyties: [ExcerciseEntity] = []
        for excercise in currentExercises {
            let excEnt = ExcerciseEntity(id: excercise.id, name: excercise.name, time: excercise.time, distance: excercise.distance, weight: excercise.weight, sets: excercise.sets, repetitions: excercise.repetitions, notes: excercise.notes)
            currentExerciseEntyties.append(excEnt)
        }
        self.id = UUID().uuidString
        return TrainingEntity(id: UUID().uuidString, trainingDate: .now, trainingName: self.trainingName, exercises: currentExerciseEntyties, trainingNote: self.trainingNote, trainingImage: "")
    }

    func storeTraining(imageUrl: URL?) {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        var trainings = FirebaseManager.shared.currentUser?.trainings
        let training = Training(id: self.id, trainingDate: .now, trainingName: self.trainingName, exercises: currentExercises, trainingNote: self.trainingNote, trainingImage: imageUrl?.absoluteString ?? "")
        trainings?.append(training)
        var exercisesData: [[String: Any]] = []
        for exercise in training.exercises {
            let exerciseData = [
                "id": exercise.id,
                "name": exercise.name,
                "time": exercise.time as Any,
                "distance": exercise.distance as Any,
                "weight": exercise.weight as Any,
                "sets": exercise.sets as Any,
                "repetitions": exercise.repetitions as Any,
                "notes": exercise.notes
            ] as [String : Any]
            exercisesData.append(exerciseData)
        }
        let trainingData = [
            "trainingDate": training.trainingDate,
            "trainingName": training.trainingName,
            "trainingNote": training.trainingNote,
            "exercises": exercisesData,
            "trainingImage": training.trainingImage ?? "",
            "id": training.id
        ] as [String : Any]

        FirebaseManager.shared.firestore.collection("users").document(uid).updateData([
            "trainings": FieldValue.arrayUnion([trainingData])])
        FirebaseManager.shared.currentUser?.trainings = trainings ?? []

        print("Trainings update")
        self.clearFields()
    }
    
    func persistImageToStorage() {
        let uid = UUID().uuidString
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to push image to Storage: \(err)")
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    print("Failed to retrieve downloadURL: \(err)")
                    return
                }
                
                print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                print(url?.absoluteString ?? "")
                
                guard let url = url else { return }
                
                self.storeTraining(imageUrl: url)
            }
        }
    }
    
    func addTraining() {
        if image == nil {
            self.storeTraining(imageUrl: nil)
        } else {
            self.persistImageToStorage()
        }
    }
    
    func addExercise(exercise: Exercise) {
        currentExercises.append(exercise)
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        let ref = FirebaseManager.shared.firestore.collection("users").document(uid)
        ref.getDocument { (document, error) in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            self.personModel = try? document?.data(as: PersonModel.self)
            FirebaseManager.shared.currentUser = self.personModel
            
        }
    }
    
    func getMonthSectionTrainings(for selectedTrainings: [Training]) -> [[Training]] {
        let sortedSelectedTrainings: [Training] = selectedTrainings.sorted(by: {$0.trainingDate < $1.trainingDate})
        var res = [[Training]]()
        var tmp = [Training]()
        for training in sortedSelectedTrainings {
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
    
    func getSortedTrainings() -> [Training] {
        let sortedTrainings = FirebaseManager.shared.currentUser?.trainings.sorted {
            $0.trainingDate < $1.trainingDate
        }
        return sortedTrainings ?? []
    }
}
