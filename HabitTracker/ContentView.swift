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
                            ZStack {
                                Rectangle()
                                    .fill(.white)
                                    .frame(width: 40, height: 40)
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .foregroundStyle(LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)), location: 0),
                                            .init(color: Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), location: 1)
                                        ]),
                                        startPoint: .bottomTrailing,
                                        endPoint: .topLeading
                                    ))
                            }
                        }
                    )
                    .padding()
                    .sheet(isPresented: $showingAddingHabitWindow) {
                        CreatingHabitView(habitTracker: self.habitTracker)
                    }
                }
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
