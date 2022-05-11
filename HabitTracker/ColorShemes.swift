//
// Created by Артём Макогон on 11.05.2022.
//

import Foundation
import SwiftUI

public class HabitColorStyle {
    public var mainColor: Color

    public init(mainColor: Color) {
        self.mainColor = mainColor
    }
}

public struct ColorStyles {
    public static let yellowHabitStyle = HabitColorStyle(mainColor: .yellow)
    public static let orangeHabitStyle = HabitColorStyle(mainColor: .orange)
    public static let greenHabitStyle = HabitColorStyle(mainColor: .green)
    public static let blueHabitStyle = HabitColorStyle(mainColor: .blue)
    public static let purpleHabitStyle = HabitColorStyle(mainColor: .purple)

    public static let allStyles = [
        yellowHabitStyle,
        orangeHabitStyle,
        greenHabitStyle,
        blueHabitStyle,
        purpleHabitStyle,
    ]
}
