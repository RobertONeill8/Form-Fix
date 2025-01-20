//
//  ExerciseLogsView.swift
//  calistrainer
//
//   on 24/05/22.
//

import SwiftUI

struct ExerciseLogsView: View {

	@StateObject var viewModel = ExerciseLogsViewModel()
	
	var body: some View {
		ZStack {
			Color("PrimaryGray").ignoresSafeArea()
			VStack(spacing: 0) {
				VStack {
					HStack {
						Button {
							viewModel.prevMonthButtonTapped()
							viewModel.updateDatesInMonth()
							viewModel.fetchRecordedSessions()
						} label: {
							Image(systemName: "chevron.left")
								.foregroundColor(.white)
						}.padding(.horizontal)
						Spacer()
						Text(viewModel.selectedMonth)
							.font(.title3)
							.fontWeight(.semibold)
						Spacer()
						Button {
							viewModel.nextMonthButtonTapped()
							viewModel.updateDatesInMonth()
							viewModel.fetchRecordedSessions()
						} label: {
							Image(systemName: "chevron.right")
								.foregroundColor(
									viewModel.isLatestMonthSelected
									? Color("PrimaryGray")
									: .white
								)
						}.padding(.horizontal)
							.disabled(viewModel.isLatestMonthSelected)
					}.padding()
					ScrollView(.horizontal, showsIndicators: false) {
						ScrollViewReader { value in
							HStack {
								ForEach(Array(zip(viewModel.datesInMonth.indices, viewModel.datesInMonth)), id: \.0) { index, date in
									DateButton(
										date: date,
										buttonState: viewModel.dateButtonState(date),
										action: {
											viewModel.selectDate(date)
											viewModel.showSessionsForSelectedDate()
										}
									)
									.disabled(viewModel.disableDateButton(date))
									.id(index)
									.onAppear {
										value.scrollTo(viewModel.selectedDateIndex, anchor: .bottomTrailing)
									}
								}
							}.padding()

						}
					}
					.padding(.bottom)
				}
				.background {
					RoundedRectangle(cornerRadius: 20)
						.foregroundColor(Color("SecondaryGray"))
						.ignoresSafeArea()
				}
				if viewModel.sessionsForSelectedDate.isEmpty {
					Spacer()
					Text(viewModel.emptyListLabel)
						.font(.title3)
						.foregroundColor(.accentColor)
						.multilineTextAlignment(.center)
						.lineSpacing(10)
					Spacer()
				} else {
					ScrollView {
						VStack(spacing: 20) {
							ForEach(viewModel.sessionsForSelectedDate, id:\.self) { practiceSession in
								ExerciseLogItem(logItem: viewModel.getLogItem(from: practiceSession))
							}
						}.padding()
					}
				}
			}
		}
		.onAppear {
			viewModel.fetchRecordedSessions()
			viewModel.showSessionsForSelectedDate()
			viewModel.updateDatesInMonth()
		}
	}
}

struct ExerciseLogsView_Previews: PreviewProvider {
	static var previews: some View {
		ExerciseLogsView()
			.preferredColorScheme(.dark)
	}
}
