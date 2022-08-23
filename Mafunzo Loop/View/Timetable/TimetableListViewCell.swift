//
//  SubjectListViewCell.swift
//  Mafunzo Loop
//
//  Created by Mroot on 03/08/2022.
//

import SwiftUI

struct TimetableListViewCell: View {
    private let dateConverter = DateConverter()
    @State var subjectName: String
    @State var startTime: Int
    @State var endTime: Int
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(subjectName)
                    .bold()
                Text("\(dateConverter.TimeSpan(time: startTime)) - \(dateConverter.TimeSpan(time: endTime))")
                    .foregroundColor(.blue)
                Divider()
                    .frame(height: 1)
                    .overlay(.gray)
            } .frame(width: .none)
           .padding()
        }
        .background(
            RoundedCornersShape(corners: .allCorners, radius: 10)
                .fill(Color.homeCategory)
        )
        .shadow(radius: 2.0)
    }
}

struct SubjectListViewCell_Previews: PreviewProvider {
    static var previews: some View {
        TimetableListViewCell(subjectName: "Maths", startTime: 1658774866603, endTime: 1658784888401)
    }
}
