//
//  RecentMessage.swift
//  GymMe
//
//  Created by Максим Троицкий on 04.04.2024.
//

import Foundation
import FirebaseFirestoreSwift

struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    var text: String
    var fromId, toId: String
    var profileImageUrl: String
    var timestamp: Date
    var nickname: String
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
