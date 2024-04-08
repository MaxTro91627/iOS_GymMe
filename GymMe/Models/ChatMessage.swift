//
//  ChatMessage.swift
//  GymMe
//
//  Created by Максим Троицкий on 05.04.2024.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    var fromId, toId, text: String
    var timestamp: Date
    var event: EventModel?
}
