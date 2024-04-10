//
//  CreateImpressionView.swift
//  GymMe
//
//  Created by Максим Троицкий on 09.04.2024.
//

import SwiftUI

struct CreateImpressionView: View {
    @State var screenWidth = UIScreen.main.bounds.size.width
    @State var screenHeight = UIScreen.main.bounds.size.height
    @ObservedObject var homeViewController: HomeViewController
    @Environment(\.dismiss) var dismiss
    @State var shouldShowImagePicher = false
    var body: some View {
        VStack {
            if homeViewController.impressionImage == nil {
                Button(action: {
                    shouldShowImagePicher.toggle()
                }, label: {
                    Text("Choose photo")
                        .frame(width: 200, height: 200)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppConstants.accentOrangeColor)
                        })
                })
                .foregroundStyle(.primary)
            } else {
                VStack {
                    Image(uiImage: homeViewController.impressionImage!)
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(height: screenHeight - 200)
                        .vSpacing(.top)
//                        Spacer()
                    HStack {
                        Button(action: {
                        }, label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                                .opacity(0)
                                .font(.title2)
                        })
                        .foregroundStyle(.primary)
                        Spacer()
                        Button(action: {
                            homeViewController.addImpression()
                            dismiss()
                        }, label: {
                            Text("Public Impression")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .padding(6)
                                .padding(.horizontal, 20)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(AppConstants.accentOrangeColor)
                                })
                        })
                        .foregroundStyle(.primary)
                        Spacer()
                        Button(action: {
                            homeViewController.impressionImage = nil
                        }, label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                                .font(.title2)
                        })
                        .foregroundStyle(.primary)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .fullScreenCover(isPresented: $shouldShowImagePicher) {
            ImagePicker(image: $homeViewController.impressionImage)
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if homeViewController.impressionImage == nil {
                        homeViewController.impressionImage = nil
                        dismiss()
                    } else {
                        homeViewController.impressionImage = nil
                    }
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(AppConstants.accentOrangeColor)
                })
            }
        }
    }
}

//            homeViewController.addImpression()
//            dismiss()

//#Preview {
//    CreateImpressionView()
//}
