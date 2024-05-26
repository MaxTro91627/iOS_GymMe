//
//  EventInfoView.swift
//  GymMe
//
//  Created by Максим Троицкий on 14.03.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct EventInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State var event: EventModel
    @State var screenWidth = UIScreen.main.bounds.size.width
    @ObservedObject var homeViewController: HomeViewController
    @ObservedObject var eventController: EventController
    @State var shouldShowFriends: Bool = false
    @State var friendName = ""
    @State var sendToIds: [String?] = []
//    init(event: EventModel) {
//        self.event = event
//        
//    }
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack (alignment: .leading, spacing: 10){
                        if event.eventImageUrl != "" {
                            WebImage(url: URL(string: event.eventImageUrl))
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(20)
//                                .frame(width: screenWidth - 32)
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
                            Text(event.eventStartTime.format("d MMMM"))
                                .hSpacing(.leading)
                                .opacity(0.8)
                            
//                            Text("22:00")
                            Text("\(event.eventStartTime.format("HH:mm")) - \(event.eventEndTime.format("HH:mm"))")
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
                    Spacer()
                }
                
            }
            .navigationTitle(event.eventName)
            .navigationBarTitleDisplayMode(.inline)
            .tint(AppConstants.accentOrangeColor)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    if let _ = eventController.lovedEvents.firstIndex(where: {event.id == $0.id} ) {
                        Button(action: {
                            homeViewController.deleteLovedEvent(id: event.id)
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
                    } else {
                        Button(action: {
                            // MARK: - UPD. Added image cash
                            homeViewController.addLovedEvent(id: event.id)
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
                        .vSpacing(.bottom)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .foregroundColor(AppConstants.accentOrangeColor)
                        }
                    }
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
                    self.homeViewController.sendInvite(to: sendToIds, inviteEvent: event)
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
        .navigationBarBackButtonHidden()
        
    }
    
    //        .navigationBarItems(trailing: {
    //
    //            Button(action: {
    //
    //            }, label: {
    //
    //            })
    //        })
}

//
//#Preview {
//    EventInfoView(event: EventModel(eventName: "First Event Name", eventImageUrl: "", eventDiscription: "First Event Discription First Event Discription First Event Discription First Event Discription First Event Discription First Event Discription ", eventStartTime: .now, eventEndTime: .now, eventRequirement: "Frist Event Requirment List", eventDate: .now, eventArrangerName: ""), homeViewController: .init(), eventController: .init())
//}
