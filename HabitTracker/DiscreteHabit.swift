//
//  Habit.swift
//  uitest
//
//  Created by Тагир Хамитов on 01.05.2022.
//

import Foundation

class HabitDate: Hashable, Codable, Comparable {

    static func == (lhs: HabitDate, rhs: HabitDate) -> Bool {
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
        Calendar.current.dateComponents(
            [.day],
            from: getSwiftDate(),
            to: otherDate.getSwiftDate()
        ).day! - 1
    }

    static func getDateFromToday(byAddingDays: Int) -> HabitDate {
        HabitDate(
            date: Calendar.current.date(
                byAdding: .day,
                value: byAddingDays,
                to: Date.now)!)
    }

    static func today() -> HabitDate {
        HabitDate(date: Date.now)
    }

    static func yesterday() -> HabitDate {
        getDateFromToday(byAddingDays: -1)
    }

    static let weekdays = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
    ]

    private static func getSwiftDateFromToday(fromToday: Int) -> Date {
        let today = Date()
        var dateComponent = DateComponents()
        dateComponent.day = -fromToday
        return Calendar.current.date(byAdding: dateComponent, to: today)!
    }

    static func getWeekday(fromToday: Int) -> String {
        let targetDate = getSwiftDateFromToday(fromToday: fromToday)
        return Self.weekdays[Calendar.current.component(.weekday, from: targetDate) - 1]
    }

    static func getDay(fromToday: Int) -> String {
        let targetDate = getSwiftDateFromToday(fromToday: fromToday)
        return String(format: "%02d", Calendar.current.component(.day, from: targetDate))
    }

    static func getShortStringDate(date: HabitDate) -> String {
        "\(String(format: "%02d", date.day)).\(String(format: "%02d", date.month))"
    }

    static func getNLastDays(days: Int) -> [String] {
        var ans: [String] = []
        for i in stride(from: days - 1, to: -1, by: -1) {
            let date = getDateFromToday(byAddingDays: -i)
            ans.append(HabitDate.getShortStringDate(date: date))
        }
        return ans
    }

    var day: Int
    var month: Int
    var year: Int
}

class DiscreteHabit: BaseHabit {
    override init(title: String = "default") {
        self.completed_days = Set()
        super.init(title: title)
        self.progress = calculateTotalProgress()
    }

    public func addDate(date: HabitDate) {
        completed_days.insert(date)
    }
    public func addDate(date: Date) {
        completed_days.insert(HabitDate(date: date))
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

    public func calculateTotalProgressByDate(targetDate: HabitDate) -> Int {
        var dates: [HabitDate] = []
        for element in completed_days {
            if element <= targetDate {
                dates.append(element)
            }
        }
        if !completed_days.contains(HabitDate.today())
            && !completed_days.contains(HabitDate.yesterday())
        {
            dates.append(HabitDate.yesterday())
        }

        dates.sort()
        var answer = 0
        if dates.count == 0 {
            return answer
        }
        for i in 0..<dates.count - 1 {
            answer += calculateAdditionalPercent(currentPercent: answer)
            answer -= calculateFailPercent(
                skip_uninterrupted_days: dates[i].getDaysDifference(otherDate: dates[i + 1])
            )
            answer = max(0, answer)
        }

        if completed_days.contains(dates[dates.count - 1]) && dates[dates.count - 1] <= targetDate {
            answer += calculateAdditionalPercent(currentPercent: answer)
        }
        return answer
    }

    public func calculateTotalProgressNDaysAgo(days: Int) -> Int {
        calculateTotalProgressByDate(targetDate: HabitDate.getDateFromToday(byAddingDays: days))
    }

    public func calculateTotalProgress() -> Int {
        calculateTotalProgressByDate(targetDate: HabitDate.today())
    }

    public func calculateProgressForNLastDays(days: Int) -> [Double] {
        var ans: [Double] = []
        for i in stride(from: days - 1, through: -1, by: -1) {
            ans.append(
                Double(
                    calculateTotalProgressByDate(
                        targetDate: HabitDate.getDateFromToday(byAddingDays: -i))))
        }
        return ans
    }

    public func calculateProgressPerStepDays(stepDays: Int, pointsCount: Int) -> ChartData {
        let data = ChartData(xLabels: [], yValues: [])
        for shift in stride(from: stepDays * (pointsCount - 1), through: 0, by: -stepDays) {
            data.addPoint(
                xLabel: HabitDate.getShortStringDate(
                    date: HabitDate.getDateFromToday(byAddingDays: -shift)),
                yValue: Double(
                    self.calculateTotalProgressByDate(
                        targetDate: HabitDate.getDateFromToday(byAddingDays: -shift))))
        }
        return data
    }

    public func calculateProgressPerPeriod(periodInDaysFromToday: Int, pointsCount: Int) throws
        -> ChartData
    {
        if periodInDaysFromToday < pointsCount {
            throw HabitTrackerErrors.chartDataError("too few days for displaying on graph")
        }

        return calculateProgressPerStepDays(
            stepDays: (periodInDaysFromToday + pointsCount - 1) / pointsCount,
            pointsCount: pointsCount)
    }

    private func recalculateProgress() {
        progress = calculateTotalProgress()
        print(progress)
    }

    private func calculateAdditionalPercent(currentPercent: Int) -> Int {
        if currentPercent <= 2 {
            return 5
        }
        if currentPercent <= 10 {
            return 2
        }
        return 1
    }

    private func calculateFailPercent(skip_uninterrupted_days: Int) -> Int {
        if skip_uninterrupted_days >= 17 {
            return 100
        }
        return Int(floor(pow(1.2, Double(skip_uninterrupted_days - 1))))
    }

    var completed_days: Set<HabitDate> {
        didSet {
            habitTracker!.dumpAllData()
            // TODO check if nil
        }
    }

    private enum CodingKeys: CodingKey {
        case id, title, completed_days
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.completed_days = try container.decode(Set<HabitDate>.self, forKey: .completed_days)
        try super.init(from: decoder)
        self.progress = calculateTotalProgress()
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(completed_days, forKey: .completed_days)
        try super.encode(to: encoder)
    }
}
