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
                Habit( title: "Чтение"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
                Habit(title: "Прогулка"),
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
