//
//  AnnouncementItemView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 19/07/2022.
//

import SwiftUI

struct AnnouncementView: View {
    var announcement: Annoucements
    var body: some View {
            GeometryReader { geo in
                VStack(spacing: 5) {
                    AnnoucementTopView()
                        .frame(height: geo.size.height * 0.1)
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text(announcement.announcementTitle)
                                .font(.title2)
                                .padding()
                            Text(dateFormattered())
                                .foregroundColor(.blue)
                            Divider()
                            AsyncImage(url: URL(string: announcement.announcementImage)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            } .frame(maxWidth: .infinity, maxHeight: 350)
                            Text(announcement.announcementBody)
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
    func dateFormattered() -> String {
        let timeStamp = Date(timeIntervalSince1970: TimeInterval(announcement.announcementTime))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, h:mm a"
        return dateFormatter.string(from: timeStamp)
    }
}

//struct AnnouncementItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnnouncementItemView()
//    }
//}
