//
//  EventModel.swift
//  GymMe
//
//  Created by Максим Троицкий on 14.03.2024.
//

import Foundation
import FirebaseFirestoreSwift

struct EventModel: Codable, Identifiable {
    @DocumentID var id: String?
    var eventName: String
    var eventImageUrl: String
    var eventDiscription: String
    var eventStartTime: Date
    var eventEndTime: Date
    var eventRequirement: String
    var eventDate: Date
    var eventId: String?
    var eventPlace: String
    var eventArrangerName: String
    var eventArrangerId: String?
}

//extension [EventModel] {
//    func filteredWith(startTime: Date, endTime: Date, tag = ) {
//
//    }
//}
