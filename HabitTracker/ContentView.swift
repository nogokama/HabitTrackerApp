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
        ZStack {
            VStack {
                HStack {
                    Text("Habit Tracker")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    Spacer()
                }.padding()

                ScrollView {
                    ForEach(habitTracker.habits) { habit in
                        DiscreteHabitView(habit: habit)
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack(alignment: .top) {
                    Spacer()
                    Button(
                        action: {
                            self.showingAddingHabitWindow = true
                        },
                        label: {
                            Text("+")
                                .fontWeight(.bold)
                                .font(.largeTitle)
                                .padding()
                                .frame(
                                    width: UIScreen.main.bounds.width * 0.2,
                                    height: UIScreen.main.bounds.width * 0.2)
                                    .background(
                                        LinearGradient(
                                            gradient:
                                                Gradient(colors: [Color.red, Color.blue]),
                                            startPoint: .top,
                                            endPoint: .bottom)
                                        )
                                            .clipShape(Circle()
                                    )
                                        .foregroundColor(.white)
                                        .padding(10)
                        }
                    )
                        .sheet(isPresented: $showingAddingHabitWindow) {
                            CreatingHabitView(habitTracker: self.habitTracker)
                        }
                }.padding()
            }
        }
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
