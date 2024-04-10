//
//  FirebaseManager.swift
//  GymMe
//
//  Created by Максим Троицкий on 31.03.2024.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    var currentUser: PersonModel?
    
    static let shared = FirebaseManager()
    
    override init() {
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
}
