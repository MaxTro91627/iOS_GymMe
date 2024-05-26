//
//  ContentView.swift
//  GymMe
//
//  Created by Максим Троицкий on 29.02.2024.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseFirestoreSwift


class ContentViewController: ObservableObject {
    
    
    @Published var errorMessage = ""
    @Published var personModel: PersonModel?
    @Published var showRegistration = false
    init() {
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        let ref = FirebaseManager.shared.firestore.collection("users").document(uid)
        ref.getDocument { (document, error) in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            self.personModel = try? document?.data(as: PersonModel.self)
            FirebaseManager.shared.currentUser = self.personModel
            
        }
    }
}

struct ContentView: View {
//    @ObservedObject private var vc = ContentViewController()
    @State var selectedViewIndex: Int = 0;
    @Namespace private var animation
    @Query private var trainings: [TrainingEntity]
    @Environment(\.modelContext) private var context
    let tabbarImages = ["house", "dumbbell", "message.badge", "person"]
    var body: some View {
        NavigationStack {
            
            VStack {
                //                Text(vc.personModel?.nickname ?? "NIGGGA")
                //                    .font(.title)
                //                Text(FirebaseManager.shared.currentUser?.nickname ?? "NIGGGA")
                //                    .font(.title)
                ZStack {
                    switch selectedViewIndex {
                    case 1:
                        TrainingsView()
                            .modelContainer(for: TrainingEntity.self)
                    case 2:
                        ChatsView()
                    case 3:
                        ProfileView()
                    default:
                        HomeView()
                    }
                }
                Spacer()
                ZStack {
                    HStack(alignment: .center) {
                        Spacer()
                        ForEach(0..<4) { num in
                            Spacer()
                            VStack {
                                Image(systemName:  tabbarImages[num])
                                    .font(.system(size: 30))
                                    .rotationEffect(.degrees(num == 1 ? -45 : 0))
                                    .foregroundColor(selectedViewIndex == num ? AppConstants.accentOrangeColor : .secondary)
                                //                                    .overlay (
                                //                                        RoundedRectangle(cornerRadius: 40)
                                //                                            .stroke(selectedViewIndex == num ? AppConstants.accentOrangeColor : .black, lineWidth: 2)
                                //                                            .frame(width: 55, height: 55)
                                //
                                //                                    )
                                    .onTapGesture {
                                        //                                    withAnimation() {
                                        selectedViewIndex = num
                                        //                                    }
                                    }
                            }
                            Spacer()
                        }
                        //                        .hSpacing(.center)
                        Spacer()
                    }
                    .background(Color(.systemBackground))
                }
                .frame(maxHeight: 0)
                .padding(.bottom, 10)
                //                .vSpacing(.bottom)
            }
            //            .onAppear() {
            //                vc.fetchCurrentUser()
            //            }
            //            .fullScreenCover(isPresented: $vc.showRegistration, onDismiss: nil) {
            //                RegistrationView()
            //            }
            
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
