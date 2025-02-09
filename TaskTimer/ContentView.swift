//
//  ContentView.swift
//  TaskTimer
//
//  Created by Abdelrahman Raafat on 2/9/25.

import SwiftUI
import CoreData
struct ContentView: View {
    @StateObject private var timerViewModel = TimerViewModel()
    
    var body: some View {
        VStack {
            TextField("Enter Task Name", text: $timerViewModel.taskName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text(timerViewModel.formattedTime)
                .font(.largeTitle)
                .padding()
            
            List(timerViewModel.savedRecords) { record in
                VStack(alignment: .leading) {
                    Text("Task: \(record.taskName ?? "No Task Name")") // Ensure taskName is not nil
                    Text("Total Time: \(timerViewModel.formatTime(record.totalTime))")
                           if let startTime = record.startTime {
                               Text("Start: \(startTime, formatter: timerViewModel.dateFormatter)")
                           } else {
                               Text("Start: N/A")
                           }
                           if let endTime = record.endTime {
                               Text("End: \(endTime, formatter: timerViewModel.dateFormatter)")
                           } else {
                               Text("End: N/A")
                           }
                }
            }
            
            HStack {
                Button("Start") {
                    timerViewModel.startTimer()
                }
                .padding()
                
                Button("Pause") {
                    timerViewModel.pauseTimer()
                }
                .padding()
                
                Button("Stop") {
                    timerViewModel.stopTimer()
                }
                .padding()
            }
            
            Button("Clear All Data") {
                           timerViewModel.clearAllRecords()
                       }
                       .padding()
                       .foregroundColor(.red)
        }
        .frame(width: 300, height: 400)
        .padding()
        .onAppear {
            timerViewModel.fetchSavedRecords()
        }
    }
}

