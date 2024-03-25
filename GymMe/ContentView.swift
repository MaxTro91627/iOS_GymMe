//
//  ContentView.swift
//  GymMe
//
//  Created by Максим Троицкий on 29.02.2024.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @State var selectedViewIndex: Int = 0;
    @Namespace private var animation
    let tabbarImages = ["house", "dumbbell", "message.badge", "person"]
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    switch selectedViewIndex {
                    case 1:
                        TrainingsView()
                    case 2:
                        MessagesView()
                    case 3:
                        ProfileView()
                    default:
                        HomeView()
                    }
                }
                Spacer()
                ZStack {
                    HStack(alignment: .center) {
                        Spacer()
                        ForEach(0..<4) { num in
                            Spacer()
                            VStack {
                                Image(systemName:  tabbarImages[num])
                                    .font(.system(size: 30))
                                    .rotationEffect(.degrees(num == 1 ? -45 : 0))
                                    .foregroundColor(selectedViewIndex == num ? AppConstants.accentOrangeColor : .secondary)
                                //                                    .overlay (
                                //                                        RoundedRectangle(cornerRadius: 40)
                                //                                            .stroke(selectedViewIndex == num ? AppConstants.accentOrangeColor : .black, lineWidth: 2)
                                //                                            .frame(width: 55, height: 55)
                                //
                                //                                    )
                                    .onTapGesture {
                                        //                                    withAnimation() {
                                        selectedViewIndex = num
                                        //                                    }
                                    }
                            }
                            Spacer()
                        }
                        //                        .hSpacing(.center)
                        Spacer()
                    }
                    .background(Color(.systemBackground))
                }
                .frame(maxHeight: 0)
                .padding(.bottom, 10)
                //                .vSpacing(.bottom)
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
