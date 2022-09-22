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
                    // MARK: -Top View
                    NavigationTopView()
                        .frame(height: geo.size.height * 0.1)
                    bottomView
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

private extension AnnouncementView {
    
    // MARK: -Bottom View
    var bottomView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                title
                time
                image
                bodyAnnouncement
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
    
    // MARK: title
    var title: some View {
        Text(announcement.announcementTitle)
            .font(.title2)
            .padding()
    }
    
    // MARK: time
    @ViewBuilder
    var time: some View {
        Text(dateFormattered())
            .foregroundColor(.blue)
        Divider()
    }
    
    // MARK: image
    var image: some View {
        AsyncImage(url: URL(string: announcement.announcementImage)) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        } .frame(maxWidth: .infinity, maxHeight: 350)
    }
    
    // MARK: body
    var bodyAnnouncement: some View {
        Text(announcement.announcementBody)
            .font(.body)
            .fixedSize(horizontal: false, vertical: true)
    }
}
