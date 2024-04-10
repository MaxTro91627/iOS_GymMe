//
//  ImpressionInfoView.swift
//  GymMe
//
//  Created by Максим Троицкий on 09.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImpressionInfoView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var homeViewController: HomeViewController
    @State var friend: PersonModel
    @State var impressions: [Impression]
    @State var screenWidth = UIScreen.main.bounds.size.width
    @State var screenHeight = UIScreen.main.bounds.size.height
    @State var tag = 0
    var body: some View {
        ZStack {
            VStack {
                WebImage(url: URL(string: impressions[tag].imageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(maxWidth: screenWidth, maxHeight: screenHeight)
                    .vSpacing(.top)
                    .cornerRadius(10)
            }
            .navigationBarBackButtonHidden()
            .ignoresSafeArea(edges: .bottom)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack() {
                            WebImage(url: URL(string: friend.photoUrl))
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(30)
                            Text(friend.nickname)
                                .foregroundStyle(.white)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(6)
                                .padding(.trailing, 10)
                        }
                        .background(content: {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundStyle(.black)
                                .opacity(0.6)
                        })
                    }
                    .background(content: {
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(AppConstants.accentBlueColor, lineWidth: 2)
                    })
                    .padding()
                    Spacer()
                    if (impressions[tag].personId == FirebaseManager.shared.currentUser?.id) {
                        Button(action: {
                            dismiss()
                            homeViewController.deleteImpression(impression: impressions[tag])
                        }, label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                                .font(.title3)
                        })
                    }
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.white)
                            .padding(16)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 100)
                                    .foregroundStyle(.black)
                                    .opacity(0.6)
                            })
                    })
                    .padding(.horizontal)
                    
                }
                .vSpacing(.top)
                HStack {
                    if impressions.count > 1 {
                        ForEach(impressions.indices) { idx in
                            RoundedRectangle(cornerRadius: 10)
                                .frame(maxHeight: 3)
                                .foregroundStyle(idx <= tag ? .white : .secondary)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .onTapGesture {
            if tag + 1 == impressions.count {
                dismiss()
            } else {
                tag += 1
            }
        }
    }
}
//
//#Preview {
//    ImpressionInfoView()
//}
