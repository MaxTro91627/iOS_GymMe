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
    @Published var friends: [PersonModel] = []
    
    
    func addLovedEvent(id: String?) {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        var lovedEvents = FirebaseManager.shared.currentUser?.lovedEvents
        lovedEvents?.append(id)
        
        FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["lovedEvents": lovedEvents as Any])
        FirebaseManager.shared.currentUser?.lovedEvents = lovedEvents ?? []
        print("Attended Events update")
    }
    
    func deleteLovedEvent(id: String?) {
        FirebaseManager.shared.currentUser?.lovedEvents.removeAll(where: {id == $0})
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let lovedEvents = FirebaseManager.shared.currentUser?.lovedEvents
        
        FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["lovedEvents": lovedEvents as Any])
    }
    
    private func persistRecentMessageEv(toId: String?, inviteEventName: String) {
        guard let personModel = personModel else { return }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId!)
        
        let data = [
            "timestamp": Timestamp(),
            "text": "Event Invite: \(inviteEventName)",
            "fromId": uid,
            "toId": toId!,
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
            "text": "Event Invite: \(inviteEventName)",
            "fromId": uid,
            "toId": toId!,
            "profileImageUrl": currentUser.photoUrl,
            "nickname": currentUser.nickname
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(toId!)
            .collection("messages")
            .document(currentUser.id!)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    
    func sendInvite(to personIds: [String?], inviteEvent: EventModel) {
        guard let fromId = FirebaseManager.shared.currentUser?.id else { return }
        for personId in personIds {
            let document = FirebaseManager.shared.firestore.collection("messages").document(fromId).collection(personId!).document()
            
            let eventData = ["id": inviteEvent.eventId as Any,
                             "eventId": inviteEvent.eventId as Any,
                             "eventName": inviteEvent.eventName,
                             "eventImageUrl": inviteEvent.eventImageUrl,
                             "eventDiscription": inviteEvent.eventDiscription,
                             "eventStartTime": inviteEvent.eventStartTime,
                             "eventEndTime": inviteEvent.eventEndTime,
                             "eventRequirement": inviteEvent.eventRequirement,
                             "eventDate": inviteEvent.eventDate,
                             "eventArrangerName": inviteEvent.eventArrangerName,
                             "eventArrangerId": inviteEvent.eventArrangerId as Any,
                             "eventPlace": inviteEvent.eventPlace] as [String : Any]
            let messageData = ["fromId": fromId, "toId": personId as Any, "text": "", "timestamp": Timestamp(), "event": eventData] as [String : Any]
            
            document.setData(messageData) { error in
                if let error = error {
                    print(error)
                    return
                }
                
                print("Successfully saved current user sending message")
                
                self.persistRecentMessageEv(toId: personId, inviteEventName: inviteEvent.eventName)
            }
            
            let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
                .document(personId!)
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
    
    func getFriends(friendsId: [String?]) {
        friends.removeAll()
        FirebaseManager.shared.firestore.collection("users")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.friends.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.friends.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: PersonModel?.self) {
                            if friendsId.contains(rm.id) {
                                self.friends.insert(rm, at: 0)
                            }
                        }
                    } catch {
                        print(error)
                    }
                })
            }
    }
    
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
                                print(cm.event?.eventId)
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
        
        let messageData = ["fromId": fromId as Any as Any, "toId": toId as Any, "text": self.messageText as Any, "timestamp": Timestamp() as Any, "event": nil] as [String : Any]
        
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
    @State var shouldShowEvent: Bool = false
    //    @State var eventToShow: EventModel
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
                            if message.text == "" && message.event != nil {
                                EventInviteCell(message: message)
                                    .padding(.bottom, 2)
                                    .id(message.id)
                            } else {
                                MessageCell(message: message)
                                    .padding(.bottom, 2)
                                    .id(message.id)
                            }
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
        
        //        .sheet(isPresented: $shouldShowEvent, onDismiss: { self.messagesViewModel.fetchMessages() }) {
        //            EventInfo(event: eventToShow)
        //        }
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
    
    @ViewBuilder
    func EventInviteCell(message: ChatMessage) -> some View {
        let event = message.event!
        VStack {
            VStack() {
                HStack {
                    Text(event.eventName)
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .padding(.bottom, 6)
                HStack {
                    Text("Arranger:")
                        .font(.title2)
                    Spacer()
                    Text("\(event.eventArrangerName)")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .fontWeight(.semibold)
                }
                .padding(.bottom, 20)
                HStack {
                    Text("\(event.eventDate.format("d MMM YYYY"))")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(event.eventStartTime.format("HH:mm")) - \(event.eventEndTime.format("HH:mm"))")
                        .font(.title3)
//                        .fontWeight(.semibold)
                }
                .foregroundStyle(AppConstants.accentOrangeColor)
                .padding(.bottom, 16)
                HStack {
                    VStack {
                        NavigationLink(destination: MessageEventInfoView(event: event, messagesViewModel: messagesViewModel)) {
                            Text("Show event info")
                                .padding(6)
                                .padding(.horizontal)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(AppConstants.accentOrangeColor)
                                })
                                .padding(6)
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            .padding(8)
            .padding(.horizontal, 8)
            .background(content: {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(message.fromId == FirebaseManager.shared.currentUser?.id ? AppConstants.accentBlueColor : AppConstants.accentOrangeColor)
            })
            .padding(.horizontal)
            .padding(message.fromId == FirebaseManager.shared.currentUser?.id ? .leading : .trailing, 70)
            Text(message.timestamp.format("HH:mm"))
                .foregroundStyle(.secondary)
                .fontWeight(.light)
                .font(.callout)
                .hSpacing(message.fromId == FirebaseManager.shared.currentUser?.id ? .trailing : .leading)
                .padding(.horizontal)
        }
    }
}

struct MessageEventInfoView: View {
    @Environment(\.dismiss) var dismiss
    @State var event: EventModel
    @State var screenWidth = UIScreen.main.bounds.size.width
    @State var shouldShowFriends = false
    @State var friendName = ""
    @State var sendToIds: [String?] = []
    @ObservedObject var messagesViewModel: MessagesViewModel
    var body: some View {
        VStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 10){
                    if event.eventImageUrl != "" {
                        WebImage(url: URL(string: event.eventImageUrl))
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .clipped()
                            .background(content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppConstants.accentBlueColor, lineWidth: 2)
                            })
                            .padding(.horizontal, 16)
                    } else {
                        Text("There is no photo of the event")
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppConstants.accentBlueColor)
                                    .opacity(0.5)
                                    .frame(width: screenWidth - 32, height: 200)
                            })
                            .frame(width: screenWidth - 100, height: 200)
                            .hSpacing(.center)
                    }
                    //                        Image("InfoImage")
                    //                            .resizable()
                    //                            .scaledToFit()
                    //                            .background(content: {
                    //                                RoundedRectangle(cornerRadius: 20)
                    //                                    .stroke(AppConstants.accentBlueColor, lineWidth: 2)
                    //                            })
                    //                            .frame(width: screenWidth - 32)
                    HStack {
                        //                            Text("24 March")
                        Text(event.eventStartTime.format("dd MMMM"))
                            .hSpacing(.leading)
                            .opacity(0.8)
                        
                        //                            Text("22:00")
                        Text("\(event.eventStartTime.format("hh:mm")) - \(event.eventEndTime.format("hh:mm"))")
                            .hSpacing(.trailing)
                            .foregroundColor(AppConstants.accentOrangeColor)
                    }
                    .padding(.top, 10)
                    .font(.title2)
                    .padding(.horizontal, 20)
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Event arranger:")
                                .font(.title2)
                                .bold()
                                .foregroundColor(AppConstants.accentBlueColor)
                        }
                        HStack {
                            Text(event.eventArrangerName)
                                .opacity(0.8)
                        }
                    }
                    .padding(.horizontal, 20)
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Event discription:")
                                .font(.title2)
                                .bold()
                                .foregroundColor(AppConstants.accentBlueColor)
                        }
                        HStack {
                            Text(event.eventDiscription)
                                .opacity(0.8)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Requirements:")
                                .font(.title2)
                                .bold()
                                .foregroundColor(AppConstants.accentBlueColor)
                        }
                        HStack {
                            Text(event.eventRequirement == "" ? "There are not special requirements to participate in this event" : event.eventRequirement)
                                .opacity(0.8)
                        }
                    }
                    .padding(.horizontal, 20)
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Place:")
                                .font(.title2)
                                .bold()
                                .foregroundColor(AppConstants.accentBlueColor)
                        }
                        HStack {
                            Text(event.eventPlace == "" ? "The place is not specified" : event.eventPlace)
                                .opacity(0.8)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)
                
                
            }
            if !FirebaseManager.shared.currentUser!.lovedEvents.contains(event.eventId) {
                Button(action: {
                    messagesViewModel.addLovedEvent(id: event.eventId)
                    dismiss()
                }, label: {
                    Text("Register")
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppConstants.accentOrangeColor)
                                .frame(width: 250, height: 40)
                        })
                        .foregroundColor(.white)
                        .bold()
                })
            } else {
                Button(action: {
                    messagesViewModel.deleteLovedEvent(id: event.eventId)
                    dismiss()
                }, label: {
                    Text("Wont go")
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppConstants.accentBlueColor)
                                .frame(width: 250, height: 40)
                        })
                        .foregroundColor(.white)
                        .bold()
                })
            }
        }
        
        .onAppear() {
            messagesViewModel.getFriends(friendsId: FirebaseManager.shared.currentUser!.friendsId)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                })
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    shouldShowFriends.toggle()
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(AppConstants.accentOrangeColor)
                })
            }
        }
        .sheet(isPresented: $shouldShowFriends) {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(maxWidth: 100, maxHeight: 3)
                    .foregroundStyle(.primary)
                    .opacity(0.3)
            }
            .padding(.top)
            TextField("Friend Name", text: $friendName, axis: .vertical)
                .lineLimit(1)
                .font(.title2)
                .padding(.vertical, 6)
                .padding(.horizontal)
                .background(content: {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppConstants.accentOrangeColor)
                })
                .padding(.horizontal)
                .padding(.vertical, 8)
            ScrollView {
                ForEach(messagesViewModel.friends) { friend in
                    if (friend.nickname.lowercased().contains(friendName.lowercased()) || friend.phoneNumber.contains(friendName) || friendName == "") {
                        HStack (spacing: 15) {
                            if friend.photoUrl != "" {
                                WebImage(url: URL(string: friend.photoUrl))
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
                                Text(friend.nickname)
                                    .bold()
                                Text(friend.phoneNumber)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                if (sendToIds.contains(friend.id)) {
                                    sendToIds.remove(at: sendToIds.firstIndex(of: friend.id)!)
                                } else {
                                    sendToIds.append(friend.id)
                                }
                            }, label: {
                                if sendToIds.contains(friend.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(maxWidth: 30, maxHeight: 30)
                                        .foregroundStyle(AppConstants.accentBlueColor)
                                } else {
                                    Circle()
                                        .stroke(AppConstants.accentBlueColor)
                                        .frame(width: 30, height: 30)
                                }
                            })
                        }
                        .padding(.horizontal)
                    }
                }
            }
            HStack {
                Button(action: {
                    shouldShowFriends.toggle()
                    messagesViewModel.sendInvite(to: sendToIds, inviteEvent: event)
                }, label: {
                    Text("Send Invite")
                        .foregroundStyle(.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(AppConstants.accentOrangeColor)
                        })
                })
            }
        }
    }
    
}
