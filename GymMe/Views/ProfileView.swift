//
//  ProfileView.swift
//  GymMe
//
//  Created by Максим Троицкий on 13.03.2024.
//

import SwiftUI

struct ProfileView: View {
    @State private var profileController: ProfileController = ProfileController()
    var body: some View {
        VStack {
            ToolBarView()
            ScrollView {
                ProfileInfoView(for: profileController.getPersonId())
                StatisticRectangle(for: profileController.getPersonId())
                ImpressionsRectangle()
                ArrangedEventsrectangle()
                SubscribtionsRectangle()
            }
        }
        .vSpacing(.top)
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
    
    @ViewBuilder
    func ProfileInfoView(for personId: UUID) -> some View {
        // MUST BE REMOVED
        var person = profileController.getPerson()
        ZStack {
            VStack (alignment: .center) {
                VStack {
                    Image("ProfileImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(50)
                    Text(person.nickname)
                    Text(person.phoneNumber)
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 8) {
                    attendedEventsView(for: personId)
                    friendsCountView(for: personId)
                    trainingsCountView(for: personId)
                }
            }
            .padding(.all, 8)
            
        }
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentBlueColor, lineWidth: 1)
        })
        .padding(.bottom, 3)
    }
    
    @ViewBuilder
    func StatiscticGrid(for personId: UUID) -> some View {
        let columns = [GridItem(.adaptive(minimum: 15))]
        LazyVGrid (columns: columns, spacing: 4) {
            ForEach(0..<70) { _ in
                Rectangle()
                    .fill(AppConstants.accentBlueColor)
                    .opacity(Double.random(in: 0...1))
                    .frame(width: 15, height: 15)
                    .border(AppConstants.accentBlueColor)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .frame(maxWidth: 353)
    }
    
    @ViewBuilder
    func StatisticRectangle(for personId: UUID) -> some View {
        VStack {
            HStack {
                Text("Statistics")
                Spacer()
                Image(systemName: "arrow.right")
            }
            .padding(.horizontal)
            .padding(.top, 10)
            StatiscticGrid(for: personId)
        }
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentOrangeColor, lineWidth: 1)
        })
        .padding(.horizontal)
        .padding(.bottom, 3)
    }
    
    @ViewBuilder
    func attendedEventsView(for persoonID: UUID) -> some View {
        // MUST BE REMOVED
        let person = profileController.getPerson()
        let countEvents: Int = person.getAttendedEvents().count
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
    
    @ViewBuilder
    func friendsCountView(for persoonID: UUID) -> some View {
        // MUST BE REMOVED
        let person = profileController.getPerson()
        var countSportsmen: Int = person.getFriendsId().count
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
    func trainingsCountView(for persoonID: UUID) -> some View {
        // MUST BE REMOVED
        let person = profileController.getPerson()
        let countTrainings: Int = person.getTrainings().count
        VStack (alignment: .center) {
            Text("Conducted trainings")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 1)
//            Text("\(countTrainings)")
            Text("24")
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

#Preview {
    ProfileView()
}

struct ToolBarView: View {
    var body: some View {
        HStack {
            Button(action: {
                
            }, label: {
                Image(systemName: "gear")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .foregroundColor(AppConstants.accentOrangeColor)
            })
            Spacer()
            Text("Profile")
                .font(.title2)
                .opacity(0.8)
            Spacer()
            Button(action: {
            }, label: {
                Image(systemName: "qrcode")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .foregroundColor(AppConstants.accentOrangeColor)
            })
        }
        .padding(.horizontal)
    }
}
