//
//  UpcommingEventsView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 26/07/2022.
//

import SwiftUI

struct UpcommingEventsView: View {
    @StateObject var calendarViewModel = CalendarViewModel()
    var body: some View {
        GeometryReader { geo in
            VStack {
                AnnoucementTopView()
                    .frame(height: geo.size.height * 0.09)
                VStack {
                    List {
                         ForEach(calendarViewModel.calendarEvents, id: \.id) { event in
                             NavigationLink(destination: EventView(event: event)){
                                 EventListViewCell(date: event.start, title: event.title, startingTime: event.start, ending: event.end)
                             }
                                 .listRowSeparator(.hidden)
                         }
                         .listRowBackground(Color.ViewBackground)
                     }
                    .listStyle(.plain)
                    .padding(.top, 25)
                    .refreshable {
                        calendarViewModel.showUpcommingEvents()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedCornersShape(corners: .allCorners, radius: 40)
                        .fill(Color.ViewBackground)
                )
                .offset(y: -55)
            }
        }
        .onAppear {
            calendarViewModel.showUpcommingEvents()
        }
        .navigationBarTitle(Text("Upcomming Events"), displayMode: .inline)
    }
}

struct UpcommingEventsView_Previews: PreviewProvider {
    static var previews: some View {
        UpcommingEventsView()
    }
}
