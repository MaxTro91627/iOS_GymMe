//
//  ProfileView.swift
//  GymMe
//
//  Created by Максим Троицкий on 13.03.2024.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore

struct ProfileView: View {
    @AppStorage("log_status") var log_status: Bool = false
    @State private var profileController: ProfileController = ProfileController()
    @ObservedObject private var profileViewModel: ProfileViewModel = .init()
    @State var shouldShowLogOutOptions = false
    @ObservedObject var statisticViewModel: StatisticViewModel = .init(trainings: FirebaseManager.shared.currentUser?.trainings ?? [])
    var body: some View {
        VStack {
            ToolBarView()
            VStack {
                ScrollView {
                    ProfileInfoView(user: FirebaseManager.shared.currentUser, profileViewModel: profileViewModel)
                    NavigationLink(destination: StatisticView(statisticViewModel: statisticViewModel, lovedEvents: profileViewModel.lovedEvents)) {
                        StatisticRectangle(person: FirebaseManager.shared.currentUser, statisticViewModel: statisticViewModel, profileViewModel: profileViewModel)
                    }
                    .foregroundStyle(.primary)
                    //                ImpressionsRectangle()
                    NavigationLink(destination: ArrangedEventsView()) {
                        ArrangedEventsrectangle()
                    }
                    .foregroundStyle(.primary)
                    SubscribtionsRectangle()
                }
            }
        }
        .vSpacing(.top)
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Signing out"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    try? FirebaseManager.shared.auth.signOut()
                    log_status.toggle()
                }),
                    .cancel()
            ])
        }
    }
    
    @ViewBuilder
    func ToolBarView() -> some View {
        
        HStack {
            Spacer()
            Text("Profile")
                .font(.title2)
                .opacity(0.8)
            Spacer()
            Button (action: {
                shouldShowLogOutOptions.toggle()
//                try? FirebaseManager.shared.auth.signOut()
//                log_status.toggle()
            }, label: {
                Image(systemName: "door.right.hand.open")
                    .font(.title2)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(AppConstants.accentOrangeColor)
                
            })
        }
        .padding(.horizontal)
        
    }

    
    @ViewBuilder
    func ImpressionsRectangle() -> some View {
        HStack {
            Text("Impressions")
            Spacer()
            Image(systemName: "arrow.right")
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentBlueColor, lineWidth: 1)
        })
        .padding(.horizontal)
        .padding(.bottom, 3)
    }
    
    @ViewBuilder
    func ArrangedEventsrectangle() -> some View {
        HStack {
            Text("Arranged Events")
            Spacer()
            Image(systemName: "arrow.right")
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentBlueColor, lineWidth: 1)
        })
        .padding(.horizontal)
        .padding(.bottom, 3)
    }
    
    @ViewBuilder
    func SubscribtionsRectangle() -> some View {
        HStack {
            Text("Subscriptions")
            Spacer()
            Image(systemName: "arrow.right")
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentBlueColor, lineWidth: 1)
        })
        .padding(.horizontal)
        .padding(.bottom, 3)
    }

}

#Preview {
    ProfileView()
}

