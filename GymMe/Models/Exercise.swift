//
//  Excercise.swift
//  GymMe
//
//  Created by Максим Троицкий on 15.03.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Exercise: Codable, Identifiable {
    var id: String
    var name: String
    var time: Float?
    var distance: Float?
    var weight: Float?
    var sets: Int?
    var repetitions: Int?
    var notes: String
}
