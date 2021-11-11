//
//  ContentView.swift
//  uitest
//
//  Created by Артём Макогон on 11.11.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var counter = Counter(checkbox_count: 4)
    @State var progress = 0.0
    
    var body: some View {
        VStack{
            Spacer ()
            
            HStack{
                ProgressView(value: progress)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 10)
                    .accessibilityIdentifier("Artem_progress")
            }
            
            
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.15)
                HStack{
                    Spacer ()
                    Button(action: {
                        counter.ChangeElementState(position: 0)
                        progress = counter.GetTotalProgress()
                    }) {
                        Image(systemName: counter.IsActive(position: 0) == true ? "stop.fill" : "stop").scaledToFill()
                    }
                    .frame(width: 20.0, height: 40.0)
                    Spacer ()
                    Button(action: {
                        counter.ChangeElementState(position: 1)
                        progress = counter.GetTotalProgress()
                    }) {
                        Image(systemName: counter.IsActive(position: 1) == true ? "stop.fill" : "stop").scaledToFill()
                    }
                    .frame(width: 20.0, height: 40.0)
                    Spacer()
                    Button(action: {
                        counter.ChangeElementState(position: 2)
                        progress = counter.GetTotalProgress()
                    }) {
                        Image(systemName: counter.IsActive(position: 2) == true ? "stop.fill" : "stop").scaledToFill()
                    }
                    .frame(width: 20.0, height: 40.0)
                    Spacer()
                    Button(action: {
                        counter.ChangeElementState(position: 3)
                        progress = counter.GetTotalProgress()
                        
                    }) {
                        Image(systemName: counter.IsActive(position: 3) == true ? "stop.fill" : "stop").scaledToFill()
                    }
                    .frame(width: 20.0, height: 40.0)
                    Spacer()
                }
            }
            
            Spacer ()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
