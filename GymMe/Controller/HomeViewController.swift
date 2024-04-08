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
    @Published var friends: [PersonModel] = []
    
    init() {
        fetchCurrentUser()
    }
    
    func updateUserInfo() {
        
    }
    
    private func persistRecentMessage(toId friend: PersonModel, inviteEventName: String) {
        guard let personModel = personModel else { return }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(friend.id!)
        
        let data = [
            "timestamp": Timestamp(),
            "text": "Event Invite: \(inviteEventName)",
            "fromId": uid,
            "toId": friend.id!,
            "profileImageUrl": friend.photoUrl,
            "nickname": friend.nickname
        ] as [String : Any]
        
        // you'll need to save another very similar dictionary for the recipient of this message...how?
        
        document.setData(data) { error in
            if let error = error {
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            "timestamp": Timestamp(),
            "text": "Event Invite: \(inviteEventName)",
            "fromId": uid,
            "toId": friend.id!,
            "profileImageUrl": currentUser.photoUrl,
            "nickname": currentUser.nickname
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(friend.id!)
            .collection("messages")
            .document(currentUser.id!)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    
    func sendInvite(to personIds: [String?], inviteEvent: EventModel) {
        getFriends(friendsId: personIds)
        guard let fromId = FirebaseManager.shared.currentUser?.id else { return }
        for personId in personIds {
            let document = FirebaseManager.shared.firestore.collection("messages").document(fromId).collection(personId!).document()
            
            let eventData = ["id": inviteEvent.id as Any,
                             "eventId": inviteEvent.id as Any,
                             "eventName": inviteEvent.eventName,
                             "eventImageUrl": inviteEvent.eventImageUrl,
                             "eventDiscription": inviteEvent.eventDiscription,
                             "eventStartTime": inviteEvent.eventStartTime,
                             "eventEndTime": inviteEvent.eventEndTime,
                             "eventRequirement": inviteEvent.eventRequirement,
                             "eventDate": inviteEvent.eventDate,
                             "eventArrangerName": inviteEvent.eventArrangerName] as [String : Any]
            let messageData = ["fromId": fromId, "toId": personId as Any, "text": "", "timestamp": Timestamp(), "event": eventData] as [String : Any]
            
            document.setData(messageData) { error in
                if let error = error {
                    print(error)
                    return
                }
                
                print("Successfully saved current user sending message")
                
                self.persistRecentMessage(toId: self.friends.first(where: { $0.id == personId})!, inviteEventName: inviteEvent.eventName)
            }
            
            let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
                .document(personId!)
                .collection(fromId)
                .document()
            
            recipientMessageDocument.setData(messageData) { error in
                if let error = error {
                    print(error)
                    return
                }
                
                print("Recipient saved message as well")
            }
        }
    }
    
    func getFriends(friendsId: [String?]) {
        friends.removeAll()
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
        
        FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["lovedEvents": lovedEvents as Any])
        FirebaseManager.shared.currentUser?.lovedEvents = lovedEvents ?? []
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
            self.getFriends(friendsId: FirebaseManager.shared.currentUser!.friendsId)
        }
    }
}
