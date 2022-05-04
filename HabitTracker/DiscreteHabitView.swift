//
//  HabitView.swift
//  uitest
//
//  Created by Тагир Хамитов on 01.05.2022.
//

import Foundation
import SwiftUI

struct DiscreteHabitView: View {
    @ObservedObject var habit: DiscreteHabit
    let habitTracker: HabitTracker

    init(habit: DiscreteHabit, habitTracker: HabitTracker = HabitTracker()) {
        self.habit = habit
        self.habitTracker = habitTracker
    }

    var body: some View {
        Button(action: {
            print("Large Button tapped!")
        }
                ,
                label: {
                    HStack {
                        VStack {
                            HStack {
                                Text(habit.title)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.top)
                                        .padding(.leading)
                                        .foregroundColor(.black)
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                Text("\(habit.success)%")
                                        .font(.title)
                                        .foregroundColor(.black)
                                Spacer()
                                TappingButtonsView(habit: habit, habitTracker: habitTracker)
                            }
                                    .frame(width: UIScreen.main.bounds.width * 0.8)
                        }
                                .padding(.bottom)
                                .background(.yellow)
                                .cornerRadius(10)
                    }
                            .frame(width: UIScreen.main.bounds.width * 0.9,
                                    height: UIScreen.main.bounds.height * 0.15)
                }
        )
    }
}

struct TappingButtonsView: View {
    let habit: DiscreteHabit
    let habitTracker: HabitTracker
    let totalButtonsCount = 4

    init(habit: DiscreteHabit, habitTracker: HabitTracker = HabitTracker()) {
        self.habit = habit
        self.habitTracker = habitTracker
    }

    var body: some View {
        HStack {
            ForEach(0..<totalButtonsCount) { element in
                SingleTypingButtonView(habit: habit,
                        position: totalButtonsCount - element - 1,
                        habitTracker: habitTracker)
            }
        }
    }
}

struct SingleTypingButtonView: View {
    let habit: DiscreteHabit
    let position: Int
    let habitTracker: HabitTracker

    @State var tapped: Bool

    init(habit: DiscreteHabit, position: Int, habitTracker: HabitTracker = HabitTracker()) {
        self.habit = habit
        self.position = position
        self.habitTracker = habitTracker
        tapped = habit.isPositionTapped(position: position)
    }

    var body: some View {
        Button(action: {
            if tapped {
                self.habit.unmarkPosition(position: self.position)
            } else {
                self.habit.markPosition(position: self.position)
            }
            habitTracker.dumpAllData()
            print("Hello from Habit \(habit.title), button number: \(position)")
            tapped.toggle()
        }, label: {
            HStack {
                if tapped {
                    Image(systemName: "checkmark")
                            .foregroundColor(.black)
                } else {
                    Image(systemName: "poweroff")
                            .foregroundColor(.black)
                }
            }
        })
    }
}
