//
// Created by Артём Макогон on 1.05.2022.
//

import Foundation
import SwiftUI

struct CreatingHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habitTracker: HabitTracker
    @State private var name = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Habit Name", text: $name)
            }
            .navigationBarTitle("Add")
            .navigationBarItems(
                trailing: Button("Done") {
                    if name != "" {
                        let habit = DiscreteHabit(title: name)
                        habitTracker.addNewHabit(habit: habit)
                        habit.habitTracker = habitTracker
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