struct StatisticRectangle: View {
    @State var person: PersonModel?
    @ObservedObject var statisticViewModel: StatisticViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    var body: some View {
        VStack {
            HStack {
                Text("Statistics")
                Spacer()
                Image(systemName: "arrow.right")
            }
            .padding(.horizontal)
            .padding(.top, 10)
            StatiscticGrid(for: person)
        }
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentOrangeColor, lineWidth: 1)
        })
        .padding(.horizontal)
        .padding(.bottom, 3)
    }
    
    @ViewBuilder
    func StatiscticGrid(for person: PersonModel?) -> some View {
        let columns = [GridItem(.adaptive(minimum: 15))]
        LazyVGrid (columns: columns, spacing: 4) {
            ForEach(0..<70) { idx in
                let statList = statisticViewModel.countTenWeeks()
                let wasEvent = statisticViewModel.wasEvent(off: idx, events: profileViewModel.lovedEvents)
                if wasEvent {
                    Rectangle()
                        .fill(AppConstants.accentOrangeColor)
                        .frame(width: 15, height: 15)
                        .border(AppConstants.accentOrangeColor)
                } else {
                    Rectangle()
                        .fill(AppConstants.accentBlueColor)
                        .opacity(Double(statList[idx]))
                        .frame(width: 15, height: 15)
                        .border(AppConstants.lightAccentBlueColor)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .frame(maxWidth: 353)
        .onAppear() {
            if FirebaseManager.shared.currentUser != nil {
                profileViewModel.getLovedEvents(eventsId: FirebaseManager.shared.currentUser!.lovedEvents)
            }
        }
    }
}


struct ProfileInfoView: View {
    // MUST BE REMOVED
    //        let person = profileController.person
    @State var user: PersonModel?
    @ObservedObject var profileViewModel: ProfileViewModel
//    @State var user: PersonModel?
//    let imageUrl = FirebaseManager.shared.currentUser?.photoUrl
    var body: some View {
        ZStack {
            VStack (alignment: .center) {
                VStack {
                    let imageUrl = user?.photoUrl
                    if user?.photoUrl == "" {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                            .padding(20)
                            .background(content: {
                                Circle()
                                    .stroke(AppConstants.accentBlueColor, lineWidth: 3)
                                
                            })
                            .frame(width: 100, height: 100)
                    } else {
                        WebImage(url: URL(string: imageUrl ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(50)
                        
                    }
                    Text(user?.nickname ?? "")
                    Text(user?.phoneNumber ?? "")
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 8) {
                    NavigationLink(destination: AttendedEventsView(profileViewModel: profileViewModel, user: user), label: {
                        attendedEventsView(for: user)
                    })
                    NavigationLink(destination: FriendsView(user: user, profileViewModel: profileViewModel), label: {
                        friendsCountView(for: user)
                    })
                    trainingsCountView(for: user)
                }
                .foregroundStyle(.secondary)
            }
            .padding(.all, 8)
            
        }
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentBlueColor, lineWidth: 1)
        })
        .padding(.bottom, 3)
        .padding(.top, 2)
    }
    
    @ViewBuilder
    func friendsCountView(for user: PersonModel?) -> some View {
        let countSportsmen: Int = user?.friendsId.count ?? 0
        VStack (alignment: .center) {
            Text("Sportsmen found")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 1)
            Text("\(countSportsmen)")
                .font(.largeTitle)
                .foregroundStyle(AppConstants.accentOrangeColor)
        }
        .padding(.vertical, 8)
        .frame(width: 110)
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentOrangeColor, lineWidth: 1)
        })
        
    }
    
    @ViewBuilder
    func trainingsCountView(for user: PersonModel?) -> some View {
        // MUST BE REMOVED
//        let person = profileController.getPerson()
        let countTrainings: Int = user?.trainings.count ?? 0
        VStack (alignment: .center) {
            Text("Conducted trainings")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 1)
//            Text("\(countTrainings)")
            Text("\(countTrainings)")
                .font(.largeTitle)
                .foregroundStyle(AppConstants.accentOrangeColor)
        }
        .padding(.vertical, 8)
        .frame(width: 110)
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentOrangeColor, lineWidth: 1)
        })
        
    }
    
    @ViewBuilder
    func attendedEventsView(for user: PersonModel?) -> some View {
        // MUST BE REMOVED
        let countEvents: Int = user?.lovedEvents.count ?? 0
        VStack (alignment: .center) {
            Text("Attended Events")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.bottom, 1)
            Text("\(countEvents)")
                .font(.largeTitle)
                .foregroundStyle(AppConstants.accentOrangeColor)
        }
        .padding(.vertical, 8)
        .frame(width: 110)
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentOrangeColor, lineWidth: 1)
        })
        
    }
}
