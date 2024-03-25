//
//  PersonModel.swift
//  GymMe
//
//  Created by Максим Троицкий on 16.03.2024.
//

import Foundation

struct PersonModel {
    var id: UUID
    var nickname: String
//    var photo: Data
    var phoneNumber: String
    var Trainings: [Training]
    var organizedEvents: [EventModel]
    var attendedEvents: [EventModel]
    var FriendsId: [UUID]
//    var impressions: [Impression]
}

extension PersonModel {
    func getAttendedEvents() -> [EventModel] {
        return attendedEvents
    }
    
    func getPersonId() -> UUID {
        return id
    }
    
    func getFriendsId() -> [UUID] {
        return FriendsId
    }
    
    func getTrainings() -> [Training] {
        return Trainings
    }
}
