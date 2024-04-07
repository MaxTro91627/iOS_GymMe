//
//  FriendsView.swift
//  GymMe
//
//  Created by Максим Троицкий on 03.04.2024.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct FriendsView: View {
    @State var searchText: String = ""
    @State var user: PersonModel?
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var statisticViewModel: StatisticViewModel
    @Environment(\.dismiss) var dismiss
    @State var showAddFriendView = false
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search your friend", text: $searchText)
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
                    ForEach(profileViewModel.friends) { friend in
                        HStack {
                            NavigationLink (destination: FriendInfoView(friend: friend, profileViewModel: profileViewModel, statisticViewModel: statisticViewModel), label: {
                                if (searchText != "") {
                                    if (friend.nickname.lowercased().contains(searchText.lowercased()) || friend.phoneNumber.contains(searchText)) {
                                        FriendCell(friend: friend, showArrow: true)
                                    }
                                } else {
                                    FriendCell(friend: friend, showArrow: true)
                                }
                            })
                            .foregroundStyle(.primary)
                        }
                        .padding(.horizontal)
                        .foregroundStyle(.primary)
                        
                    }
                    
                    
                }
                .onAppear() {
                    profileViewModel.getFriends(friendsId: user?.friendsId ?? [])
                    print(profileViewModel.friends.count)
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showAddFriendView) {
            AddFriendView(profileViewModel: profileViewModel, statisticViewModel: statisticViewModel)
        }
        .navigationBarBackButtonHidden()
        .toolbar() {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                })
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showAddFriendView.toggle()
                }, label: {
                    Image(systemName: "plus.app")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                })
            }
        }
    }
}

struct FriendCell: View {
    @State var friend: PersonModel
    @State var showArrow: Bool
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 20) {
                if friend.photoUrl != "" {
                    WebImage(url: URL(string: friend.photoUrl))
                        .resizable()
                        .frame(width: 60, height: 60)
                        .scaledToFit()
                        .cornerRadius(90)
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .foregroundStyle(AppConstants.accentBlueColor)
                        .padding(12)
                        .background(content: {
                            Circle()
                                .stroke(AppConstants.accentOrangeColor)
                        })
                        .frame(width: 60, height: 60)
                }
                VStack(alignment: .leading) {
                    Text(friend.nickname)
                    Text(friend.phoneNumber)
                        .opacity(0.6)
                }
                Spacer()
                if showArrow {
                    Image(systemName: "arrow.right")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppConstants.accentBlueColor, lineWidth: 2)
        })
    }
}

struct AddFriendView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var statisticViewModel: StatisticViewModel
    @State var text: String = ""
    var body: some View {
        VStack {
            TextField("Enter phone Number", text: $text)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(content: {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppConstants.accentOrangeColor, lineWidth: 3)
                })
                .padding(.horizontal)
                .padding(.vertical, 8)
                .onChange(of: text) {
                    profileViewModel.findFriend(text: text)
                }
            ScrollView {
                if text == "" {
                    ForEach(profileViewModel.friends) { friend in
                        AddFriendCell(friend: friend)
                    }
                }
                ForEach(profileViewModel.foundFriends) { friend in
                    if FirebaseManager.shared.currentUser?.id != friend.id {
                        AddFriendCell(friend: friend)
                    }
                }
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
    }
    
    @ViewBuilder
    func AddFriendCell(friend: PersonModel) -> some View {
        HStack (spacing: 20) {
            NavigationLink (destination: FriendInfoView(friend: friend, profileViewModel: profileViewModel, statisticViewModel: statisticViewModel), label: {
                FriendCell(friend: friend, showArrow: false)
            })
            .foregroundStyle(.primary)
            
            if FirebaseManager.shared.currentUser?.friendsId.firstIndex(of: friend.id) == nil {
                Image(systemName: "checkmark.circle")
                    .foregroundStyle(AppConstants.accentOrangeColor)
                    .font(.title2)
                    .onTapGesture {
                        profileViewModel.addFriend(friendId: friend.id)
                    }
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
