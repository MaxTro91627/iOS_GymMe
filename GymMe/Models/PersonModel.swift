//
//  PersonModel.swift
//  GymMe
//
//  Created by Максим Троицкий on 16.03.2024.
//

import Foundation
import FirebaseFirestoreSwift

struct PersonModel: Codable, Identifiable {
    
    @DocumentID var id: String?
    var nickname: String
    var photoUrl: String
    var phoneNumber: String
    var trainings: [Training]
    var organizedEvents: [EventModel]
    var lovedEvents: [String?]
    var friendsId: [String?]
    var impressions: [Impression]
//    var attendedEvents: [String?]
    
    init (nickname: String, phoneNumber: String) {
        self.nickname = nickname
        self.phoneNumber = phoneNumber
        self.trainings = []
        self.organizedEvents = []
        self.lovedEvents = []
        self.friendsId = []
        self.photoUrl = ""
        self.impressions = []
//        self.attendedEvents = []
    }
}

extension PersonModel {
    func getAttendedEvents() -> [EventModel] {
        return []
//        return attendedEvents
    }
    
    func getPersonId() -> String? {
        return id
    }
    
    func getFriendsId() -> [UUID] {
        return []
//        return friendsId
    }
    
    func getTrainings() -> [Training] {
        return []
//        return trainings
    }
}
