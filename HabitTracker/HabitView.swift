//
//  HabitView.swift
//  uitest
//
//  Created by Тагир Хамитов on 01.05.2022.
//

import Foundation
import SwiftUI

struct HabitView: View {
    let habit: DiscreteHabit
    
    var body: some View {
        HStack {
            VStack {
                Text(habit.title)
                    .font(.headline.bold())
                    .padding(.top)
                    .padding(.leading)
                HStack {
                }
            }
            .padding(.bottom)
            .background(.gray)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
    }
}
