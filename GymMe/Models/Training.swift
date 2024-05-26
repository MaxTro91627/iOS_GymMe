//
//  Training.swift
//  GymMe
//
//  Created by Максим Троицкий on 15.03.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Training : Codable, Identifiable {
    var id: String
    var trainingDate: Date
    var trainingName: String
    var exercises: [Exercise]
    var trainingNote: String
    var trainingImage: String?
}

