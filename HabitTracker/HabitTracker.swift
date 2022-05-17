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
            }
        }
        self.publishedHabits = []
        for habit in self.habits {
            if !habit.isArchived() {
                self.publishedHabits.append(habit)
            }
        }
        for i in 0..<self.habits.count {
            self.habits[i].habitTracker = self
            if self.habits[i].orderNumber == -1 {
                self.habits[i].orderNumber = i
            }
        }
    }

    public func getHabits() -> [BaseHabit] {
        return self.habits.sorted {
            $0.orderNumber < $1.orderNumber
        }
    }

    public func addNewHabit(habit: DiscreteHabit) {
        habit.orderNumber = self.habits.count
        self.habits.append(habit)
        if !habit.isArchived() {
            self.publishedHabits.append(habit)
        }
    }

    public func markHabitArchived(habit: BaseHabit) {
        self.publishedHabits.remove(
            at: self.publishedHabits.firstIndex(where: { (h: DiscreteHabit) -> Bool in
                return h.id == habit.id
            })!
        )
    }

    public func dumpAllData() {
        print("I am dumping!")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(habits) {
            UserDefaults.standard.set(encoded, forKey: "Habits")
        }
        print("I am dumped!")
    }

    var habits: [DiscreteHabit] {
        didSet {
            dumpAllData()
        }
    }

    @Published var publishedHabits: [DiscreteHabit] {
        didSet {
            dumpAllData()
        }
    }
}
