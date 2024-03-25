//
//  ProfileController.swift
//  GymMe
//
//  Created by Максим Троицкий on 16.03.2024.
//

import Foundation

struct ProfileController {
    var person: PersonModel
    
    init() {
        self.person = PersonModel(id: UUID(), nickname: "nickname", phoneNumber: "+7 (999) 999-99-99", Trainings: [], organizedEvents: [], attendedEvents: [], FriendsId: [])
    }
}

extension ProfileController {
    func getAttendedEvents() -> [EventModel] {
        return person.getAttendedEvents()
    }
    
    func getPerson() -> PersonModel {
        return person
    }
    
    func getPersonId() -> UUID {
        return person.getPersonId()
    }
    
}
