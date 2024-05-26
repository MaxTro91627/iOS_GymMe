//
//  GymMeApp.swift
//  GymMe
//
//  Created by Максим Троицкий on 29.02.2024.
//

import SwiftUI
import Firebase
import SwiftData

@main
struct GymMeApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var authController: AuthController = .init()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("log_status") var log_status: Bool = false
    var body: some Scene {
        WindowGroup {
            if log_status {
                ContentView()
                    .modelContainer(for: TrainingEntity.self)
            } else {
                AuthView(authController: authController)
            }
//                .preferredColorScheme(.dark)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//            
//        }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        return .noData
    }
}
