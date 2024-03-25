//
//  EventController.swift
//  GymMe
//
//  Created by Максим Троицкий on 14.03.2024.
//

import Foundation

class EventController {
    private var listOfEvents: [EventModel]
    
    init() {
        self.listOfEvents = [
            EventModel(id: UUID(), eventName: "First Event Name", eventDiscription: "First Event Discription", eventStartTime: .now, eventEndTime: .now, eventRequirement: "Frist Event Requirment List", eventArranger: UUID()),
//            EventModel(id: UUID(), eventName: "Second Event Name", eventDiscription: "Second Event Discription", eventStartTime: .now, eventEndTime: .now, eventRequirement: "Second Event Requirment List", eventArranger: UUID()),
//            EventModel(id: UUID(), eventName: "Third Event Name", eventDiscription: "Third Event Discription", eventStartTime: .now, eventEndTime: .now, eventRequirement: "Third Event Requirment List", eventArranger: UUID()),
//            EventModel(id: UUID(), eventName: "Third Event Name", eventDiscription: "Third Event Discription", eventStartTime: .now, eventEndTime: .now, eventRequirement: "Third Event Requirment List", eventArranger: UUID()),
//            EventModel(id: UUID(), eventName: "Third Event Name", eventDiscription: "Third Event Discription", eventStartTime: .now, eventEndTime: .now, eventRequirement: "Third Event Requirment List", eventArranger: UUID()),
//            EventModel(id: UUID(), eventName: "Third Event Name", eventDiscription: "Third Event Discription", eventStartTime: .now, eventEndTime: .now, eventRequirement: "Third Event Requirment List", eventArranger: UUID()),
//            EventModel(id: UUID(), eventName: "Third Event Name", eventDiscription: "Third Event Discription", eventStartTime: .now, eventEndTime: .now, eventRequirement: "Third Event Requirment List", eventArranger: UUID()),
//            EventModel(id: UUID(), eventName: "Third Event Name", eventDiscription: "Third Event Discription", eventStartTime: .now, eventEndTime: .now, eventRequirement: "Third Event Requirment List", eventArranger: UUID()),
//            EventModel(id: UUID(), eventName: "Third Event Name", eventDiscription: "Third Event Discription", eventStartTime: .now, eventEndTime: .now, eventRequirement: "Third Event Requirment List", eventArranger: UUID())
        ]
    }
}

extension EventController {
    func getListOfEvents() -> [EventModel] {
        return listOfEvents
    }
}
