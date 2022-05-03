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
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text("\(habit.calculateTotalSuccess())%")
                                .font(.title)
                        Spacer()
                        Button(action: {
                            print("Small button tapped!")
                        }, label: {
                            Image(systemName: "1.circle.fill")
                        })
                        Button(action: {
                        }, label: {
                            Image(systemName: "1.circle.fill")
                        })
                        Button(action: {
                        }, label: {
                            Image(systemName: "1.circle.fill")
                        })
                        Button(action: {
                        }, label: {
                            Image(systemName: "1.circle.fill")
                        })
                    }
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                }
                        .padding(.bottom)
                        .background(.gray)
                        .cornerRadius(10)
            }
                    .frame(width: UIScreen.main.bounds.width * 0.9,
                            height: UIScreen.main.bounds.height * 0.15)
        }
        )
    }
}
