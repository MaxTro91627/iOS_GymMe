//
//  ViewExtensions.swift
//  GymMe
//
//  Created by Максим Троицкий on 02.03.2024.
//

import Foundation
import SwiftUI

extension View {
    // Spacing Extension for Calendar
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
