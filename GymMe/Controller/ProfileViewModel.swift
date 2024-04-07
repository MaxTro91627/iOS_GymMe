//
//  ProfileViewModel.swift
//  GymMe
//
//  Created by Максим Троицкий on 03.04.2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var personModel: PersonModel?
    @Published var userInfo: PersonModel?
    @Published var lovedEvents: [EventModel] = []
    @Published var friends: [PersonModel] = []
    @Published var foundFriends: [PersonModel] = []
//    @Published var attendedEvents:
//    @Published var showRegistration = false
    
    init () {
        fetchCurrentUser()
    }
    
    func getPersonId() -> String? {
        personModel!.getPersonId()
    }
    
    func addFriend(friendId: String?) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        var friends = FirebaseManager.shared.currentUser?.friendsId
        if friends?.filter({$0 == friendId}).count == 0 {
            friends?.append(friendId)
            FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["friendsId": friends as Any])
            FirebaseManager.shared.currentUser?.friendsId = friends ?? []
            print("Attended Events update")
            getFriends(friendsId: friends!)
        }
        
    }
    
    func findFriend(text: String) {
        self.foundFriends.removeAll()
        let ref = FirebaseManager.shared.firestore.collection("users")
        ref.getDocuments { (snapshot, error) in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let phoneNumber: String = data["phoneNumber"] as! String
                    if phoneNumber.contains(text) {
                        if let index = self.foundFriends.firstIndex(where: {$0.phoneNumber == phoneNumber}) {
                            self.foundFriends.remove(at: index)
                        }
                        do {
                            let rm = try document.data(as: PersonModel?.self)
                            self.foundFriends.insert(rm!, at: 0)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    func getFriends(friendsId: [String?]) {
        FirebaseManager.shared.firestore.collection("users")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.friends.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.friends.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: PersonModel?.self) {
                            if friendsId.contains(rm.id) {
                                self.friends.insert(rm, at: 0)
                            }
                        }
                    } catch {
                        print(error)
                    }
                })
            }
    }
    
    func getLovedEvents(eventsId: [String?]) {
//        self.lovedEvents.removeAll()
        FirebaseManager.shared.firestore.collection("events")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.lovedEvents.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.lovedEvents.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: EventModel?.self) {
                            if eventsId.contains(rm.id) {
                                self.lovedEvents.insert(rm, at: 0)
                            }
                        }
                    } catch {
                        print(error)
                    }
                })
            }
    }
//
//    func checkTime(for eventId: String?) -> Bool {
//        var time: Date = .now
//        let ref = FirebaseManager.shared.firestore.collection("events").document(eventId!)
//        ref.getDocument(source: .cache) { (document, error) in
//            if let error = error {
//                self.errorMessage = "Failed to fetch current user: \(error)"
//                print("Failed to fetch current user:", error)
//                return
//            }
//            if let document = document, document.exists {
//                time = (document.get("eventDate") as! Timestamp).dateValue()
//            }
//        }
//        return (time < .now)
//    }
    
//    func updateAttendedEvents() {
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
//            self.errorMessage = "Could not find firebase uid"
//            return
//        }
//        let attendedEvents = FirebaseManager.shared.currentUser?.lovedEvents.filter({checkTime(for: $0)})
//        FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["attendedEvents": attendedEvents as Any])
//        print("Attended Events update")
//    }
    
    func fetchUserInfo(id: String?) {
        Task {
            let ref = FirebaseManager.shared.firestore.collection("users").document(id!)
            ref.getDocument { (document, error) in
                if let error = error {
                    self.errorMessage = "Failed to fetch current user: \(error)"
                    print("Failed to fetch current user:", error)
                    return
                }
                
                self.userInfo = try? document?.data(as: PersonModel?.self)
            }
        }
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
