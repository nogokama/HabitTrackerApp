//
//  HabitTracker.swift
//  uitest
//
//  Created by Тагир Хамитов on 01.05.2022.
//

import Foundation

class HabitTracker: ObservableObject {
    init() {
        self.habits = []
        if let habits = UserDefaults.standard.data(forKey: "Habits") {
            let json = NSString(data: habits, encoding: String.Encoding.utf8.rawValue)
            print(json)
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([DiscreteHabit].self, from: habits) {
                self.habits = decoded
                return
            }
        }
    }


    public func getHabits() -> Array<DiscreteHabit> {
        return self.habits;
    }

    public func addNewHabit(habit: DiscreteHabit) {
        self.habits.append(habit)
    }

    public func dumpAllData() {
        print("I am dumping!")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(habits) {
            UserDefaults.standard.set(encoded, forKey: "Habits")
        }
        print("I am dumped!")
    }

    @Published var habits: [DiscreteHabit] {
        didSet {
            dumpAllData()
        }
    }
}
