//
//  FriendInfoView.swift
//  GymMe
//
//  Created by Максим Троицкий on 03.04.2024.
//

import SwiftUI

struct FriendInfoView: View {
    @Environment(\.dismiss) var dismiss
    @State var friend: PersonModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var statisticViewModel: StatisticViewModel
    var body: some View {
        NavigationView {
            VStack {
                ProfileInfoView(user: friend, profileViewModel: profileViewModel, statisticViewModel: statisticViewModel)
                StatisticRectangle(statisticViewModel: statisticViewModel, profileViewModel: profileViewModel)
                Spacer()
            }
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
        }
    }
}


//#Preview {
//    FriendInfoView()
//}
