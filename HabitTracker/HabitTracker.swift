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
            if let decoded = try? decoder.decode([DiscreteHabit].self, from: habits) {
                self.habits = decoded
                return
            }
        }
        else {
            self.habits = [
                DiscreteHabit( title: "Чтение"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
                DiscreteHabit(title: "Прогулка"),
            ]
        }
    }
    
    public func getHabits() -> Array<DiscreteHabit> {
        return self.habits;
    }

    public func addNewHabit(habit : DiscreteHabit) {
        self.habits.append(habit)
    }
    
    @Published var habits: [DiscreteHabit] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(habits) {
                UserDefaults.standard.set(encoded, forKey: "Habits")
            }
        }
    }
}
