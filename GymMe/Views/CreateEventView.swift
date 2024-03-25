//
//  CreateEventView.swift
//  GymMe
//
//  Created by Максим Троицкий on 24.03.2024.
//

import SwiftUI

struct CreateEventView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                HStack (spacing: 30) {
                    Image("InfoImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipped()
                        .cornerRadius(10)

                    
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Image("InfoImage"))
//                        .frame(width: 90, height: 90)
                    
//                    Text("Add Photo")
//                        .foregroundStyle(.white)
//                        .background(content: {
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(AppConstants.accentBlueColor)
//                                .frame(width: 90, height: 90)
//                        })
                    Text("Second Event Name")
                        .bold()
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 20)
                
                
                .frame(width: .infinity, height: 90)
                HStack {
                    Text("Date of the event")
                    Spacer()
                    Text("24.03.2024")
                        .padding(2)
                        .foregroundStyle(.white)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppConstants.accentBlueColor)
                        })
                    Text("22:00")
                        .padding(2)
                        .foregroundStyle(.white)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppConstants.accentBlueColor)
                        })
                }
                .fontWeight(.semibold)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .padding(.top, 20)
                VStack (alignment: .leading, spacing: 20){
                    Text("Discription:")
                        .font(.title2)
                        .foregroundStyle(AppConstants.accentBlueColor)
                    Text("Second Event Discription")
                        .foregroundStyle(.secondary)
                    Text("Requirements:")
                        .font(.title2)
                        .foregroundStyle(AppConstants.accentBlueColor)
                    Text("Second Event Requirment List")
                        .foregroundStyle(.secondary)
                    Text("Location:")
                        .font(.title2)
                        .foregroundStyle(AppConstants.accentBlueColor)
                    Text("+ add location")
                        .foregroundStyle(.secondary)
                    HStack {
                        Text("Add sportsmen")
                            .font(.title2)
                            .foregroundStyle(AppConstants.accentBlueColor)
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundStyle(AppConstants.accentOrangeColor)
                    }
                }
                .fontWeight(.bold)
                .hSpacing(.leading)
                .padding(.horizontal, 20)
                Spacer()
                HStack (alignment: .center) {
                    Text("Create")
                        .bold()
                        .foregroundStyle(.white)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(AppConstants.accentOrangeColor)
                                .frame(width: 250, height: 30)
                        })
                        .hSpacing(.center)
                }
            }

        }
        .toolbar() {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                })
                .foregroundColor(.secondary)
            }
        }
        .navigationTitle(Text("Create Event").foregroundColor(.secondary))
        .navigationBarBackButtonHidden()
    }
        
}

#Preview {
    CreateEventView()
//    ContentView()
}
