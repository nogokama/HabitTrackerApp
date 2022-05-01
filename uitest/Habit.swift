//
//  Habit.swift
//  uitest
//
//  Created by Тагир Хамитов on 01.05.2022.
//

import Foundation

class Habit: Identifiable {
    init(id: Int, title: String) {
        self.id = id
        self.title = title;
        self.completed_days = Set();
    }
    
    public func addDate(date: Date) {
        completed_days.insert(date);
    }
    
    var id: Int
    var title: String;
    var completed_days: Set<Date>;
}
