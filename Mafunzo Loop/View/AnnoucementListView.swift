//
//  AnnoucementView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 18/07/2022.
//
import SwiftUI

struct AnnoucementListView: View {
    @StateObject var annoucementViewModel = AnnoucementViewModel()
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    AnnoucementTopView()
                        .frame(height: geo.size.height * 0.09)
                    VStack {
                        List {
                            ForEach(annoucementViewModel.announcements , id: \.announcementTitle) { annoucements in
                                NavigationLink(destination: AnnouncementView(announcement: annoucements)) {
                                    AnnouncementListViewCell(image: annoucements.announcementImage, Title: annoucements.announcementTitle, date: annoucements.announcementTime, announcementBody: annoucements.announcementBody)
                                }
                                .listRowSeparator(.hidden)
                            }
                            .listRowBackground(Color.ViewBackground)
                        }
                        .listStyle(.plain)
                        .padding(.top, 25)
                        .refreshable {
                            annoucementViewModel.fetchAnnoucements()
                        }
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(
                        RoundedCornersShape(corners: .allCorners, radius: 40)
                            .fill(Color.ViewBackground)
                    )
                    .offset(y: -55)
                }
                .overlay {
                    ProgressView()
                        .opacity(annoucementViewModel.isLoading ? 1 : 0)
                        .font(.system(size: 2))
                        .padding()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.yellow))
                }
                Text("No Announcement")
                    .opacity(annoucementViewModel.noAnnouncement ? 1 : 0)
            }
        }
        .navigationBarTitle(Text("Announcements"), displayMode: .inline)
    }
}

// MARK: TOP VIEW
struct AnnoucementTopView: View {
    var body: some View {
        VStack {
            Text("")
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
    }
}

struct AnnoucementView_Previews: PreviewProvider {
    static var previews: some View {
        AnnoucementListView()
    }
}
