//
//  ImpressionModel.swift
//  GymMe
//
//  Created by Максим Троицкий on 02.04.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Impression: Codable, Identifiable {
    @DocumentID var id: String?
    var imageUrl: String
    var personId: String?
    var publicationDate: Date
}
