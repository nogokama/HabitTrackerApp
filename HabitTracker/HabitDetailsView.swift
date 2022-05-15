//
// Created by Артём Макогон on 9.05.2022.
//

import Foundation
import SwiftUI

struct HabitDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habit: DiscreteHabit
    @Binding var showingHabitDetailsView: Bool
    @State var showingChangingView: Bool = false

    let analyzeDaysCount: Int = 13

    var yDataValues: [Double] {
        habit.calculateProgressForNLastDays(days: self.analyzeDaysCount)
    }
    var xDataPoints: [String] {
        return HabitDate.getNLastDays(days: self.analyzeDaysCount)
    }

    var body: some View {
        NavigationView {
            VStack {
                LineChartView(
                    dataPoints: yDataValues, xDataPoints: xDataPoints, forceMinValue: 0,
                    forceMaxValue: 100, colorStyleNumber: $habit.colorStyleNumber
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
            HabitChangingView(
                habit: habit,
                showingHabitDetailsView: $showingHabitDetailsView)
        }
    }
}

struct MiniCircle: View {
    let color: Color
    var body: some View {
        Circle()
            .foregroundColor(color)
            .frame(width: 30, height: 30)
    }
}

struct HabitChangingView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habit: DiscreteHabit
    @Binding var showingHabitDetailsView: Bool

    @State var enteredName: String = ""
    @State private var colorSelected: Int = 0

    init(habit: DiscreteHabit, showingHabitDetailsView: Binding<Bool>) {
        self.habit = habit
        self._showingHabitDetailsView = showingHabitDetailsView
        self._enteredName = State(initialValue: habit.title)
        self._colorSelected = State(initialValue: habit.colorStyleNumber)
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("GENERAL") {
                        VStack {
                            HStack {
                                Text("Name:")
                                TextField("Habit Name", text: $enteredName)
                            }
                            if enteredName.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                                Text("Name cannot be empty")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }

                        Picker("Color", selection: $colorSelected) {
                            ForEach(0..<ColorStyles.allStyles.count) { number in
                                MiniCircle(color: ColorStyles.allStyles[number].mainColor)
                                    .tag(number)
                            }
                        }

                    }
                    Section("Other") {
                        Button(
                            action: {
                                habit.archive()
                                self.showingHabitDetailsView = false
                                self.presentationMode.wrappedValue.dismiss()
                            },
                            label: {
                                Text("Archive Habit")
                                    .foregroundColor(.red)
                            })
                    }

                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(
                leading: Button("Back") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .navigationBarItems(
                trailing: Button("Save") {
                    if enteredName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                        habit.title = enteredName.trimmingCharacters(in: .whitespacesAndNewlines)
                        habit.colorStyleNumber = colorSelected
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
        }
    }
}

class HabitDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailsView(habit: DiscreteHabit(), showingHabitDetailsView: .constant(false))
    }

    #if DEBUG
        @objc class func injected() {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.windows.first?.rootViewController =
                UIHostingController(
                    rootView: HabitDetailsView(
                        habit: DiscreteHabit(), showingHabitDetailsView: .constant((false)))
                )
        }
    #endif
}
