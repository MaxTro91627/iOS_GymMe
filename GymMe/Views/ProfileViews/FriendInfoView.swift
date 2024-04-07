//
//  FriendInfoView.swift
//  GymMe
//
//  Created by Максим Троицкий on 03.04.2024.
//

import SwiftUI

class FriendsStatisticViewModel: ObservableObject {
    @Published var friend: PersonModel?
    @Published var lovedFriendsEvents: [EventModel] = []
    
    private var maxFriendTime: Float = 0.0
    private var maxFriendDistance: Float = 0.0
    private var maxFriendReps: Float = 0
    
    init(friend: PersonModel?) {
        self.friend = friend
        
        getLovedEvents(eventsId: friend!.lovedEvents)
        countMax()
    }
    
    private func getLovedEvents(eventsId: [String?]) {
        self.lovedFriendsEvents.removeAll()
        FirebaseManager.shared.firestore.collection("events")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.lovedFriendsEvents.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.lovedFriendsEvents.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: EventModel?.self) {
                            if eventsId.contains(rm.id) {
                                self.lovedFriendsEvents.insert(rm, at: 0)
                            }
                        }
                    } catch {
                        print(error)
                    }
                })
            }
    }
    
    func countMax() {
        for training in friend!.trainings {
            var time: Float = 0.0
            var dist: Float = 0.0
            var repet: Float = 0.0
            for exercise in training.exercises {
                if exercise.time != nil {
                    time += exercise.time!
                }
                if exercise.distance != nil {
                    dist += exercise.distance!
                }
                if exercise.repetitions != nil {
                    var rep = exercise.repetitions!
                    if exercise.sets != nil {
                        rep *= exercise.sets!
                    }
                    repet += Float(rep)
                }
            }
            if time > self.maxFriendTime {
                self.maxFriendTime = time
            }
            if dist > self.maxFriendDistance {
                self.maxFriendDistance = dist
            }
            if repet > self.maxFriendReps {
                self.maxFriendReps = repet
            }
        }
    }
    
    func countStat(for training: Training) -> Float {
        var stat = 0.0
        for exercise in training.exercises {
            if exercise.time != nil {
                stat += Double(exercise.time! / maxFriendTime)
            }
            if exercise.distance != nil {
                stat += Double(exercise.distance! / maxFriendDistance)
            }
            if exercise.repetitions != nil {
                var rep = exercise.repetitions!
                if exercise.sets != nil {
                    rep *= exercise.sets!
                }
                stat += Double(Float(rep) / maxFriendReps)
            }
        }
        return Float(stat)
    }
    
    func countTenWeeks() -> [Float] {
        var dayStat: Float = 0.0
        var statList: [Float] = []
        for off in 0..<70 {
            dayStat = 0
            let offDay = Date().daysAgo(days: off)
            if let idx = self.friend!.trainings.firstIndex(where: {$0.trainingDate.startOfDay() == offDay}) {
                let training = self.friend!.trainings[idx]
                dayStat = countStat(for: training)
            }
            statList.append(dayStat)
        }
        print(statList)
        return statList
    }
    
    func wasEvent(off: Int) -> Bool {
        let day = Date().daysAgo(days: off).startOfDay()
        for event in self.lovedFriendsEvents {
            if event.eventDate == day {
                return true
            }
            if event.eventDate.daysBetween(date: .now) > 70 {
                return false
            }
        }
        return false
    }
}

struct FriendInfoView: View {
    @Environment(\.dismiss) var dismiss
    @State var friend: PersonModel
    @ObservedObject var profileViewModel: ProfileViewModel
//    init(friend: PersonModel, profileViewModel: ProfileViewModel) {
//        self.friend = friend
//        self.profileViewModel = profileViewModel
////        self.friendsStatisticViewModel = .init(friend: friend)
//    }
    
    var body: some View {
        NavigationView {
            @ObservedObject var friendsStatisticViewModel = FriendsStatisticViewModel(friend: self.friend)
            VStack {
                ProfileInfoView(user: friend, profileViewModel: profileViewModel)
                FriendsStatisticRectangle(friendsStatisticViewModel: friendsStatisticViewModel)
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


struct FriendsStatisticRectangle: View {
    @State var person: PersonModel?
    @ObservedObject var friendsStatisticViewModel: FriendsStatisticViewModel
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
                let statList = friendsStatisticViewModel.countTenWeeks()
                let wasEvent = friendsStatisticViewModel.wasEvent(off: idx)
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
    }
}

//#Preview {
//    FriendInfoView()
//}
