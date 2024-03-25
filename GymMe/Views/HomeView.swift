//
//  HomeView.swift
//  GymMe
//
//  Created by Максим Троицкий on 29.02.2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ListOfImpressions()
            .padding()
    }
}


struct ListOfImpressions: View {
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    // Animation namespace
    @Namespace private var animation
    @State var eventController: EventController = EventController()
    var body: some View {
        NavigationStack {
            VStack {
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
                if (eventController.getListOfEvents().count == 0) {
                    HStack {
                        Text("There are no events yet")
                            .foregroundStyle(AppConstants.accentBlueColor)
                            .bold()
                            .font(.title3)
                            
                    }
                }
                SelectedContentView(selectedIndex: 1)
                //                Text("Some Text")
                Spacer()
                
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button (action: {
                        print("save")
                    }, label: {
                        Image(systemName: "gear")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 24)
                            .foregroundColor(AppConstants.accentBlueColor)
                        
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button (action: {
                        print("save")
                    }, label: {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 24)
                            .foregroundColor(AppConstants.accentBlueColor)
                    })
                }
            }
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                // Фотографии
                ForEach(1..<12) { i in
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: 60, height: 60)
                        .cornerRadius(100)
                        .padding(.horizontal, 4)
                }
            }
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
                CreateEventView()
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
        
    }
    
    // MARK: EventListView
    @ViewBuilder
    func EventListView() -> some View {
        VStack {
           
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(eventController.getListOfEvents()) { event in
                    NavigationLink {
                        EventInfoView(event: event)
                    } label: {
                        EventCell(of: event)
                            .frame(height: 82)
                            .padding(.horizontal, 13)
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
        return HStack {
            Image("PreviewImage")
                .resizable()
                
                .foregroundColor(AppConstants.accentOrangeColor)
                .frame(maxWidth: 63, maxHeight: 57)
                .padding(.trailing, 2)
            VStack (alignment: .leading){
                Text(event.eventName)
                    .font(.body)
                Text("Some arranger")
                    .font(.callout)
                Text("Some place")
                    .font(.callout)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("22:00 -")
                Text("23:00")
            }
            .foregroundColor(AppConstants.accentBlueColor)
        }
    }
    
    
    @ViewBuilder
    func SelectedContentView(selectedIndex: Int) -> some View {
        ZStack {
            switch selectedIndex {
            case 0:
                MapView()
                // MapView
            case 2:
                LovedEventsView()
//              // LovedEvents
            default:
//                EventListView
                EventListView()
                
            }
        }
    }
    
    
    // MARK: ----------------------------
    @ViewBuilder
    func CategoryIconView() -> some View {
        VStack {
            HStack(spacing: 28) {
                Image(systemName: "location")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 18, height: 18)
                    .foregroundColor(AppConstants.darkBlue)
                
                Image(systemName: "list.bullet")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 16, height: 16)
                    .foregroundColor(AppConstants.accentOrangeColor)
                
                Image(systemName: "flame.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 16, height: 16)
                    .foregroundColor(AppConstants.darkBlue)
            }
        }
        .onTapGesture {
            
        }
        .background {
            
        }
    }
}
#Preview {
    HomeView()
}
