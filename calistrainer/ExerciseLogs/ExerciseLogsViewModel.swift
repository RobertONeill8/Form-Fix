//
//  ExerciseLogsViewModel.swift
//  calistrainer
//
//   on 24/05/22.
//

import Foundation
import CoreData

final class ExerciseLogsViewModel: ObservableObject {

	@Published var allPracticeSessions: [NSManagedObject] = []
	@Published var selectedDate: Date = Date()
	@Published var sessionsForSelectedDate: [NSManagedObject] = []
	@Published var datesInMonth: [Date] = []

	private let calendar = Calendar.current
	private let dateFormatter = DateFormatter()

	let persistenceManager = PersistenceManager.shared

	func fetchRecordedSessions() {
		let managedContext = persistenceManager.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PracticeSession")
		do {
			allPracticeSessions = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}

	func showSessionsForSelectedDate() {
		sessionsForSelectedDate = allPracticeSessions.filter({calendar.isDate($0.value(forKey: "date") as! Date, inSameDayAs: selectedDate)})
	}

	func nextMonthButtonTapped() {
		selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate)!
	}

	func prevMonthButtonTapped() {
		selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate)!
	}

	var selectedMonth: String {
		dateFormatter.dateFormat = "MMMM"
		return dateFormatter.string(from: selectedDate)
	}

	func updateDatesInMonth() {
		guard let dayRange = calendar.range(of: .day, in: .month, for: selectedDate) else { return }
		var components = calendar.dateComponents([.day, .month, .year, .era], from: selectedDate)

		datesInMonth = dayRange.compactMap { day -> Date? in
			components.day = day
			return calendar.date(from: components)
		}
	}

	func dateButtonState(_ buttonDate: Date) -> DateButton.ButtonState {
		if calendar.isDate(buttonDate, inSameDayAs: selectedDate) {
			return .active
		} else if buttonDate > Date() {
			return .disabled
		} else {
			return .enabled
		}
	}

	func disableDateButton(_ buttonDate: Date) -> Bool {
		return buttonDate > Date()
	}

	var isLatestMonthSelected: Bool {
		return calendar.isDate(Date(), equalTo: selectedDate, toGranularity: .month)
	}

	func getLogItem(from practiceSession: NSManagedObject) -> LogItem {
		return LogItem(
			exercise: practiceSession.value(forKey: "exercise") as! String,
			repetitionCount: practiceSession.value(forKey: "repetitionCount") as! Int,
			date: practiceSession.value(forKey: "date") as! Date,
			durationInSecond: practiceSession.value(forKey: "durationInSecond") as! Int
		)
	}

	func selectDate(_ newSelectedDate: Date) {
		selectedDate = newSelectedDate
	}

	var selectedDateIndex: Int {
		dateFormatter.dateFormat = "d"
		return Int(dateFormatter.string(from: selectedDate))!
	}

	var emptyListLabel: String {
		if calendar.isDateInToday(selectedDate) {
			return "You haven't practiced today\nLet's start!"
		} else {
			return "No log recorded"
		}
	}

}
