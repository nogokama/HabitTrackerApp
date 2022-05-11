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
            HabitChangingView(habit: habit, showingHabitDetailsView: $showingHabitDetailsView)
        }
    }
}

struct HabitChangingView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habit: DiscreteHabit
    @Binding var showingHabitDetailsView: Bool

    @State var enteredName: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("General") {
                        VStack {
                            HStack {
                                Text("Name:")
                                TextField("Habit Name", text: $enteredName)
                                    .onAppear {
                                        self.enteredName = habit.title
                                    }
                            }
                            if enteredName == "" {
                                Text("Name cannot be empty")
                                    .foregroundColor(.red)
                                    .font(.caption)
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
                    if enteredName != "" {
                        habit.title = enteredName
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
