//
//  GymMeApp.swift
//  GymMe
//
//  Created by Максим Троицкий on 29.02.2024.
//

import SwiftUI

@main
struct GymMeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .preferredColorScheme(.dark)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
