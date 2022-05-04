//
//  Habit.swift
//  uitest
//
//  Created by Тагир Хамитов on 01.05.2022.
//

import Foundation

class DiscreteHabit: Identifiable, Codable {
    init(title: String = "default") {
        self.id = UUID()
        self.title = title;
        self.completed_days = Set();
    }
    
    public func addDate(date: Date) {
        completed_days.insert(date);
    }

    public func calculateTotalSuccess() -> Int {
        let cur_date = Date.now
//        for i in 0...completed_days.count - 1 {
//            // TODO
//        }
        return 10; // TODO
    }

    private func calculateAditionalPercent(current_persent: Int) -> Int {
        if (current_persent <= 2) {
            return 5
        }
        if (current_persent <= 7) {
            return 3
        }
        if (current_persent <= 15) {
            return 2
        }
        return 1
    }

    private func calculateFailPercent(skip_uninterrupted_days: Int) -> Int {
        if (skip_uninterrupted_days >= 17) {
            return 100
        }
        return Int(floor(pow(1.2, Double(skip_uninterrupted_days - 1))))
    }
    
    var id: UUID
    var title: String;
    var completed_days: Set<Date>;
}
