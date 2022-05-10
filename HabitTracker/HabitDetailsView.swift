//
// Created by Артём Макогон on 9.05.2022.
//

import Foundation
import SwiftUI

struct HabitDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habit: DiscreteHabit
    @State var showingChangingView: Bool = false

    let analyzeDaysCount: Int = 13

    var yDataValues: [Double] {
        habit.calculateProgressForNLastDays(days: self.analyzeDaysCount)
    }
    var xDataPoints: [String] {
        return HabitDate.getNLastDays(days: self.analyzeDaysCount)
    }

    init(habit: DiscreteHabit) {
        self.habit = habit
    }

    var body: some View {
        NavigationView {
            VStack {
                LineChartView(
                    dataPoints: yDataValues, xDataPoints: xDataPoints, forceMinValue: 0,
                    forceMaxValue: 100
                )
                .padding()
            }
            .navigationBarTitle(habit.title)
            .navigationBarItems(
                leading: Button("Back") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .navigationBarItems(
                trailing: Button("Change") {
                    showingChangingView = true
                })
        }
        .sheet(isPresented: $showingChangingView) {
            HabitChangingView(habit: habit)
        }
    }
}

struct HabitChangingView: View {
    @ObservedObject var habit: DiscreteHabit
    @State var enteredName: String

    init(habit: DiscreteHabit) {
        self.habit = habit
        self.enteredName = habit.title
    }

    var body: some View {
        NavigationView {
            Form {
                Section("General") {
                    HStack {
                        Text("Name:")
                        TextField("Habit Name", text: $enteredName)
                    }
                }
                Section("Other") {
                    Button(
                        action: {
                        },
                        label: {
                            Text("Archive Habit")
                                .foregroundColor(.red)
                        })
                }
            }
        }
    }
}

class HabitDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailsView(habit: DiscreteHabit())
    }

    #if DEBUG
        @objc class func injected() {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.windows.first?.rootViewController =
                UIHostingController(
                    rootView: HabitDetailsView(habit: DiscreteHabit())
                )
        }
    #endif
}
