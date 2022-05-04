//
//  Habit.swift
//  uitest
//
//  Created by Тагир Хамитов on 01.05.2022.
//

import Foundation

class DiscreteHabit: ObservableObject, Identifiable, Codable {
    init(title: String) {
        self.id = UUID()
        self.title = title;
        self.completed_days = Set();
        self.success = 0
        self.habitTracker = nil
        self.success = calculateTotalSuccess()
    }

    private func getStringByDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }

    private func getDateByString(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.date(from: string)!
        // TODO check exceptions
    }

    public func addDate(date: Date) {
        completed_days.insert(getStringByDate(date: date));
    }

    private func removeDate(date: Date) {
        completed_days.remove(getStringByDate(date: date))
    }

    public func checkDateInCompletedDays(date: Date) -> Bool {
        completed_days.contains(getStringByDate(date: date))
    }

    private func getDateFromToday(byAddingDays: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: byAddingDays, to: Date.now)!
        // TODO check exceptions
    }

    public func unmarkPosition(position: Int) {
        removeDate(date: getDateFromToday(byAddingDays: -position))
        recalculateSuccess()
        habitTracker!.dumpAllData()
        //FIXME each habit now must know about habitTracker
    }

    public func markPosition(position: Int) {
        addDate(date: getDateFromToday(byAddingDays: -position))
        recalculateSuccess()
        habitTracker!.dumpAllData()
        //FIXME each habit now must know about habitTracker
    }

    public func isPositionTapped(position: Int) -> Bool {
        checkDateInCompletedDays(date: getDateFromToday(byAddingDays: -position))
    }

    public func calculateTotalSuccess() -> Int {
        var dates: Array<Date> = []
        for element in completed_days {
            dates.append(getDateByString(string: element))
        }
        if !completed_days.contains(getStringByDate(date: Date.now)) &&
                   !completed_days.contains(
                           getStringByDate(date: getDateFromToday(byAddingDays: -1))
                   ) {
            dates.append(getDateFromToday(byAddingDays: -1))
        }

        dates.sort()
        var answer = 0
        for i in 0..<dates.count - 1 {
            answer += calculateAditionalPercent(current_persent: answer)
            answer -= calculateFailPercent(
                    skip_uninterrupted_days: daysBetween(start: dates[i], end: dates[i + 1])
            )
            answer = max(0, answer)
        }

        if completed_days.contains(getStringByDate(date: dates[dates.count - 1])) {
            answer += calculateAditionalPercent(current_persent: answer)
        }
        return answer
    }

    private func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day! - 1
    }

    private func recalculateSuccess() {
        success = calculateTotalSuccess()
        print(success)
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
    @Published var title: String
    var completed_days: Set<String>
    @Published var success: Int
    var habitTracker:HabitTracker?

    private enum CodingKeys: CodingKey {
        case id, title, completed_days
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        completed_days = try container.decode(Set<String>.self, forKey: .completed_days)
        success = 0
        success = calculateTotalSuccess()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(completed_days, forKey: .completed_days)
    }
}
