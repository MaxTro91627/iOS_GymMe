//
//  Training.swift
//  GymMe
//
//  Created by Максим Троицкий on 15.03.2024.
//

import Foundation

struct Training : Identifiable {
    var id: UUID
    var trainingDate: Date
    var trainingName: String
    var exercises: [Excercise]
    var triningNote: String
//    var trainingImage: Data
}
