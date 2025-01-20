//
//  PersistenceManager.swift
//  calistrainer
//
//   on 24/05/22.
//

import Foundation
import CoreData

final class PersistenceManager {

	static let shared = PersistenceManager()

	let persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "PracticeSessionModel")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

}
