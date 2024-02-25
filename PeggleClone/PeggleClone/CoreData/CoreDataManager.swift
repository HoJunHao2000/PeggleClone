//
//  CoreDataManager.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 27/1/24.
//

import CoreData

class CoreDataManager {
    let container: NSPersistentContainer
    let context: NSManagedObjectContext

    static let instance = CoreDataManager()

    init() {
        self.container = NSPersistentContainer(name: "GameData")
        self.container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
        }
        self.context = self.container.viewContext
    }

    func save() {
        do {
            try self.context.save()
        } catch {
            print("Error saving Core Data: \(error.localizedDescription)")
        }
    }

    func reset() {
        let request = NSFetchRequest<GameboardEntity>(entityName: "GameboardEntity")
        do {
            let gameboards = try context.fetch(request)
            for gamemboard in gameboards {
                context.delete(gamemboard)
            }
            save()
        } catch {
            print("Error reseting coredata: \(error)")
        }

    }
}
