//
//  EventView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 28/07/2022.
//
import SwiftUI

struct EventView: View {
    var event: CalendarEvents
    var img = ""
    var body: some View {
        GeometryReader { geo in
            VStack {
                NavigationTopView()
                    .frame(height: geo.size.height * 0.1)
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .font(.title2)
                            .padding()
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                            Text("\(getDate()) from \(eventTime(time: event.start)) - \(eventTime(time: event.end))")
                                .foregroundColor(.blue)
                        }
                        Divider()
                        AsyncImage(url: URL(string: img)) { image in
                            image.resizable()
                        } placeholder: {
                           // Empty Image
                        } .frame(maxWidth: .infinity, maxHeight: 350)
                        Text(event.description)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                .background(
                    RoundedCornersShape(corners: .allCorners, radius: 40)
                        .fill(Color.ViewBackground)
                )
                .offset(y: -55)
            }
        }
    }
    // MARK: DATE CONVERSION
    //to Day & Month (25th July)
    func getDate() -> String {
        let day = Date(timeIntervalSince1970: (Double(event.start) / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        return dateFormatter.string(from: day)
    }
    //to Hour & Min (10:00 AM/PM)
    func eventTime(time: Int) -> String {
        let stating = Date(timeIntervalSince1970: (Double(time) / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: stating)
    }
}


//struct EventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventView(title: "Event Title", eventStartTime: 1658236474580, eventEndTime: 1658236502129, eventDate: 1658236474580, eventBody: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.")
//    }
//}
