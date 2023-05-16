//
// Created by Артём Макогон on 1.05.2022.
//

import Foundation
import SwiftUI

struct CreatingHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habitTracker: HabitTracker
    @State private var name = ""
    @State private var colorSelected: Int = 0
    @State private var frequencyModeSelected = DiscreteHabitFrequencyMode(daysPerWeek: 7)

    var body: some View {
        NavigationView {
            Form {
                Section("GENERAL") {
                    TextField("Habit Name", text: $name)
                    Picker("Color", selection: $colorSelected) {
                        ForEach(0..<ColorStyles.allStyles.count) { number in
                            MiniCircle(color: ColorStyles.allStyles[number].mainColor)
                                .tag(number)
                        }
                    }
                    Picker("Frequency mode", selection: $frequencyModeSelected) {
                        ForEach(0..<DiscreteHabitFrequencyMode.names.count) { number in
                            Text(DiscreteHabitFrequencyMode.names[number]).tag(
                                DiscreteHabitFrequencyMode(daysPerWeek: number + 1))
                        }
                    }
                }
            }
            .navigationBarTitle("Add New Habit")
            .navigationBarItems(
                leading: Button("Back") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .navigationBarItems(
                trailing: Button("Done") {
                    if name != "" {
                        let habit = DiscreteHabit(title: name)
                        habit.habitTracker = habitTracker
                        habit.frequencyMode = frequencyModeSelected
                        habit.colorStyleNumber = colorSelected
                        habitTracker.addNewHabit(habit: habit)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                })
        }
    }
}

class CreatingHabitView_Previews: PreviewProvider {
    static var previews: some View {
        CreatingHabitView(habitTracker: HabitTracker())
    }

    #if DEBUG
        @objc class func injected() {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.windows.first?.rootViewController =
                UIHostingController(
                    rootView: CreatingHabitView(habitTracker: HabitTracker())
                )
        }
    #endif
}
