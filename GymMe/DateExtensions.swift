//
//  Date.swift
//  GymMe
//
//  Created by Максим Троицкий on 02.03.2024.
//

import Foundation

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}

// MARK: Custom date format
extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    // MARK: Fetchng week based on choosed Date
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        
        return fetchWeek(nextDate)
    }
    
    func createPrevioustWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        
        return fetchWeek(previousDate)
    }
    
    func daysAgo(days: Int) -> Date {
        let calendar = Calendar.current
        guard let day = calendar.date(byAdding: .day, value: -days, to: .now.startOfDay()) else {
            return .now
        }
        return day
    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}

extension Date {
    func descriptiveString(dateStyle: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        
        let daysBetween = self.daysBetween(date: Date())
        switch daysBetween {
        case 0:
            return "Today"
        case 1:
            return "Yesterday"
        case 2, 3, 4:
            let weekdayIndex = Calendar.current.component(.weekday, from: self) - 1
            return formatter.weekdaySymbols[weekdayIndex]
        default:
            return formatter.string(from: self)
        }
    }
    
    func daysBetween(date: Date) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        if let daysBetween = calendar.dateComponents([.day], from: date1, to: date2).day {
            return daysBetween
        }
        return 0
    }
    
    func getStartOfMonth(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)
        return startOfMonth ?? Date() // In case startOfMonth is nil, return current date
    }
    
    func getStartOfYear(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        let startOfMonth = calendar.date(from: components)
        return startOfMonth ?? Date() // In case startOfMonth is nil, return current date
    }
    
    func monthsBetween(date: Date) -> Int {
        let calendar = Calendar.current
        let date1 = getStartOfMonth(date: self)
        let date2 = getStartOfMonth(date: date)
        if let monthsBetween = calendar.dateComponents([.month], from: date1, to: date2).month {
            return monthsBetween
        }
        return 0
    }
    
    func yearsBetween2Dates(date1: Date, date2: Date) -> Int {
        let calendar = Calendar.current
        let date1 = getStartOfYear(date: date1)
        let date2 = getStartOfYear(date: date2)
        if let yearssBetween = calendar.dateComponents([.year], from: date1, to: date2).year {
            return yearssBetween
        }
        return 0
    }
    
    func yearsBetween(date: Date) -> Int {
        let calendar = Calendar.current
        let date1 = getStartOfYear(date: self)
        let date2 = getStartOfYear(date: date)
        if let yearssBetween = calendar.dateComponents([.year], from: date1, to: date2).year {
            return yearssBetween
        }
        return 0
    }
    
    func startOfDay() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
}
