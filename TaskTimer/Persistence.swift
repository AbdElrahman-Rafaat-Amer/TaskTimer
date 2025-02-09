//
//  Persistence.swift
//  TaskTimer
//
//  Created by Abdelrahman Raafat on 2/9/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
        let container: NSPersistentContainer
        
        init() {
            container = NSPersistentContainer(name: "TaskTimer")
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Unresolved error: \(error)")
                }
            }
        }
}
