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
                    .navigationBarItems(trailing: Button("Done") {
                        let habit = Habit(id: -1, title: name)
                        habitTracker.addNewHabit(habit: habit)
                        self.presentationMode.wrappedValue.dismiss()
                    })
        }
    }
}

struct CreatingHabitView_Previews: PreviewProvider {
    static var previews: some View {
        CreatingHabitView(habitTracker: HabitTracker())
    }
}

