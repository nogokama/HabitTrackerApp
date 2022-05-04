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

    init(habit: DiscreteHabit) {
        self.habit = habit
    }

    var body: some View {
        Button(
            action: {
                print("Large Button tapped!")
            },
            label: {
                VStack {
                    HStack {
                        Text(habit.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top)
                            .padding(.leading)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Spacer(minLength: 30)
                    HStack {
                        Text("\(habit.calculateTotalSuccess())%")
                            .font(.title)
                            .foregroundColor(.white)
                        Spacer()
                        TappingButtonsView(habit: habit)
                    }
                        .padding(.leading)
                        .padding(.trailing)
                }
                    .padding(.bottom)
                    .background(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(#colorLiteral(red: 0.776, green: 0.266, blue: 0.988, alpha: 1)), location: 0),
                                .init(color: Color(#colorLiteral(red: 0.357, green: 0.349, blue: 0.870, alpha: 1)), location: 1)
                            ]),
                            startPoint: .bottomTrailing,
                            endPoint: .topLeading
                        )
                    )
                    .cornerRadius(20)
            }
        ).padding()
    }
}

class DiscreteHabitView_Previews: PreviewProvider {
    static var previews: some View {
        DiscreteHabitView(habit: DiscreteHabit())
    }

    #if DEBUG
    @objc class func injected() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController =
                UIHostingController(rootView: DiscreteHabitView(habit: DiscreteHabit()))
    }
    #endif
}


struct TappingButtonsView: View {
    let habit: DiscreteHabit
    let totalButtonsCount = 4

    init(habit: DiscreteHabit) {
        self.habit = habit
    }

    var body: some View {
        HStack {
            ForEach(0..<totalButtonsCount) { element in
<<<<<<< HEAD
                SingleTypingButtonView(habit: habit,
                        position: totalButtonsCount - element - 1)
=======
                SingleTypingButtonView(
                    habit: habit,
                    position: totalButtonsCount - element
                )
>>>>>>> d159b6d (Basic fixes)
            }
        }
    }
}

class TappingButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        TappingButtonsView(habit: DiscreteHabit())
    }

    #if DEBUG
    @objc class func injected() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController =
                UIHostingController(rootView: TappingButtonsView(habit: DiscreteHabit()))
    }
    #endif
}


struct SingleTypingButtonView: View {
    let habit: DiscreteHabit
    let position: Int

    @State var tapped: Bool

    init(habit: DiscreteHabit, position: Int) {
        self.habit = habit
        self.position = position
        tapped = habit.isPositionTapped(position: position)
    }

    var body: some View {
        Button(action: {
            if tapped {
                self.habit.unmarkPosition(position: self.position)
            } else {
                self.habit.markPosition(position: self.position)
            }
            print("Hello from Habit \(habit.title), button number: \(position)")
            tapped.toggle()
        }, label: {
            HStack {
                if tapped {
                    Image(systemName: "checkmark")
                        .scaledToFit()
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "poweroff")
                        .foregroundColor(.white)
                }
            }
        })
    }
}

class SingleTypingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SingleTypingButtonView(habit: DiscreteHabit(), position: 0)
    }

    #if DEBUG
    @objc class func injected() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController =
                UIHostingController(rootView: SingleTypingButtonView(habit: DiscreteHabit(), position: 0))
    }
    #endif
}

