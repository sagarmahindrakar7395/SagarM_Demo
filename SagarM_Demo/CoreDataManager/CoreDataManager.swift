//
//  CoreDataManager.swift
//  SagarM_Demo
//
//  Created by APPLE on 12/19/25.
//

import CoreData
import Foundation

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        
        persistentContainer = NSPersistentContainer(name: "SagarM_Demo")
        
        let storeURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("SagarM_Demo.sqlite")
        
        let storeDire = storeURL.deletingLastPathComponent()
        
        do {
            
            if FileManager.default.fileExists(atPath: storeDire.path) {
                try FileManager.default.createDirectory(at: storeDire, withIntermediateDirectories: true)
            }
            
            if let desc = persistentContainer.persistentStoreDescriptions.first {
                desc.url = storeURL
            }
            
            persistentContainer.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Error")
                }
            }
            
        } catch {
            fatalError("Failed to creat directory and from URL")
        }
    }
    
    
    func savePortfolioHolding(_ holdings: [UserHoldingElement], completion: ((Error?) -> Void)? = nil) {
        let context = persistentContainer.newBackgroundContext()
        
        context.perform {
            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "HoldingEntity")
            let deleteReq = NSBatchDeleteRequest(fetchRequest: fetchReq)
            
            do {
                try context.execute(deleteReq)
                
            } catch {
                print("Error to delete")
            }
            
            for holding in holdings {
                let entity = HoldingEntity(context: <#T##NSManagedObjectContext#>)
            }
            
        }
    }
    
    
}



