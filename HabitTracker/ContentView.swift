//
//  ContentView.swift
//  uitest
//
//  Created by Артём Макогон on 11.11.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAddingHabitWindow = false
    @ObservedObject var habitTracker = HabitTracker()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(habitTracker.habits) { habit in
                    HabitView(habit: habit)
                }
            }
                    .padding()
            Spacer()
            Button("Add new habit") {
                self.showingAddingHabitWindow = true
            }
                    .sheet (isPresented: $showingAddingHabitWindow) {
                        CreatingHabitView(habitTracker: self.habitTracker)
                    }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
