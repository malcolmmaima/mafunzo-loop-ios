//
//  SubjectListViewCell.swift
//  Mafunzo Loop
//
//  Created by Mroot on 03/08/2022.
//

import SwiftUI

struct SubjectListViewCell: View {
    @State var subjectName: String
    @State var startTime: Int
    @State var endTime: Int
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(subjectName)
                    .bold()
                Text("\(requestDateCreated(time: startTime)) - \(requestDateCreated(time: endTime))")
                    .foregroundColor(.blue)
                    //.textFieldStyling()
                Divider()
                    .frame(height: 1)
                    .overlay(.gray)
            } .frame(width: 300)
           .padding()
        }
        .background(
            RoundedCornersShape(corners: .allCorners, radius: 10)
                .fill(Color.homeCategory)
        )
        .shadow(radius: 2.0)
    }
    // MARK: Time to Hour & Min (10:00 AM/PM)
    func requestDateCreated(time: Int) -> String {
        let stating = Date(timeIntervalSince1970: (Double(time) / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: stating)
    }
}

struct SubjectListViewCell_Previews: PreviewProvider {
    static var previews: some View {
        SubjectListViewCell(subjectName: "Maths", startTime: 1658774866603, endTime: 1658784888401)
    }
}
