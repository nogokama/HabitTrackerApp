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
    @State var showingDetailsView: Bool = false

    init(habit: DiscreteHabit) {
        self.habit = habit
    }

    var body: some View {
        ZStack {
            Button(
                action: {
                    print("Large button tapped")
                    showingDetailsView = true
                },
                label: {
                    VStack(spacing: 20) {
                        HStack {
                            Text(habit.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        HStack {
                            Text("\(habit.progress)%")
                                .font(.title)
                                .foregroundColor(.black)
                            Spacer()
                        }
                    }
                }
            )
            .padding()
            .background(Color.yellow)
            .cornerRadius(20)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    TappingButtonsView(habit: habit)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingDetailsView) {
            HabitDetailsView(habit: habit, showingHabitDetailsView: $showingDetailsView)
        }
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
        HStack(spacing: 0) {
            ForEach(0..<totalButtonsCount) { element in
                SingleTypingButtonView(
                    habit: habit,
                    position: totalButtonsCount - element
                )
            }
        }
        .padding(.leading)
        .padding(.trailing)
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
        Button(
            action: {
                if tapped {
                    self.habit.unmarkPosition(position: self.position)
                } else {
                    self.habit.markPosition(position: self.position)
                }
                print("Hello from Habit \(habit.title), button number: \(position)")
                tapped.toggle()
            },
            label: {
                if tapped {
                    Image(systemName: "checkmark")
                        .foregroundColor(.black)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.black)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                }
            }
        )
        .frame(
            width: 40,
            height: 40
        )
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
                UIHostingController(
                    rootView: SingleTypingButtonView(habit: DiscreteHabit(), position: 0))
        }
    #endif
}
