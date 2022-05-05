//
//  Habit.swift
//  uitest
//
//  Created by Тагир Хамитов on 01.05.2022.
//

import Foundation

class HabitDate: Hashable, Codable, Comparable {

    static func ==(lhs: HabitDate, rhs: HabitDate) -> Bool {
        lhs.day == rhs.day && lhs.month == rhs.month && lhs.year == rhs.year
    }

    static func < (lhs: HabitDate, rhs: HabitDate) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            return lhs.month < rhs.month
        } else {
            return lhs.day < rhs.day
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(day)
        hasher.combine(month)
        hasher.combine(year)
    }

    init(day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
    }

    init(date: Date) {
        self.day = Calendar.current.component(.day, from: date)
        self.month = Calendar.current.component(.month, from: date)
        self.year = Calendar.current.component(.year, from: date)
    }

    private func getSwiftDate() -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar(identifier: .gregorian).date(from: components)!
    }

    public func getDaysDifference(otherDate: HabitDate) -> Int {
        Calendar.current.dateComponents([.day],
                from: getSwiftDate(),
                to: otherDate.getSwiftDate()).day! - 1
    }

    static func getDateFromToday(byAddingDays: Int) -> HabitDate {
        HabitDate(date: Calendar.current.date(byAdding: .day,
                value: byAddingDays,
                to: Date.now)!)
    }

    static func today() -> HabitDate {
        HabitDate(date: Date.now)
    }

    static func yesterday() -> HabitDate {
        getDateFromToday(byAddingDays: -1)
    }

    var day: Int
    var month: Int
    var year: Int
}


class DiscreteHabit: ObservableObject, Identifiable, Codable {
    init(title: String = "default") {
        self.id = UUID()
        self.title = title;
        self.completed_days = Set();
        self.progress = 0
        self.habitTracker = nil
        self.progress = calculateTotalProgress()
    }

    public func addDate(date: HabitDate) {
        completed_days.insert(date);
    }
    public func addDate(date: Date) {
        completed_days.insert(HabitDate(date: date));
    }

    private func removeDate(date: HabitDate) {
        completed_days.remove(date)
    }
    private func removeDate(date: Date) {
        completed_days.remove(HabitDate(date: date))
    }


    public func checkDateInCompletedDays(date: HabitDate) -> Bool {
        completed_days.contains(date)
    }

    public func unmarkPosition(position: Int) {
        removeDate(date: HabitDate.getDateFromToday(byAddingDays: -position))
        recalculateProgress()
        //FIXME each habit now must know about habitTracker
    }

    public func markPosition(position: Int) {
        addDate(date: HabitDate.getDateFromToday(byAddingDays: -position))
        recalculateProgress()
        //FIXME each habit now must know about habitTracker
    }

    public func isPositionTapped(position: Int) -> Bool {
        completed_days.contains(HabitDate.getDateFromToday(byAddingDays: -position))
    }

    public func calculateTotalProgress() -> Int {
        var dates: Array<HabitDate> = []
        for element in completed_days {
            dates.append(element)
        }
        if !completed_days.contains(HabitDate.today()) &&
                   !completed_days.contains(HabitDate.yesterday()) {
            dates.append(HabitDate.yesterday())
        }

        dates.sort()
        var answer = 0
        for i in 0..<dates.count - 1 {
            answer += calculateAdditionalPercent(currentPercent: answer)
            answer -= calculateFailPercent(
                    skip_uninterrupted_days: dates[i].getDaysDifference(otherDate: dates[i + 1])
            )
            answer = max(0, answer)
        }

        if completed_days.contains(dates[dates.count - 1]) {
            answer += calculateAdditionalPercent(currentPercent: answer)
        }
        return answer
    }


    private func recalculateProgress() {
        progress = calculateTotalProgress()
        print(progress)
    }

    private func calculateAdditionalPercent(currentPercent: Int) -> Int {
        if (currentPercent <= 2) {
            return 5
        }
        if (currentPercent <= 10) {
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
    var completed_days: Set<HabitDate> {
        didSet {
            habitTracker!.dumpAllData()
            // TODO check if nil
        }
    }

    @Published var progress: Int
    var habitTracker: HabitTracker?

    private enum CodingKeys: CodingKey {
        case id, title, completed_days
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        completed_days = try container.decode(Set<HabitDate>.self, forKey: .completed_days)
        progress = 0
        progress = calculateTotalProgress()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(completed_days, forKey: .completed_days)
    }
}
