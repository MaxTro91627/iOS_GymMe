//
//  NewMessageView.swift
//  GymMe
//
//  Created by Максим Троицкий on 05.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI

class NewMessageViewModel: ObservableObject {
    @Published var users = [PersonModel]()
    @Published var errorMessage = ""
    
    init() {
        getFriends(friendsId: FirebaseManager.shared.currentUser?.friendsId ?? [])
    }
    
    func getFriends(friendsId: [String?]) {
        FirebaseManager.shared.firestore.collection("users")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.users.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.users.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: PersonModel?.self) {
                            if friendsId.contains(rm.id) && rm.id != FirebaseManager.shared.auth.currentUser?.uid {
                                self.users.insert(rm, at: 0)
                            }
                        }
                    } catch {
                        print(error)
                    }
                })
            }
    }
    
//    private func fetchAllUsers() {
//        FirebaseManager.shared.firestore.collection("users")
//            .getDocuments { documentsSnapshot, error in
//                if let error = error {
//                    self.errorMessage = "Failed to fetch users: \(error)"
//                    print("Failed to fetch users: \(error)")
//                    return
//                }
//                
//                documentsSnapshot?.documents.forEach({ snapshot in
//                    let user = try? snapshot.data(as: PersonModel.self)
//                    if user?.id != FirebaseManager.shared.auth.currentUser?.uid {
//                        self.users.append(user!)
//                    }
//                    
//                })
//            }
//    }
}

struct NewMessageView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var newMessageViewModel: NewMessageViewModel = .init()
    let didSelectNewUser: (PersonModel) -> ()
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(newMessageViewModel.users) { user in
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    }, label: {
                        NewMessageUserInfo(user: user)
                    })
                    .foregroundStyle(.primary)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(AppConstants.accentOrangeColor)
                    })
                }
            }
            
        }
    }
    
    @ViewBuilder
    func NewMessageUserInfo(user: PersonModel) -> some View {
        HStack (spacing: 15) {
            if user.photoUrl != "" {
                WebImage(url: URL(string: user.photoUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(50)
            } else {
                Image(systemName: "person")
                    .resizable()
                    .opacity(0.6)
                    .padding(12)
                    .background(content: {
                        Circle()
                            .stroke(AppConstants.accentOrangeColor, lineWidth: 1)
                    })
                    .frame(width: 60, height: 60)
                    .padding(1)
                    .foregroundStyle(AppConstants.accentBlueColor)
            }
            VStack (alignment: .leading, spacing: 10) {
                Text(user.nickname)
                    .bold()
                Text(user.phoneNumber)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(content: {
            RoundedRectangle(cornerRadius: 40)
                .stroke(AppConstants.accentBlueColor)
        })
        .padding(.horizontal)
    }
}

//#Preview {
//    NewMessageView()
//}
