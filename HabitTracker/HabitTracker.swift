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
        self.habits.sort {
            $0.orderNumber < $1.orderNumber
        }
        for habit in self.habits {
            habit.habitTracker = self
            if !habit.isArchived() {
                habit.orderNumber = publishedHabits.count
                self.publishedHabits.append(habit)
            } else {
                habit.orderNumber = -1
            }
        }
    }

    public func getHabits() -> [BaseHabit] {
        publishedHabits.sorted {
            $0.orderNumber < $1.orderNumber
        }
    }

    public func addNewHabit(habit: DiscreteHabit) {
        habit.orderNumber = habit.isArchived() ? -1 : 0
        self.habits.append(habit)
        if habit.isArchived() {
            return
        }
        for habit in publishedHabits {
            habit.orderNumber += 1
        }
        self.publishedHabits.append(habit)
    }

    private func recalculateHabitOrders() {
        self.publishedHabits.sort {
            $0.orderNumber < $1.orderNumber
        }
        for i in 0..<publishedHabits.count {
            publishedHabits[i].orderNumber = i
        }
    }

    public func markHabitArchived(habit: BaseHabit) {
        self.publishedHabits.remove(
            at: self.publishedHabits.firstIndex(where: { (h: DiscreteHabit) -> Bool in
                return h.id == habit.id
            })!
        )
        self.recalculateHabitOrders()
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
