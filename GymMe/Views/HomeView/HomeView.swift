//
//  HomeView.swift
//  GymMe
//
//  Created by Максим Троицкий on 29.02.2024.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI


struct HomeView: View {
    @ObservedObject var homeViewController: HomeViewController = .init()
    let uid = FirebaseManager.shared.auth.currentUser?.uid
    var body: some View {
        NavigationView {
            VStack {
                ListOfImpressions(homeViewController: homeViewController)
                    .padding()
            }
            .navigationBarBackButtonHidden()
        }
    }
}


struct ListOfImpressions: View {
    @AppStorage("log_status") var log_status: Bool = false
    @ObservedObject var homeViewController: HomeViewController
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    @State private var selectedIndex: Int = 1
    
    @State private var filterButtonTapped: Bool = false
    @State private var filterStartTime: Date = .now.startOfDay()
    @State private var filterEndTime: Date = .now.endOfDay()
    @State private var filterTag = 1
    @State private var filterEventName = ""
    // Animation namespace
    @Namespace private var animation
    @ObservedObject var eventController: EventController = .init()
    var body: some View {
            VStack {
                //                Text(FirebaseManager.shared.currentUser?.nickname ?? "ggg")
                ImpressionsView()
                    .padding(.top, 4)
                    .padding(.bottom, 6)
                Divider()
                    .frame(height: 1)
                    .overlay(AppConstants.accentBlueColor)
                    .foregroundColor(AppConstants.accentBlueColor)
                // MARK: Picked Day Info
                HeaderView()
                    .padding(.top, 6)
                    .padding(.horizontal, 6)
                
                // MARK: Week Slider
                WeekSlider()
                CategoryIconView()
                    .padding(.vertical, 1)
                
                //                MARK: - ---------------------------
                //                MARK: - NEED TO REWRITE
                SelectedContentView(selectedIndex: self.selectedIndex)
                //                Text("Some Text")
                Spacer()
                
            }
            .sheet(isPresented: $filterButtonTapped) {
                FilterView()
                    .padding(.horizontal)
                    .presentationDetents([.medium])
            }
            .onAppear() {
                if FirebaseManager.shared.currentUser != nil {
                    homeViewController.getAllImpressions()
                }
                currentDate = .now.startOfDay()
                
            }
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button (action: {
//                        try? FirebaseManager.shared.auth.signOut()
//                        log_status.toggle()
//                    }, label: {
//                        Image(systemName: "gear")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(height: 24)
//                            .foregroundColor(AppConstants.accentBlueColor)
//                        
//                    })
//                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button (action: {
//                        print("save")
//                    }, label: {
//                        Image(systemName: "bell.fill")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(height: 24)
//                            .foregroundColor(AppConstants.accentBlueColor)
//                    })
//                }
//            }
        
    }
    
    @ViewBuilder
    func FilterView() -> some View {
        
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.secondary)
                    .frame(width: 100, height: 3)
                Spacer()
            }
            .padding(.top)
            .padding(.bottom, 10)
            HStack {
                Text("Search")
                    .font(.title)
                    .foregroundStyle(AppConstants.accentOrangeColor)
                    .bold()
                Spacer()
                Button(action: {
                    homeViewController.cleanFilters()
                    self.filterButtonTapped.toggle()
                }, label: {
                    Image(systemName: "trash")
                        .foregroundStyle(AppConstants.accentBlueColor)
                        .font(.title3)
                })
            }
            HStack {
                Text("Between")
                DatePicker("", selection: $filterStartTime, displayedComponents: [.hourAndMinute])
                Text("  and")
                DatePicker("", selection: $filterEndTime, in: PartialRangeFrom(filterStartTime) , displayedComponents: [.hourAndMinute])
                    
            }
            .tint(AppConstants.accentOrangeColor)
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(content: {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppConstants.accentBlueColor)
            })
            HStack {
                Text("Among")
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut) {
                        filterTag = 1
                    }
                }, label: {
                    if filterTag == 2 {
                        Text("All")
                            .padding(6)
                            .padding(.horizontal)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppConstants.accentOrangeColor)
                            })
                            .foregroundStyle(.primary)
                    } else {
                        Text("All")
                            .padding(6)
                            .padding(.horizontal)
                            .background(AppConstants.accentOrangeColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                })
                Button(action: {
                    withAnimation(.easeInOut) {
                        filterTag = 2
                    }
                }, label: {
                    if filterTag == 1 {
                        Text("Friends")
                            .padding(6)
                            .padding(.horizontal)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppConstants.accentOrangeColor)
                            })
                            .foregroundStyle(.primary)
                    } else {
                        Text("Friends")
                            .padding(6)
                            .padding(.horizontal)
                            .background(AppConstants.accentOrangeColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                })
            }
            .foregroundStyle(.primary)
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(content: {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppConstants.accentBlueColor)
            })
            HStack {
                Text("or")
                    .font(.title)
                    .foregroundStyle(AppConstants.accentBlueColor)
                    .bold()
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("By name")
                    TextField("Enter the name of event", text: $filterEventName, axis: .vertical)
                        .lineLimit(2)
                        .padding(6)
                        .padding(.horizontal)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppConstants.accentOrangeColor)
                        })
                        .foregroundStyle(.primary)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(content: {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppConstants.accentBlueColor)
            })
            Spacer()
            Button(action: {
                self.homeViewController.filterStartTime = filterStartTime
                self.homeViewController.filterEndTime = filterEndTime
                self.homeViewController.filterTag = filterTag
                self.homeViewController.filterEventName = filterEventName
                filterButtonTapped.toggle()
            }, label: {
                Text("Apply filters")
                    .padding(6)
                    .padding(.horizontal, 20)
                
            })
            .foregroundStyle(.white)
            .background(content: {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(AppConstants.accentBlueColor)
            })
            .padding(.bottom)
            .hSpacing(.center)
        }
        .onAppear() {
            filterStartTime = self.homeViewController.filterStartTime
            filterEndTime = self.homeViewController.filterEndTime
            filterTag = self.homeViewController.filterTag
            filterEventName = self.homeViewController.filterEventName
        }
    }
    
    // MARK: WeekView
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack {
                    VStack() {
                        Text(day.date.format("EEEEEE"))
                            .font(.callout)
                            .fontWeight(.medium)
                            .textScale(.secondary)
                        Text(day.date.format("d"))
                        //                        .fontWeight(.bold)
                        //                            .foregroundStyle(Color.black)
                    }
                    .frame(width: 41, height: 58)
                    .background(content: {
                        if isSameDate(day.date, currentDate) {
                            RoundedRectangle(cornerRadius: 19)
                                .fill(Color(currentDate.isToday ? AppConstants.accentOrangeColor : AppConstants.accentBlueColor))
                                .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                        }
                    })
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 19)
                        .stroke(day.date.isToday ? AppConstants.accentOrangeColor : AppConstants.accentBlueColor, lineWidth: 3)
                )
                .padding(.top, 2)
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
                .onChange(of: currentDate) {
                    self.selectedIndex = 1
                    eventController.fetchLovedEvents(in: FirebaseManager.shared.currentUser?.lovedEvents ?? [], eventDate: currentDate)
                    eventController.fetchEvents(eventDate: currentDate.startOfDay())
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        if value.rounded() == 16 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                        
                    }
            }
        }
    }
    
    func paginateWeek() {
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPrevioustWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
            print(weekSlider.count)
        }
    }
    
    @ViewBuilder
    func ImpressionsView() -> some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    NavigationLink(destination: CreateImpressionView(homeViewController: homeViewController)) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .scaledToFit()
                            .foregroundStyle(AppConstants.accentOrangeColor)
                            .opacity(0.4)
                    }
