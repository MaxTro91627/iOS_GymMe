//
//  ArrangedEventsView.swift
//  GymMe
//
//  Created by Максим Троицкий on 09.04.2024.
//

import SwiftUI
import Firebase

class ArrangedEventsViewModel: ObservableObject {
    @Published var events: [EventModel] = []
    
    private var firestoreListener: ListenerRegistration?
    
    init() {
        fetchEvents()
    }
    
    func fetchEvents() {
        firestoreListener?.remove()
        self.events.removeAll()
        
        firestoreListener = FirebaseManager.shared.firestore.collection("events")
            .whereField("eventArrangerId", isEqualTo: FirebaseManager.shared.currentUser?.id)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    //                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.events.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.events.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: EventModel?.self) {
                            self.events.insert(rm, at: 0)
                        }
                    } catch {
                        print(error)
                    }
                })
            }
    }
}

struct ArrangedEventsView: View {
    @ObservedObject var arrangedEventsViewModel: ArrangedEventsViewModel = .init()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            if arrangedEventsViewModel.events.isEmpty {
                Text("Here will be placed arranged events")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .foregroundStyle(AppConstants.accentBlueColor)
                    .bold()
                    .padding(.horizontal, 40)
                    .opacity(0.4)
                    .vSpacing(.center)
            } else {
                ScrollView {
                    ForEach(arrangedEventsViewModel.events) { event in
                        ProfileEventInfoView(event: event)
                    }
                }
                .padding(.top)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Arranged Events")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
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

#Preview {
    ArrangedEventsView()
}
