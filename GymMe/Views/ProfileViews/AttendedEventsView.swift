//
//  AttendedEventsView.swift
//  GymMe
//
//  Created by Максим Троицкий on 02.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct AttendedEventsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var profileViewModel: ProfileViewModel
    var user: PersonModel?
    var body: some View {
        NavigationView {
            VStack {
                if (profileViewModel.lovedEvents.isEmpty) {
                    Text("Here will be placed attended events")
                        .multilineTextAlignment(.center)
                        .opacity(0.4)
                        .font(.title)
                        .foregroundStyle(AppConstants.accentBlueColor)
                        .bold()
                        .padding(.horizontal, 40)
                        .vSpacing(.center)
                } else {
                    ScrollView {
                        ForEach(profileViewModel.lovedEvents) { event in
                            ProfileEventInfoView(event: event)
                        }
                    }
                }
            }
            .onAppear() {
                profileViewModel.getLovedEvents(eventsId: user?.lovedEvents ?? [])
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                })
            }
        }
        .navigationTitle("Attended Events")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

struct ProfileEventInfoView: View {
    @State var event: EventModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.eventDate.format("d MMMM yyyy"))
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
            NavigationLink(destination: EventInfo(event: event)) {
                EventCell(of: event)
                    .padding(.horizontal)
            }
            .foregroundColor(.primary)
            Divider()
                .padding()
        }
    }
    
    func EventCell(of event: EventModel) -> some View {
        return HStack(spacing: 7) {
            if event.eventImageUrl != "" {
                WebImage(url: URL(string: event.eventImageUrl))
                    .resizable()
                    .foregroundColor(AppConstants.accentOrangeColor)
                    .frame(width: 65, height: 65)
                    .cornerRadius(10)
                    .clipped()
                
            }
            VStack (alignment: .leading){
                Text(event.eventName)
                    .font(.body)
                Text(event.eventArrangerName)
                    .font(.body)
                    .fontWeight(.light)
                Text(event.eventPlace)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("\(event.eventStartTime.format("hh:mm")) -")
                Text(event.eventEndTime.format("hh:mm"))
            }
            .foregroundColor(AppConstants.accentBlueColor)
            .padding(.horizontal)
            Image(systemName: "arrow.right")
                .foregroundColor(AppConstants.accentOrangeColor)
                .font(.title2)
//            .bold()
        }
    }

}

struct EventInfo: View {
    @Environment(\.dismiss) private var dismiss
    var event: EventModel
    @State var screenWidth = UIScreen.main.bounds.size.width
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
                        HStack {
                            Text(event.eventStartTime.format("dd MMMM"))
                                .hSpacing(.leading)
                                .opacity(0.8)
                            
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
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
//    AttendedEventsView()
    ContentView()
}
