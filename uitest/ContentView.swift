//
//  ContentView.swift
//  uitest
//
//  Created by Артём Макогон on 11.11.2021.
//

import SwiftUI

struct ContentView: View {
    var habitTracker = HabitTracker()
    
    var body: some View {
        ScrollView {
            ForEach(habitTracker.habits) { habit in
                HabitView(habit: habit)
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
