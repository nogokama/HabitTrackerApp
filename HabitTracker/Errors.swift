//
// Created by Артём Макогон on 15.05.2022.
//

import Foundation

enum HabitTrackerErrors: Error {
    case chartDataError(String)
    case percentageCalculationError(String)
}
