//
//  Habit.swift
//  uitest
//
//  Created by Тагир Хамитов on 01.05.2022.
//

import Foundation

class DiscreteHabit: Identifiable, Codable {
    init(title: String) {
        self.id = UUID()
        self.title = title;
        self.completed_days = Set();
    }
    
    public func addDate(date: Date) {
        completed_days.insert(date);
    }
    
    var id: UUID
    var title: String;
    var completed_days: Set<Date>;
}
