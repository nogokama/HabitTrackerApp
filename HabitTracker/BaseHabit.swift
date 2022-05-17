//
//  BaseHabit.swift
//  HabitTracker
//
//  Created by Тагир Хамитов on 10.05.2022.
//

import Foundation

class BaseHabit: ObservableObject, Identifiable, Codable {
    init(title: String = "default") {
        self.id = UUID()
        self.title = title
        self.progress = 0
        self.habitTracker = nil
        self.archived = false
        self.colorStyleNumber = 0
        self.orderNumber = -1
    }

    private enum CodingKeys: CodingKey {
        case id, title, archived, colorStyle, orderNumber
    }

    public func archive() {
        self.archived = true
        self.habitTracker!.markHabitArchived(habit: self)
    }

    public func isArchived() -> Bool {
        archived
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        do {
            try self.archived = container.decode(Bool.self, forKey: .archived)
        } catch {
            self.archived = false
        }
        do {
            try self.colorStyleNumber = container.decode(Int.self, forKey: .colorStyle)
        } catch {
            self.colorStyleNumber = 0
        }
        do {
            try self.orderNumber = container.decode(Int.self, forKey: .orderNumber)
        } catch {
            self.orderNumber = -1
        }
        self.progress = 0
        self.habitTracker = nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(archived, forKey: .archived)
        try container.encode(colorStyleNumber, forKey: .colorStyle)
        try container.encode(orderNumber, forKey: .orderNumber)
    }

    var id: UUID
    @Published var title: String
    @Published var progress: Int
    @Published var colorStyleNumber: Int {
        didSet {
            habitTracker!.dumpAllData()
        }
    }
    @Published var orderNumber: Int {
        didSet {
            habitTracker!.dumpAllData()
        }
    }
    var habitTracker: HabitTracker?
    var archived: Bool {
        didSet {
            habitTracker!.dumpAllData()
        }
    }
}
