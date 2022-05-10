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
    }

    private enum CodingKeys: CodingKey {
        case id, title
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
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
}
