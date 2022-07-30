//
//  TeacherListViewCell.swift
//  Mafunzo Loop
//
//  Created by Mroot on 30/07/2022.
//

import SwiftUI

struct TeacherListViewCell: View {
    @State var profilePicture: String
    @State var firstName: String
    @State var lastName: String
    @State var subjects: [String]
    @State var grades: [String]
    @State var bio: String
    var body: some View {
        HStack {
            
             AsyncImage(url: URL(string: profilePicture)) { image in
                 image.resizable()
             } placeholder: {
             Image(systemName: "person.circle.fill")
             .resizable()
             } .frame(width: 100, height: 100, alignment: .leading)
            VStack(alignment: .leading) {
                Text("\(firstName) \(lastName)")
                    .foregroundColor(Color.buttonHomeColor)
                Text("English, Kiswahili, Maths")
                    .foregroundColor(.blue)
                Text("Grade: 8, 9, 10")
                    .foregroundColor(.green)
                Text(bio)
                    .foregroundColor(.yellow)
            }
            .frame(width: 200)
        }
        .padding()
        .background(
            RoundedCornersShape(corners: .allCorners, radius: 10)
                .fill(Color.homeCategory)
        )
        .shadow(radius: 2.0)
    }
}
