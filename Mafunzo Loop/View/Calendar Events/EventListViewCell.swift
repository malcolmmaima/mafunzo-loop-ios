//
//  EventListViewCell.swift
//  Mafunzo Loop
//
//  Created by Mroot on 22/07/2022.
//
import SwiftUI

struct EventListViewCell: View {
    @State var date: Int
    @State var title: String
    @State var startingTime: Int
    @State var ending: Int
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(getDate())
                    .foregroundColor(.blue)
            }
            .frame(width: 52.0, height: 45)
            .padding()
            .background(
                RoundedCornersShape(corners: [.topLeft, .bottomLeft], radius: 10)
                    .fill(Color.yellow)
            )
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title3)
                        .lineLimit(1)
                    Text("\(eventTime(time:startingTime)) - \(eventTime(time: ending))")
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding()
            .frame(width: .none)
        }
        .background(
            RoundedCornersShape(corners: .allCorners, radius: 10)
                .fill(Color.homeCategory)
        )
        .shadow(radius: 2.0)
    }
    // MARK: DATE CONVERSION
    //to Day & Month (25th July)
    func getDate() -> String {
        let day = Date(timeIntervalSince1970: (Double(startingTime) / 1000.0))
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

struct EventListViewCell_Previews: PreviewProvider {
    static var previews: some View {
        EventListViewCell(date: 1660719600000, title: "School Trip", startingTime: 1660719600000, ending: 1660730400000)
    }
}
