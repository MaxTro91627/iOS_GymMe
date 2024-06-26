//
//  CreateEventView.swift
//  GymMe
//
//  Created by Максим Троицкий on 24.03.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateEventView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var eventController: EventController
    @ObservedObject var homeViewController: HomeViewController
    @State private var shouldShowImagePicker = false
    @State var shouldShowFriends: Bool = false
    @State var friendName: String = ""
    @State var sendToIds: [String?] = []
    @State var image: UIImage?
    @State var showError = false
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                HStack {
                    Button(action: {
                        shouldShowImagePicker.toggle()
                    }, label: {
                        if let image = self.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                                .clipped()
                                .cornerRadius(10)
                        } else {
                            Text("Add Photo")
                                .multilineTextAlignment(.center)
                                .frame(width: 90, height: 90)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(AppConstants.accentBlueColor)
                                })
                        }
                    })
                    //                    RoundedRectangle(cornerRadius: 10)
                    //                        .fill(Image("InfoImage"))
                    //                        .frame(width: 90, height: 90)
                    
                    //                    Text("Add Photo")
                    //                        .foregroundStyle(.white)
                    //                        .background(content: {
                    //                            RoundedRectangle(cornerRadius: 10)
                    //                                .fill(AppConstants.accentBlueColor)
                    //                                .frame(width: 90, height: 90)
                    //                        })
                    TextField("Enter event's name", text: $eventController.eventName, axis: .vertical)
                        .lineLimit(2)
                        .padding(.horizontal, 6)
                        .font(.title2)
                        .fontWeight(.semibold)
                    //                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .opacity(0.6)
//                        .frame(maxHeight: 110)
                    //                    Text("Second Event Name")
                    //                        .bold()
                    //                        .foregroundStyle(.secondary)
                    if showError && eventController.eventName == ""  {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(AppConstants.accentOrangeColor)
                            
                    }
                }
                .padding(.horizontal, 20)
//                .frame(height: 110)
                ScrollView {
                    // DatePicker
                    DatePicker("Date of the event", selection: $eventController.eventStartTime, in: PartialRangeFrom(.now), displayedComponents: [.date])
                        .padding(.horizontal)
                        .tint(AppConstants.accentBlueColor)
                    //                        .foregroundStyle(AppConstants.accentOrangeColor)
                        .padding(.vertical, 10)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 10) {
                        DatePicker("Starts at:", selection: $eventController.eventStartTime, displayedComponents: [.hourAndMinute])
                        Divider()
                            .frame(maxHeight: 40)
                        DatePicker("Ends at:", selection: $eventController.eventEndTime, in: PartialRangeFrom(eventController.eventStartTime), displayedComponents: [.hourAndMinute])
                    }
                    //                    .foregroundColor(AppConstants.accentOrangeColor)
                    .tint(AppConstants.accentBlueColor)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    
                    // Event Description
                    VStack (alignment: .leading, spacing: 20){
                        Text("Discription:")
                            .font(.title2)
                            .foregroundStyle(AppConstants.accentBlueColor)
                        HStack {
                            TextField("Enter the description of the event", text: $eventController.eventDiscription, axis: .vertical)
                                .lineLimit(10)
                                .foregroundStyle(.secondary)
                            if showError && eventController.eventDiscription == ""  {
                                Image(systemName: "exclamationmark.triangle")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundStyle(AppConstants.accentOrangeColor)
                                    
                            }
                        }
                        Text("Requirements:")
                            .font(.title2)
                            .foregroundStyle(AppConstants.accentBlueColor)
                        TextField("Enter event's requirements", text: $eventController.eventRequirement, axis: .vertical)
                            .lineLimit(2)
                            .foregroundStyle(.secondary)
                        Text("Location:")
                            .font(.title2)
                            .foregroundStyle(AppConstants.accentBlueColor)
                        TextField("Enter the description of the event", text: $eventController.eventPlace, axis: .vertical)
                            .lineLimit(10)
                            .foregroundStyle(.secondary)
                        HStack {
                            Text("Add sportsmen")
                                .font(.title2)
                                .foregroundStyle(AppConstants.accentBlueColor)
                            Spacer()
                            Button(action: {
                                shouldShowFriends.toggle()
                            }, label: {
                                Image(systemName: "plus")
                                    .foregroundStyle(AppConstants.accentOrangeColor)
                            })
                        }
                    }
                    .fontWeight(.bold)
                    .hSpacing(.leading)
                    .padding(.horizontal)
                    Spacer()
                }
                Spacer()
                HStack {
                    Button(action: {
                        if (eventController.eventName != "") {
                            eventController.image = self.image
                            eventController.createEvent()
                            
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                                homeViewController.sendInvite(to: sendToIds, inviteEvent: eventController.createdEvent!)
                            }
                            
                        } else {
                            showError = true
                        }
                    }, label: {
                        Text("Create")
                            .bold()
                            .foregroundStyle(.white)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(AppConstants.accentOrangeColor)
                                    .frame(width: 250, height: 40)
                            })
                    })
                }
                .hSpacing(.center)
                .padding(.bottom)
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
                    ForEach(homeViewController.friends) { friend in
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
                    }, label: {
                        Text("Add friends")
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
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
                    .ignoresSafeArea()
            }
        }
        .navigationTitle("Create Event")
        .navigationBarBackButtonHidden()
        .toolbar() {
//            ToolbarItem(placement: .bottomBar) {
//                
//            }
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    eventController.clearFields()
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                })
                .foregroundColor(.secondary)
            }
        }
        
    }
    
}

#Preview {
    //    CreateEventView(eventController: EventController())
    ContentView()
}
