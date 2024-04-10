//
//  ChatView.swift
//  GymMe
//
//  Created by Максим Троицкий on 04.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestoreSwift

class ChatsViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var personModel: PersonModel?
    @Published var isUserCurrentlyLoggedOut = false
    @Published var userInfo: PersonModel?
    
    @Published var recentMessages: [RecentMessage] = []
    private var firestoreListener: ListenerRegistration?
    
    init() {
        
//        DispatchQueue.main.async {
//            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
//        }
        
        fetchCurrentUser()
        
        fetchRecentMessages()
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
    
    
    
    func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        firestoreListener?.remove()
        self.recentMessages.removeAll()
        
        firestoreListener = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: RecentMessage?.self) {
                            self.recentMessages.insert(rm, at: 0)
                        }
                    } catch {
                        print(error)
                    }
                })
            }
    }
    
    func getRecentMessages() -> [RecentMessage] {
        return self.recentMessages
    }
    
    func getUserInfo(id: String?) {
        let ref = FirebaseManager.shared.firestore.collection("users").document(id!)
        ref.getDocument { (document, error) in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            self.userInfo = try? document?.data(as: PersonModel?.self)
        }
    }
    
//    func handleSignOut() {
//        isUserCurrentlyLoggedOut.toggle()
//        try? FirebaseManager.shared.auth.signOut()
//    }
    
}

struct ChatsView: View {
    @ObservedObject private var chatsViewModel: ChatsViewModel = .init()
    @State var personModel: PersonModel?
    @State var shouldShowNewMessageScreen = false
    @State var shouldNavigateToChatLogView = false
    @State var searchText: String = ""
    
    @ObservedObject private var messagesViewModel: MessagesViewModel = .init()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search your friend", text: $searchText){
                        UIApplication.shared.endEditing()
                    }
                        .lineLimit(1)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppConstants.accentOrangeColor)
                        })
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                }
                ScrollView {
                    let recentMessages = chatsViewModel.getRecentMessages()
                    ForEach(chatsViewModel.recentMessages) { recentMessage in
                        VStack {
                            if (recentMessage.nickname.lowercased().contains(searchText.lowercased())) {
                                RecentMessageCell(recentMessage: recentMessage)
                            } else if (searchText == "") {
                                RecentMessageCell(recentMessage: recentMessage)
                            }
                        }
                    }
                }
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    MessagesView(messagesViewModel: self.messagesViewModel)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    shouldShowNewMessageScreen.toggle()
                }, label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                })
            }
        }
        .navigationTitle("Chats")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
            NewMessageView(didSelectNewUser: { user in
                print(user.nickname)
                self.shouldNavigateToChatLogView.toggle()
                self.personModel = user
                self.messagesViewModel.personModel = user
                self.messagesViewModel.fetchMessages()
            })
        }
    }
    
    @ViewBuilder
    func RecentMessageCell(recentMessage: RecentMessage) -> some View {
        Button(action: {
            let uid = FirebaseManager.shared.currentUser?.id == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
            
            self.messagesViewModel.getUserInfo(id: uid)
//                                self.personModel = chatsViewModel.userInfo
//                                self.messagesViewModel.personModel = chatsViewModel.userInfo
            
            self.messagesViewModel.fetchMessages()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.shouldNavigateToChatLogView.toggle()
            })
            
        }, label: {
            HStack(spacing: 16) {
                if recentMessage.profileImageUrl != "" {
                    WebImage(url: URL(string: recentMessage.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipped()
                        .cornerRadius(64)
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .foregroundStyle(AppConstants.accentBlueColor)
                        .padding(15)
                        .background(content: {
                            Circle()
                                .stroke(AppConstants.accentOrangeColor)
                        })
                        .frame(width: 64, height: 64)
                        .padding(1)
                }
                
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(recentMessage.nickname)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    Text(recentMessage.text)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                
                Text(recentMessage.timeAgo)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppConstants.accentBlueColor)
            }
        })
        .padding(.vertical, 2)
        .foregroundStyle(.primary)
        .padding(.horizontal)
        RoundedRectangle(cornerRadius: 10)
            .fill(AppConstants.accentBlueColor)
            .frame(height: 2)
            .opacity(0.2)
            .padding(.leading, 90)
            .padding(.trailing, 10)
    }
}



#Preview {
    ChatsView()
}
