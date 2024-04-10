//
//  OffsetKey.swift
//  GymMe
//
//  Created by Максим Троицкий on 02.03.2024.
//

import Foundation
import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
