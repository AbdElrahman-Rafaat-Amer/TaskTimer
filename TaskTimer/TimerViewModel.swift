//
//  TimerViewModel.swift
//  TaskTimerApp
//
//  Created by Abdelrahman Raafat on 2/9/25.
//

import Foundation
import CoreData


class TimerViewModel: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    @Published var savedRecords: [TimerRecordModel] = []
    @Published var taskName: String = ""
    private var timer: Timer?
    private var startTime: Date?
    private var context = PersistenceController.shared.container.viewContext
    private var isPaused = false
    
    var formattedTime: String {
        return formatTime(elapsedTime)
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_GB") // Ensures 24-hour format
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Explicit 24-hour fo
        return formatter
    }
    
    func formatTime(_ timeInterval: TimeInterval) -> String {
          let hours = Int(timeInterval) / 3600
          let minutes = (Int(timeInterval) % 3600) / 60
          let seconds = Int(timeInterval) % 60
          return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
      }
    
    init() {
        fetchSavedRecords()
    }
    
    func startTimer() {
        if(startTime == nil){
            startTime = Date()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.elapsedTime += 1
            }
        }else{
            if (isPaused){
                isPaused = false
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    self.elapsedTime += 1
                }
            }
        }
    }
    
    func pauseTimer() {
        isPaused = true
        timer?.invalidate()
    }
    
    func stopTimer() {
        timer?.invalidate()
        if let start = startTime {
            let endTime = Date()
            let totalTime = elapsedTime
            saveToDatabase(start: start, end: endTime, total: totalTime)
        }
        startTime = nil
        timer = nil
        isPaused = false
        elapsedTime = 0
    }
    
    private func saveToDatabase(start: Date, end: Date, total: TimeInterval) {
        let newRecord = TimerRecordModel(context: context)
        newRecord.day = Date()
        newRecord.startTime = start
        newRecord.endTime = end
        newRecord.totalTime = total
        newRecord.taskName = taskName
        newRecord.id = UUID()
        
        do {
            try context.save()
            fetchSavedRecords()
        } catch {
            print("Failed to save: \(error.localizedDescription)")
        }
    }
    
    func fetchSavedRecords() {
        let request: NSFetchRequest<TimerRecordModel> = TimerRecordModel.fetchRequest()
        do {
            savedRecords = try context.fetch(request)
            print(savedRecords)
        } catch {
            print("Failed to fetch records: \(error.localizedDescription)")
        }
    }
    
    func clearAllRecords() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TimerRecordModel.fetchRequest()
           let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
           
           do {
               try context.execute(deleteRequest)
               try context.save()
               savedRecords.removeAll()
           } catch {
               print("Failed to delete records: \(error.localizedDescription)")
           }
       }
}
