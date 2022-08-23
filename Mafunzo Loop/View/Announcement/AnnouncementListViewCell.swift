//
//  AnnouncementViewCell.swift
//  Mafunzo Loop
//
//  Created by Mroot on 19/07/2022.
//
import SwiftUI

struct AnnouncementListViewCell: View {
    @State var image: String
    @State var Title: String
    @State var date: Int
    @State var announcementBody: String
    private let dateConverter = DateConverter()
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Spacer()
                AsyncImage(url: URL(string: image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                } .frame(width: 150, height: 150)
                Spacer()
            }
            Text(Title)
                .font(.title3)
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.blue)
                Text(dateConverter.Date_Time(date: date))
                    .foregroundColor(.blue)
            }
            Text(announcementBody)
                .font(.body)
                .foregroundColor(.gray)
                .lineLimit(3)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedCornersShape(corners: .allCorners, radius: 20)
                .fill(Color.homeCategory)
        )
        .shadow(radius: 2)
    }
}

struct AnnouncementViewCell_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementListViewCell(image: "black_student_happy", Title: "Party", date: 1234244, announcementBody: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris neque quam, ornare fermentum velit sit amet, euismod malesuada quam. Morbi faucibus velit vitae lacus imperdiet, ac ultricies massa mollis. Fusce sed metus cursus, feugiat nibh vel, vulputate urna. Nullam id lorem in lectus malesuada efficitur. Nullam sit amet ligula velit. Pellentesque tristique leo interdum mi dapibus, nec rhoncus nulla pretium. Aliquam erat volutpat. Integer ut massa leo.")
    }
}
