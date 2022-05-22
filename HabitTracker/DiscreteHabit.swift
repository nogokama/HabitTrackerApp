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

    public func getSwiftDate() -> Date {
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

    public func isOnTheSameWeekAs(otherDate: HabitDate) -> Bool {
        if getDaysDifference(otherDate: otherDate) >= 7 {
            return false
        }
        return Calendar.current.component(.weekOfYear, from: getSwiftDate())
            == Calendar.current.component(.weekOfYear, from: otherDate.getSwiftDate())
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

    static func getFullWeeksCountBetween(startDate: HabitDate, endDate: HabitDate)
        -> Int
    {
        var firstDate = startDate
        var secondDate = endDate
        if firstDate > secondDate {
            swap(&firstDate, &secondDate)
        }
        return
            (firstDate.getDaysDifference(otherDate: secondDate) - getWeekdayNumber(date: secondDate)
            - 7
            + getWeekdayNumber(date: firstDate)) / 7
    }

    static func getWeekdayNumber(date: HabitDate) -> Int {
        Calendar.current.component(.weekday, from: date.getSwiftDate()) - 1
    }

    public func getWeekdayNumber() -> Int {
        HabitDate.getWeekdayNumber(date: self)
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


class DiscreteHabitFrequencyMode: Hashable, Codable, Equatable {
    var targetDaysPerWeek: Int
    init(daysPerWeek: Int = 7) {
        self.targetDaysPerWeek = daysPerWeek
        // TODO add exception if incorrect value
    }

    let borders = [
        [30, 63],
        [25, 77],
        [30, 49],
        [13, 65],
        [29, 49],
        [22, 39],
        [14, 27],
    ]
    let coefficients = [
        [15, 11, 6],
        [9, 6, 2],
        [7, 4, 2],
        [7, 5, 1],
        [6, 5, 1],
        [5, 3, 1],
        [4, 2, 1]
    ]

    public func calculateBonusProgress(
        currentProgress: Int, alreadyCompletedDaysPerCurrentWeek: Int
    ) -> Int {

        // to prevent overscoring
        if alreadyCompletedDaysPerCurrentWeek == targetDaysPerWeek + 1 {
            return 0
        }
        if currentProgress == 0 {
            return coefficients[targetDaysPerWeek - 1][0] + 1
        }
        if currentProgress <= borders[targetDaysPerWeek - 1][0] {
            return coefficients[targetDaysPerWeek - 1][0]
        }
        if currentProgress <= borders[targetDaysPerWeek - 1][1] {
            return coefficients[targetDaysPerWeek - 1][1]
        }
        if (currentProgress + coefficients[targetDaysPerWeek - 1][2] + 1) % 10 == 0 {
            return coefficients[targetDaysPerWeek - 1][2] + 1
        }
        return coefficients[targetDaysPerWeek - 1][2]
     }

    public func calculatePenalty(skippedDays: Int) -> Int {
        if skippedDays <= 0 {
            return 0
        }
        // TODO advance bonus progress for different modes
        if skippedDays >= 17 {
            return 100
        }
        return Int(floor(pow(1.2, Double(skippedDays))))
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(targetDaysPerWeek)
    }

    static func == (lhs: DiscreteHabitFrequencyMode, rhs: DiscreteHabitFrequencyMode) -> Bool {
        lhs.targetDaysPerWeek == rhs.targetDaysPerWeek
    }

    static let names = [
        "Once a week", "Twice a week", "3 times a week", "4 times a week", "5 times a week",
        "6 times a week", "Everyday",
    ]
}

class DiscreteHabit: BaseHabit {
    override init(title: String = "default") {
        self.completed_days = Set()
        self.frequencyMode = DiscreteHabitFrequencyMode()
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

        dates.sort()
        var answer = 0
        if dates.count == 0 {
            return answer
        }

        var daysOnCurrentWeek = 1
        answer = self.frequencyMode.calculateBonusProgress(
            currentProgress: answer, alreadyCompletedDaysPerCurrentWeek: 0)

        for i in 1..<dates.count {
            if dates[i].isOnTheSameWeekAs(otherDate: dates[i - 1]) {
                let fullDaysBetween = dates[i].getDaysDifference(otherDate: dates[i - 1]) - 1
                let skippedDays = max(
                    0,
                    min(
                        fullDaysBetween,
                        self.frequencyMode.targetDaysPerWeek - daysOnCurrentWeek
                            - (7 - dates[i - 1].getWeekdayNumber() - 1
                                - fullDaysBetween)))

                answer -= self.frequencyMode.calculatePenalty(skippedDays: skippedDays)
                answer = max(answer, 0)
                answer += self.frequencyMode.calculateBonusProgress(
                    currentProgress: answer, alreadyCompletedDaysPerCurrentWeek: daysOnCurrentWeek)
            } else {
                daysOnCurrentWeek = 0
                var skippedDays =
                    HabitDate.getFullWeeksCountBetween(startDate: dates[i - 1], endDate: dates[i])
                    * self.frequencyMode.targetDaysPerWeek
                skippedDays += self.frequencyMode.targetDaysPerWeek - daysOnCurrentWeek
                skippedDays += max(
                    0, self.frequencyMode.targetDaysPerWeek - 7 + dates[i].getWeekdayNumber())
                answer -= self.frequencyMode.calculatePenalty(skippedDays: skippedDays)
                answer = max(answer, 0)
                answer += self.frequencyMode.calculateBonusProgress(
                    currentProgress: answer, alreadyCompletedDaysPerCurrentWeek: daysOnCurrentWeek)
            }
            daysOnCurrentWeek += 1
        }
        return answer
    }

    public func calculateTotalProgressNDaysAgo(days: Int) -> Int {
        calculateTotalProgressByDate(targetDate: HabitDate.getDateFromToday(byAddingDays: days))
    }

    public func calculateTotalProgress() -> Int {
        if self.completed_days.contains(HabitDate.today()) {
            return calculateTotalProgressByDate(targetDate: HabitDate.today())
        } else {
            return calculateTotalProgressByDate(targetDate: HabitDate.yesterday())
        }
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

    public func calculatePercentagePerPeriod(lastDays: Int) -> Int {
        var completedDaysCount = 0
        for i in stride(from: 0, to: lastDays, by: 1) {
            let date = HabitDate.getDateFromToday(byAddingDays: -i)
            if self.completed_days.contains(date) {
                completedDaysCount += 1
            }
        }
        return completedDaysCount * 100 / lastDays
    }

    public func changeFrequencyMode(newFrequencyMode: DiscreteHabitFrequencyMode) {
        self.frequencyMode = newFrequencyMode
    }

    private func recalculateProgress() {
        progress = calculateTotalProgress()
        print(progress)
    }

    var completed_days: Set<HabitDate> {
        didSet {
            habitTracker!.dumpAllData()
            // TODO check if nil
        }
    }

    var frequencyMode: DiscreteHabitFrequencyMode {
        didSet {
            habitTracker!.dumpAllData()
            // TODO check if nil
        }
    }

    private enum CodingKeys: CodingKey {
        case id, title, completed_days, frequency_mode
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.completed_days = try container.decode(Set<HabitDate>.self, forKey: .completed_days)
        do {
            try self.frequencyMode = container.decode(
                DiscreteHabitFrequencyMode.self, forKey: .frequency_mode)
        } catch {
            self.frequencyMode = DiscreteHabitFrequencyMode()
        }
        try super.init(from: decoder)
        self.progress = calculateTotalProgress()
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(completed_days, forKey: .completed_days)
        try container.encode(frequencyMode, forKey: .frequency_mode)
        try super.encode(to: encoder)
    }
}
