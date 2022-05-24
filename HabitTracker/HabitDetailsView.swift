//
// Created by Артём Макогон on 9.05.2022.
//

import Foundation
import SwiftUI

struct HabitDetailsView: View {
    static let analyzePointsCount: Int = 14
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habit: DiscreteHabit
    @Binding var showingHabitDetailsView: Bool
    @State var showingChangingView: Bool = false
    @ObservedObject var chartData: ChartData
    @State var analyzeDaysCount: Int

    init(habit: DiscreteHabit, showingHabitDetailsView: Binding<Bool>) {
        self._analyzeDaysCount = State(initialValue: HabitDetailsView.analyzePointsCount)
        self.chartData = try! habit.calculateProgressPerPeriod(
            periodInDaysFromToday: HabitDetailsView.analyzePointsCount,
            pointsCount: HabitDetailsView.analyzePointsCount)
        self.habit = habit
        self._showingHabitDetailsView = showingHabitDetailsView
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 30) {
                    CircleProgressBarView(
                        title: "Week",
                        progress: try! habit.calculatePercentagePerPeriod(lastDays: 7),
                        colorStyleNumber: $habit.colorStyleNumber
                    )
                    CircleProgressBarView(
                        title: "2 weeks",
                        progress: try! habit.calculatePercentagePerPeriod(lastDays: 14),
                        colorStyleNumber: $habit.colorStyleNumber
                    )
                    CircleProgressBarView(
                        title: "Month",
                        progress: try! habit.calculatePercentagePerPeriod(lastDays: 31),
                        colorStyleNumber: $habit.colorStyleNumber
                    )
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
                VStack {
                    Picker("analyze period", selection: $analyzeDaysCount) {
                        Text("2 weeks").tag(14)
                        Text("month").tag(30)
                        Text("year").tag(365)
                    }
                    .pickerStyle(.segmented)
                    .padding(.top)
                    .padding(.bottom)
                    LineChartView(
                        chartData: try! habit.calculateProgressPerPeriod(
                            periodInDaysFromToday: analyzeDaysCount,
                            pointsCount: HabitDetailsView.analyzePointsCount),
                        forceMinValue: 0,
                        forceMaxValue: 100, colorStyleNumber: $habit.colorStyleNumber
                    )
                }
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
                }
            )
            .padding()
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
    @State private var frequencyModeSelected: DiscreteHabitFrequencyMode

    init(habit: DiscreteHabit, showingHabitDetailsView: Binding<Bool>) {
        self.habit = habit
        self._showingHabitDetailsView = showingHabitDetailsView
        self._enteredName = State(initialValue: habit.title)
        self._colorSelected = State(initialValue: habit.colorStyleNumber)
        self._frequencyModeSelected = State(initialValue: habit.frequencyMode)
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

                        Picker("Frequency mode", selection: $frequencyModeSelected) {
                            ForEach(0..<DiscreteHabitFrequencyMode.names.count) { number in
                                Text(DiscreteHabitFrequencyMode.names[number]).tag(
                                    DiscreteHabitFrequencyMode(daysPerWeek: number + 1))
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
                        habit.update(
                            title: enteredName.trimmingCharacters(in: .whitespacesAndNewlines),
                            colorStyleNumber: colorSelected, frequencyMode: frequencyModeSelected)
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
