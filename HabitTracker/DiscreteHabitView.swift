//
//  HabitView.swift
//  uitest
//
//  Created by Тагир Хамитов on 01.05.2022.
//

import Foundation
import SwiftUI

struct DiscreteHabitView: View {
    let habit: DiscreteHabit

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
                                Text("\(habit.calculateTotalSuccess())%")
                                        .font(.title)
                                        .foregroundColor(.black)
                                Spacer()
                                TappingButtonsView(habit: habit)
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
    let totalButtonsCount = 4
    var body: some View {
        HStack {
            ForEach(0..<totalButtonsCount) { element in
                SingleTypingButtonView(habit: habit,
                        position: totalButtonsCount - element)
            }
        }
    }
}

struct SingleTypingButtonView: View {
    let habit: DiscreteHabit
    let position: Int
    @State var tapped = false
    var body: some View {
        Button(action: {
            print("Hello from Habit \(habit.title), button number: \(position)")
            tapped.toggle()
        }, label: {
            HStack {
                if tapped {
                    Image(systemName: "1.circle.fill")
                } else {
                    Image(systemName: "1.circle")
                }
            }
        })
    }
}
