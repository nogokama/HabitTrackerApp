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
            HStack {
                Text("Habit Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(
                    action: {
                        self.showingAddingHabitWindow = true
                    },
                    label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(
                                width: 40,
                                height: 40
                            )
                    }
                )
                .padding(.trailing)
            }.padding()
            
            HStack {
                Spacer()
                HStack(spacing: 0) {
                    ForEach(0..<TappingButtonsView.totalButtonsCount) { position in
                        Text(getWeekday(fromToday: TappingButtonsView.totalButtonsCount - position - 1))
                            .fontWeight(.bold)
                            .frame(width: 40)
                    }
                }.padding(.trailing)
            }.padding(.trailing)

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(habitTracker.getHabits()) { habit in
                        BaseHabitView(habit: habit)
                    }
                }
            }
            .padding(.leading)
            .padding(.trailing)
        }.sheet(isPresented: $showingAddingHabitWindow) {
            CreatingHabitView(habitTracker: self.habitTracker)
        }
    }
    
    static let weekdays = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
    ]
    
    private func getWeekday(fromToday: Int) -> String {
        print("requested weekday for position \(fromToday)")
        let today = Date()
        var dateComponent = DateComponents()
        dateComponent.day = -fromToday
        
        let targetDate = Calendar.current.date(byAdding: dateComponent, to: today)!
        
        return Self.weekdays[Calendar.current.component(.weekday, from: targetDate) - 1]
    }
}

class ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    #if DEBUG
        @objc class func injected() {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.windows.first?.rootViewController =
                UIHostingController(rootView: ContentView())
        }
    #endif
}
