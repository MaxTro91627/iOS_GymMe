//
//  HomeViewController.swift
//  GymMe
//
//  Created by Максим Троицкий on 02.04.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

class HomeViewController: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var personModel: PersonModel?
    @Published var showRegistration = false
    @Published var eventInfo: EventModel?
    
    init() {
        fetchCurrentUser()
    }
    
    func updateUserInfo() {
        
    }
    
//    func checkTime(for eventId: String?) -> Bool {
//        var time: Date = .now
//        let ref = FirebaseManager.shared.firestore.collection("events").document(eventId!)
//        ref.getDocument(source: .cache) { (document, error) in
//            if let error = error {
//                self.errorMessage = "Failed to fetch current user: \(error)"
//                print("Failed to fetch current user:", error)
//                return
//            }
//            time = (document!.data()!["eventEndTime"] as! Timestamp).dateValue()
//        }
//        print(time, Date())
//        return time < Date()
//    }
    
    func addLovedEvent(id: String?) {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        var lovedEvents = FirebaseManager.shared.currentUser?.lovedEvents
        lovedEvents?.append(id)
//        let attendedEvents = lovedEvents?.filter({checkTime(for: $0)})
        
        FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["lovedEvents": lovedEvents as Any])
        FirebaseManager.shared.currentUser?.lovedEvents = lovedEvents ?? []
//        FirebaseManager.shared.currentUser?.attendedEvents = attendedEvents ?? []
        print("Attended Events update")
    }
    
    func deleteLovedEvent(id: String?) {
        FirebaseManager.shared.currentUser?.lovedEvents.removeAll(where: {id == $0})
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        let lovedEvents = FirebaseManager.shared.currentUser?.lovedEvents
        
        FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["lovedEvents": lovedEvents as Any])
//        updateAttendedEvents()
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
}
