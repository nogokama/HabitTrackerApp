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
    }

    private enum CodingKeys: CodingKey {
        case id, title, archived
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
        self.progress = 0
        self.habitTracker = nil
    }

    func encode(to encoder: Encoder) throws {
        preconditionFailure("This method must be overridden")
    }

    var id: UUID
    @Published var title: String
    @Published var progress: Int
    var habitTracker: HabitTracker?
    var archived: Bool {
        didSet {
            habitTracker!.dumpAllData()
        }
    }
}
