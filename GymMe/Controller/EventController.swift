//
//  EventController.swift
//  GymMe
//
//  Created by Максим Троицкий on 14.03.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

class EventController: ObservableObject {
    @Published var listOfEvents = [EventModel]()
    @Published var lovedEvents = [EventModel]()
    @Published var eventName: String = ""
    @Published var eventDiscription: String = ""
    @Published var eventStartTime: Date = .now
    @Published var eventEndTime: Date = .now
    @Published var eventRequirement: String = ""
    @Published var eventDate: Date = .now
    // eventPlace
    @Published var image: UIImage?
    private var firestoreListener: ListenerRegistration?
    private var firestoreListener1: ListenerRegistration?
        init() {
            fetchEvents(eventDate: .now.startOfDay())
    //        fetchEvents()
    //        self.listOfEvents = [
    //            EventModel(id: UUID(), eventName: "First Event Name", eventDiscription: "First Event Discription", eventStartTime: .now, eventEndTime: .now, eventRequirement: "Frist Event Requirment List", eventArranger: UUID()),
    //        ]
        }
    
    func fetchLovedEvents(in eventsId: [String?], eventDate: Date) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        
        firestoreListener1?.remove()
        self.lovedEvents.removeAll()
//        
        firestoreListener1 = FirebaseManager.shared.firestore.collection("events")
            .whereField("eventDate", isEqualTo: eventDate)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    //                    self.errorMessage = "Failed to listen for recent messages: \(error)"
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
    
    func fetchEvents(eventDate: Date) {
//        Task {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            
            firestoreListener?.remove()
            self.listOfEvents.removeAll()
            
            firestoreListener = FirebaseManager.shared.firestore.collection("events")
                .whereField("eventDate", isEqualTo: eventDate)
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        //                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                        print(error)
                        return
                    }
                    
                    querySnapshot?.documentChanges.forEach({ change in
                        let docId = change.document.documentID
                        
                        if let index = self.listOfEvents.firstIndex(where: { rm in
                            return rm.id == docId
                        }) {
                            self.listOfEvents.remove(at: index)
                        }
                        
                        do {
                            if let rm = try change.document.data(as: EventModel?.self) {
                                self.listOfEvents.insert(rm, at: 0)
                            }
                        } catch {
                            print(error)
                        }
                    })
                }
//            await MainActor.run(body: {
//                let lovedEventsId = FirebaseManager.shared.currentUser?.lovedEvents ?? []
//                self.lovedEvents = listOfEvents.filter({lovedEventsId.contains($0.id)})
//            })
//        }
    }
    
    private func storeEvent(imageUrl: URL?) {
        let eventArranger = FirebaseManager.shared.currentUser!.nickname
        let uid = UUID().uuidString
        let imageUrlString: String = imageUrl?.absoluteString ?? ""
        let eventData = [
            "eventName": self.eventName,
            "eventImageUrl": imageUrlString,
            "eventDiscription": self.eventDiscription,
            "eventStartTime": self.eventStartTime,
            "eventEndTime": self.eventEndTime,
            "eventRequirement": self.eventRequirement,
            "eventDate": self.eventStartTime.startOfDay(),
            "eventArrangerName": eventArranger
        ] as [String : Any]
        FirebaseManager.shared.firestore.collection("events").document(uid).setData(eventData) { err in
            if let err = err {
                print(err)
                return
            }
            print("Success")
            self.clearFields()
        }
    }
    
    private func persistImageToStorage() {
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
                
                self.storeEvent(imageUrl: url)
            }
        }
    }
    
    // MARK: - CreateEvent
    func createEvent() {
        if image == nil {
            self.storeEvent(imageUrl: nil)
        } else {
            self.persistImageToStorage()
        }
    }
    
    func clearFields() {
        eventName = ""
        eventDiscription = ""
        eventStartTime = .now
        eventEndTime = .now
        eventRequirement = ""
        eventDate = .now
        image = nil
    }
}


extension EventController {
    func getListOfEvents() -> [EventModel] {
        return listOfEvents
    }
    
    func getLovedEvents() -> [EventModel] {
        return lovedEvents
    }
}
