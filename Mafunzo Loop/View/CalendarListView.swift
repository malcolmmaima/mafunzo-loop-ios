//
//  CalendarView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 22/07/2022.
//

import SwiftUI

struct CalendarListView: View {
    @StateObject var calendarViewModel = CalendarViewModel()
    @State var date = Date()
    var body: some View {
        GeometryReader { geo in
            VStack {
                AnnoucementTopView()
                    .frame(height: geo.size.height * 0.09)
                VStack {
                    DatePicker(
                        "Start Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .onChange(of: date) { newValue in
                        calendarViewModel.getEvents(selectedDate: newValue)
                    }
                    NavigationLink {
                        UpcommingEventsView()
                    } label: {
                        Text("View all upcoming")
                            .foregroundColor(.blue)
                            .font(.body)
                    }
                   List {
                        ForEach(calendarViewModel.calendarEvents, id: \.id) { event in
                                     EventListViewCell(date: event.start, title: event.title, startingTime: event.start, ending: event.end)
                                .listRowSeparator(.hidden)
                        }
                        .listRowBackground(Color.ViewBackground)
                    }
                   .listStyle(.plain)
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(
                    RoundedCornersShape(corners: .allCorners, radius: 40)
                        .fill(Color.ViewBackground)
                )
                .offset(y: -55)
            }
        }
        .navigationBarTitle(Text("Calendar"), displayMode: .inline)
        .onAppear {
            calendarViewModel.getEvents(selectedDate: date)
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarListView()
    }
}
