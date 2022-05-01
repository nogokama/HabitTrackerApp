//
//  HabitTracker.swift
//  uitest
//
//  Created by Тагир Хамитов on 01.05.2022.
//

import Foundation

class HabitTracker : ObservableObject {
    init() {
        self.habits = []
        if let habits = UserDefaults.standard.data(forKey: "Habits") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Habit].self, from: habits) {
                self.habits = decoded
                return
            }
        }
        else {
            self.habits = [
                Habit(id: 0, title: "Чтение"),
                Habit(id: 1, title: "Прогулка"),
                Habit(id: 2, title: "Прогулка"),
                Habit(id: 3, title: "Прогулка"),
                Habit(id: 4, title: "Прогулка"),
                Habit(id: 5, title: "Прогулка"),
                Habit(id: 6, title: "Прогулка"),
                Habit(id: 7, title: "Прогулка"),
                Habit(id: 8, title: "Прогулка"),
                Habit(id: 9, title: "Прогулка"),
                Habit(id: 10, title: "Прогулка"),
                Habit(id: 11, title: "Прогулка"),
                Habit(id: 12, title: "Прогулка"),
                Habit(id: 13, title: "Прогулка"),
                Habit(id: 14, title: "Прогулка"),
                Habit(id: 15, title: "Прогулка")
            ]
        }
    }
    
    public func getHabits() -> Array<Habit> {
        return self.habits;
    }

    public func addNewHabit(habit : Habit) {
        self.habits.append(habit)
    }
    
    @Published var habits: [Habit] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(habits) {
                UserDefaults.standard.set(encoded, forKey: "Habits")
            }
        }
    }
}
