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
            Spacer()
            HStack {
                Text("Habit Tracker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                Spacer()
            }.frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.1)

            ScrollView {
                ForEach(habitTracker.habits) { habit in
                    HabitView(habit: habit)
                }
            }
                    .padding()

            Spacer()

            HStack(alignment: .top) {
                Spacer()
                Button(action: {
                    self.showingAddingHabitWindow = true
                },
                label: {
                    Text("+")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.width*0.2)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .top, endPoint: .bottom))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .padding(10)
                }
                )
                        .sheet(isPresented: $showingAddingHabitWindow) {
                            CreatingHabitView(habitTracker: self.habitTracker)
                        }
            }
                    .frame(width: UIScreen.main.bounds.width * 0.9,
                            height: UIScreen.main.bounds.height * 0.1)
            Spacer()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
