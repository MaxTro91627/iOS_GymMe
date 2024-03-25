//
//  EventModel.swift
//  GymMe
//
//  Created by Максим Троицкий on 14.03.2024.
//

import Foundation

struct EventModel: Identifiable {
    var id: UUID
    var eventName: String
    var eventDiscription: String
    var eventStartTime: Date
    var eventEndTime: Date
    var eventRequirement: String
    // eventPlace
    var eventArranger: UUID
}
