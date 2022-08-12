//
//  SchoolListViewCell.swift
//  Mafunzo Loop
//
//  Created by Mroot on 06/08/2022.
//

import SwiftUI

struct SchoolListViewCell: View {
    @State var schoolName: String
    @State var schoolLocation: String
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(schoolName)
                    .bold()
                Text(schoolLocation)
                    .foregroundColor(.blue)
            }
           .padding()
            Spacer()
        }
        .frame(width: 350)
        .background(
            RoundedCornersShape(corners: .allCorners, radius: 10)
                .fill(Color.homeCategory)
        )
        .shadow(radius: 2.0)
    }
}

struct SchoolListViewCell_Previews: PreviewProvider {
    static var previews: some View {
        SchoolListViewCell(schoolName: "Aga Khan Academy", schoolLocation: "Kisumu")
    }
}