//                    Button(action: {
//                        homeViewController.addImpression()
//                    }, label: {
//                        Image(systemName: "plus.circle")
//                            .resizable()
//                            .frame(width: 60, height: 60)
//                            .scaledToFit()
//                            .foregroundStyle(AppConstants.accentOrangeColor)
//                            .opacity(0.4)
//                    })
                    if FirebaseManager.shared.currentUser != nil {
                        if homeViewController.myImpressions.count != 0 {
                            NavigationLink(destination: ImpressionInfoView(homeViewController: homeViewController, friend: FirebaseManager.shared.currentUser!, impressions: homeViewController.myImpressions)) {
                                friendImpressionCell(friend: FirebaseManager.shared.currentUser!)
                            }
                        }
                    }
                    ForEach(homeViewController.friends) { friend in
                        let friendImpressions = homeViewController.allImpressions.filter({$0.personId! == friend.id})
                        HStack {
                            if friendImpressions.count != 0 {
                                NavigationLink(destination: ImpressionInfoView(homeViewController: homeViewController, friend: friend, impressions: friendImpressions)) {
                                    friendImpressionCell(friend: friend)
                                }
                            }
                        }
                    }
                }
            }
            //            HStack {
            //                // Фотографии
            //                ForEach(1..<12) { i in
            //                    Rectangle()
            //                        .foregroundColor(.gray)
            //                        .frame(width: 60, height: 60)
            //                        .cornerRadius(100)
            //                        .padding(.horizontal, 4)
            //                }
            //            }
        }
    }
    
    @ViewBuilder
    func friendImpressionCell(friend: PersonModel) -> some View {
        if friend.photoUrl != "" {
            WebImage(url: URL(string: friend.photoUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(50)
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFill()
                .padding(20)
                .background(content: {
                    Circle()
                        .stroke(AppConstants.accentBlueColor, lineWidth: 3)
                    
                })
                .frame(width: 60, height: 60)
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(currentDate.format("EEEE"))
                    .font(.title2)
                Text(currentDate.format("d MMMM"))
                    .font(.title3)
            }
            .hSpacing(.leading )
            Button (action: {
                filterButtonTapped.toggle()
                print("Filter button tapped")
            }, label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 20)
                    .foregroundColor(AppConstants.grayColor)
            })
            .padding(.horizontal)
            NavigationLink {
                CreateEventView(eventController: eventController, homeViewController: homeViewController)
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .foregroundColor(AppConstants.accentOrangeColor)
            }
            .foregroundColor(.primary)
        }
    }
    
    @ViewBuilder
    func WeekSlider() -> some View {
        TabView(selection: $currentWeekIndex) {
            ForEach(weekSlider.indices, id: \.self) {index in
                let week = weekSlider[index]
                WeekView(week)
                    .padding(.horizontal, 15)
                    .vSpacing(.top)
                    .tag(index)
            }
        }
        .padding(.horizontal, -15)
        .vSpacing(.top)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
        .onAppear(perform: {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPrevioustWeek())
                }
                
                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
            }
        })
        .frame(maxHeight: 70)
    }
    
    // MARK: MapView
    @ViewBuilder
    func MapView() -> some View {
        
    }
    
    // MARK: LovedEventsView
    @ViewBuilder
    func LovedEventsView() -> some View {
        VStack {
            let events = homeViewController.filterEvents(eventController.getLovedEvents())
            if (events.count == 0) {
                HStack {
                    Text("There are no events yet")
                        .foregroundStyle(AppConstants.accentBlueColor)
                        .bold()
                        .font(.title3)
                }
            }
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(events) { event in
                    NavigationLink {
                        EventInfoView(event: event, homeViewController: self.homeViewController, eventController: self.eventController)
                    } label: {
                            EventCell(of: event)
                                .frame(height: 82)
                                .padding(.horizontal, 8)
                                .padding(.trailing, 8)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(AppConstants.accentBlueColor, lineWidth: 2)
                                })
                                .padding(.vertical, 4)
                                .padding(.horizontal, 2)

                    }
                    .foregroundColor(.primary)
                }
                
            }
            
        }
    }
    
    // MARK: EventListView
    @ViewBuilder
    func EventListView() -> some View {
        VStack {
            let events = homeViewController.filterEvents(eventController.getListOfEvents())
            
            if (events.count == 0) {
                HStack {
                    Text("There are no events yet")
                        .foregroundStyle(AppConstants.accentBlueColor)
                        .bold()
                        .font(.title3)
                    
                }
            }
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(events) { event in
                    NavigationLink {
                        EventInfoView(event: event, homeViewController: self.homeViewController, eventController: self.eventController)
                    } label: {
                        EventCell(of: event)
                            .frame(height: 82)
                            .padding(.horizontal, 8)
                            .padding(.trailing, 8)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(AppConstants.accentBlueColor, lineWidth: 2)
                            })
                            .padding(.vertical, 4)
                            .padding(.horizontal, 2)
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
    
    // MARK: EventCell
    func EventCell(of event: EventModel) -> some View {
        return HStack(spacing: 7) {
            if event.eventImageUrl != "" {
                WebImage(url: URL(string: event.eventImageUrl))
                    .resizable()
                    .foregroundColor(AppConstants.accentOrangeColor)
                    .frame(width: 65, height: 65)
                //                    .padding(.trailing, 2)
                    .cornerRadius(10)
                    .clipped()
                
            }
            VStack (alignment: .leading){
                Text(event.eventName)
                    .font(.body)
                Text(event.eventArrangerName)
                    .font(.body)
                    .fontWeight(.light)
                if (event.eventPlace != "") {
                    Text(event.eventPlace)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("\(event.eventStartTime.format("HH:mm")) -")
                Text(event.eventEndTime.format("HH:mm"))
            }
            .foregroundColor(AppConstants.accentBlueColor)
//            .bold()
        }
    }
    
    
    @ViewBuilder
    func SelectedContentView(selectedIndex: Int) -> some View {
        ZStack {
            switch selectedIndex {
            case 0:
                // MapView
                MapView()
            case 2:
                // LovedEvents
                LovedEventsView()
                    .onAppear() {
                        let lovedEventsId = FirebaseManager.shared.currentUser?.lovedEvents
                        eventController.fetchLovedEvents(in: lovedEventsId ?? [], eventDate: currentDate)
                    }
            default:
                // EventListView
                EventListView()
                
            }
        }
    }
    
    
    // MARK: ----------------------------
    @ViewBuilder
    func CategoryIconView() -> some View {
        let iconList = ["location", "list.bullet", "flame.fill"]
        VStack {
            HStack(spacing: 28) {
                ForEach(iconList.indices, id: \.self) {index in
                    Image(systemName: iconList[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 18, height: 18)
                        .foregroundColor(self.selectedIndex == index ? AppConstants.accentOrangeColor : AppConstants.darkBlue)
                        .onTapGesture {
                            withAnimation(.bouncy) {
                                self.selectedIndex = index
                            }
                        }
                }
                //                Image(systemName: "location")
                //
                //
                //                Image(systemName: "list.bullet")
                //                    .resizable()
                //                    .aspectRatio(contentMode: .fill)
                //                    .frame(width: 16, height: 16)
                //                    .foregroundColor(AppConstants.accentOrangeColor)
                //
                //                Image(systemName: "flame.fill")
                //                    .resizable()
                //                    .aspectRatio(contentMode: .fill)
                //                    .frame(width: 16, height: 16)
                //                    .foregroundColor(AppConstants.darkBlue)
            }
            .onChange(of: self.selectedIndex) {
                let lovedEventsId = FirebaseManager.shared.currentUser?.lovedEvents
                eventController.fetchLovedEvents(in: lovedEventsId ?? [], eventDate: currentDate)
            }
        }
    }
}
#Preview {
    HomeView()
}
