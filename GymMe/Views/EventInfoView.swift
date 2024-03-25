//
//  EventInfoView.swift
//  GymMe
//
//  Created by Максим Троицкий on 14.03.2024.
//

import SwiftUI

struct EventInfoView: View {
    @Environment(\.dismiss) private var dismiss
    var event: EventModel
    @State var screenWidth = UIScreen.main.bounds.size.width
    init(event: EventModel) {
        self.event = event
    }
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack (spacing: 10){
                        Image("InfoImage")
                            .resizable()
                            .scaledToFit()
                            .background(content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppConstants.accentBlueColor, lineWidth: 2)
                            })
                            .frame(width: screenWidth - 32)
                        HStack {
//                            Text("24 March")
                            Text(event.eventStartTime.format("dd MMMM"))
                                .hSpacing(.leading)
                                .opacity(0.8)
                            
//                            Text("22:00")
                            Text(event.eventStartTime.format("hh:mm"))
                                .hSpacing(.trailing)
                                .foregroundColor(AppConstants.accentOrangeColor)
                        }
                        .padding(.top, 10)
                        .font(.title2)
                        .padding(.horizontal, 20)
                        VStack (alignment: .leading) {
                            HStack {
                                Text("Организовывает:")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(AppConstants.accentBlueColor)
                                Spacer()
                            }
                            HStack {
                                Text("Правительство Москвы")
                                    .opacity(0.8)
                            }
                        }
                        .padding(.horizontal, 20)
                        VStack (alignment: .leading) {
                            HStack {
                                Text("Описание:")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(AppConstants.accentBlueColor)
                                Spacer()
                            }
                            HStack {
                                Text(event.eventDiscription)
                                    .opacity(0.8)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack (alignment: .leading) {
                            HStack {
                                Text("Требования:")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(AppConstants.accentBlueColor)
                                Spacer()
                            }
                            HStack {
                                Text(event.eventRequirement)
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
                                Spacer()
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
                Button(action: {
                    
                }, label: {
                    Text("Записаться")
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
            .navigationTitle(event.eventName)
            .navigationBarTitleDisplayMode(.inline)
            .tint(AppConstants.accentOrangeColor)
            .toolbar {
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
    EventInfoView(event:  EventModel(id: UUID(), eventName: "First Event Name", eventDiscription: "First Event Discription First Event Discription First Event Discription First Event Discription First Event Discription First Event Discription ", eventStartTime: .now, eventEndTime: .now, eventRequirement: "Frist Event Requirment List", eventArranger: UUID()))
}
