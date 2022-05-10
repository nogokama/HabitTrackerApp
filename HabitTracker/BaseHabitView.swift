//
//  BaseHabitView.swift
//  HabitTracker
//
//  Created by Тагир Хамитов on 10.05.2022.
//

import SwiftUI

struct BaseHabitView: View {
    let habit: BaseHabit

    var body: some View {
        if habit is DiscreteHabit {
            DiscreteHabitView(habit: habit as! DiscreteHabit)
        }
    }
}

class BaseHabitView_Previews: PreviewProvider {
    static var previews: some View {
        BaseHabitView(habit: DiscreteHabit())
    }

    #if DEBUG
        @objc class func injected() {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.windows.first?.rootViewController =
                UIHostingController(
                    rootView: BaseHabitView(habit: DiscreteHabit())
                )
        }
    #endif
}
