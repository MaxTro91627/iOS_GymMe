//
//  MessagesView.swift
//  GymMe
//
//  Created by Максим Троицкий on 13.03.2024.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

class MessagesViewModel: ObservableObject {
    @Published var messageText = ""
    var personModel: PersonModel?
    var firestoreListener: ListenerRegistration?
    @Published var chatMessages = [ChatMessage]()
    
    func getUserInfo(id: String?) {
        let ref = FirebaseManager.shared.firestore.collection("users").document(id!)
        ref.getDocument { (document, error) in
            if let error = error {
                print("Failed to fetch current user:", error)
                return
            }
            
            self.personModel = try? document?.data(as: PersonModel?.self)
        }
    }
    
    private func persistRecentMessage() {
        guard let personModel = personModel else { return }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.personModel?.id else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [
            "timestamp": Timestamp(),
            "text": self.messageText,
            "fromId": uid,
            "toId": toId,
            "profileImageUrl": personModel.photoUrl,
            "nickname": personModel.nickname
        ] as [String : Any]
        
        // you'll need to save another very similar dictionary for the recipient of this message...how?
        
        document.setData(data) { error in
            if let error = error {
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            "timestamp": Timestamp(),
            "text": self.messageText,
            "fromId": uid,
            "toId": toId,
            "profileImageUrl": currentUser.photoUrl,
            "nickname": currentUser.nickname
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(toId)
            .collection("messages")
            .document(currentUser.id!)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    
    func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = personModel?.id else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
//                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            if let cm = try change.document.data(as: ChatMessage?.self) {
                                self.chatMessages.append(cm)
                                print("Appending chatMessage in ChatLogView: \(Date())")
                            }
                        } catch {
                            print("Failed to decode message: \(error)")
                        }
                    }
                })
            }
    }
    
    func handleSend() {
        guard let fromId = FirebaseManager.shared.currentUser?.id else { return }
        guard let toId = personModel?.id else { return }
        let document = FirebaseManager.shared.firestore.collection("messages").document(fromId).collection(toId).document()
        
        let messageData = ["fromId": fromId, "toId": toId, "text": self.messageText, "timestamp": Timestamp()] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                print(error)
                return
            }
            
            print("Successfully saved current user sending message")
            
            self.persistRecentMessage()
            
            self.messageText = ""
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print(error)
                return
            }
            
            print("Recipient saved message as well")
        }
    }
}

struct MessagesView: View {
    @ObservedObject var messagesViewModel: MessagesViewModel
    @State var screenWidth = UIScreen.main.bounds.size.width
    @State var sendButtonPressed = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    Rectangle()
                        .fill(AppConstants.accentOrangeColor)
                        .frame(height: 1)
                        .padding(.bottom, 10)
                        .opacity(0.3)
                    VStack {
                        ForEach(messagesViewModel.chatMessages) { message in
                            MessageCell(message: message)
                                .padding(.bottom, 2)
                                .id(message.id)
                        }
                        .onChange(of: messagesViewModel.chatMessages.count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo(self.messagesViewModel.chatMessages.last?.id, anchor: .bottom)
                            }
                        }
                        .onAppear() {
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo(self.messagesViewModel.chatMessages.last?.id, anchor: .bottom)
                            }
                        }
                        .onChange(of: sendButtonPressed) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo(self.messagesViewModel.chatMessages.last?.id, anchor: .bottom)
                            }
                            sendButtonPressed.toggle()
                        }
                        
                        
                        
                        //                    HStack {
                        //                        Spacer()
                        //                        HStack {
                        //                            Text(message.text)
                        ////                            Text("Just a fake message sdkjnsdjknvk jksdbvks bvks bvkb skdvb dskvb skbdv ksbdv ksjbd vkjsb kvskjd bvksb v bskdv ksjdbv ksdkjv bkdjvb ksv bksjdv ks")
                        //                                .frame(width: 250)
                        //                        }
                        //                        .padding(8)
                        //                        .background(content: {
                        //                            RoundedRectangle(cornerRadius: 20)
                        //                                .stroke(AppConstants.accentBlueColor, lineWidth: 2)
                        //                        })
                        //                        .padding(2)
                        //                        .padding(.horizontal)
                        //                    }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, 4)
            
            HStack(spacing: 4) {
                Image(systemName: "paperclip")
                    .foregroundStyle(.secondary)
                    .font(.title3)
                    .padding(.trailing, 4)
                TextField("Write your message here", text: $messagesViewModel.messageText, axis: .vertical)
                    .font(.title3)
                    .lineLimit(3)
                    .padding(4)
                    .padding(.horizontal, 4)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppConstants.accentOrangeColor)
                    })
                
                Button(action: {
                    if (messagesViewModel.messageText != "") {
                        messagesViewModel.handleSend()
                    } else {
                        sendButtonPressed.toggle()
                    }
                }, label: {
                    Image(systemName: "arrow.up.right.circle.fill")
                        .font(.title)
                        .foregroundStyle(.secondary)
                        
                })
                .foregroundStyle(.primary)
            }
            
            .padding(.horizontal)
            .padding(.bottom)
            .padding(.top, 6)
        }
        .onAppear() {
            self.messagesViewModel.fetchMessages()
        }

        .navigationTitle(messagesViewModel.personModel?.nickname ?? "")
        .onDisappear {
            messagesViewModel.firestoreListener?.remove()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem (placement: .topBarTrailing) {
                if messagesViewModel.personModel?.photoUrl != "" {
                    WebImage(url: URL(string: messagesViewModel.personModel?.photoUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                        .clipped()
                        .cornerRadius(64)
                        .padding(.vertical)
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .foregroundStyle(AppConstants.accentBlueColor)
                        .padding(8)
                        .background(content: {
                            Circle()
                                .stroke(AppConstants.accentOrangeColor)
                        })
                        .frame(width: 35, height: 35)
                        .padding(1)
                        .padding(.vertical)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                })
            }
        }
    }
    
    @ViewBuilder
    func MessageCell(message: ChatMessage) -> some View {
        if message.fromId == FirebaseManager.shared.currentUser?.id {
            HStack(alignment: .bottom) {
                Text(message.timestamp.format("HH:mm"))
                    .fontWeight(.light)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                HStack(alignment: .center) {
                    Text(message.text)
                }
                .padding(8)
                .padding(.horizontal, 2)
                .background(content: {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppConstants.accentBlueColor, lineWidth: 2)
                })
            }
            .hSpacing(.trailing)
            .padding(.horizontal)
            .padding(.leading, 60)
        } else {
            HStack(alignment: .bottom) {
                HStack(alignment: .center) {
                    Text(message.text)
                }
                .padding(8)
                .padding(.horizontal, 2)
                .background(content: {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppConstants.accentOrangeColor, lineWidth: 2)
                })
                Text(message.timestamp.format("HH:mm"))
                    .fontWeight(.light)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            .hSpacing(.leading)
            .padding(.horizontal)
            .padding(.trailing, 60)
        }
    }
}

//#Preview {
//
//}
