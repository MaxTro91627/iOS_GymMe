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
    var event: EventModel
    @State var screenWidth = UIScreen.main.bounds.size.width
    @ObservedObject var homeViewController: HomeViewController
    @ObservedObject var eventController: EventController
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
                                Text("Место проведения:")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(AppConstants.accentBlueColor)
                            }
                            HStack {
                                Text("Some Place")
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
                        
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(AppConstants.accentOrangeColor)
                    })
                }
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


#Preview {
    EventInfoView(event: EventModel(eventName: "First Event Name", eventImageUrl: "", eventDiscription: "First Event Discription First Event Discription First Event Discription First Event Discription First Event Discription First Event Discription ", eventStartTime: .now, eventEndTime: .now, eventRequirement: "Frist Event Requirment List", eventDate: .now, eventArrangerName: ""), homeViewController: .init(), eventController: .init())
}
