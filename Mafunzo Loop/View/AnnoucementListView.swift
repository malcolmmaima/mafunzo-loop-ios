//
//  AnnoucementView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 18/07/2022.
//

import SwiftUI

struct AnnoucementListView: View {
    init() {
        UITableView.appearance().backgroundColor = UIColor(named: "ViewColor")
    }
    @StateObject var annoucementViewModel = AnnoucementViewModel()
   // @EnvironmentObject var annoucementViewModel: AnnoucementViewModel
    var body: some View {
        GeometryReader { geo in
            VStack {
                AnnoucementTopView()
                    .frame(height: geo.size.height * 0.09)
                VStack {
                    List {
                        ForEach(annoucementViewModel.announcements , id: \.announcementTitle) { annoucements in
                            NavigationLink(destination: AnnouncementView(announcement: annoucements)) {
                                AnnouncementViewCell(image: annoucements.announcementImage, Title: annoucements.announcementTitle, date: annoucements.announcementTime, announcementBody: annoucements.announcementBody)
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                            }
                        }
                        .listRowBackground(Color.ViewBackground)
                    }
                    .listStyle(SidebarListStyle())
                    .padding(.top, 25)
                    .refreshable {
                        annoucementViewModel.fetchAnnoucements()
                    }
                }
                //.padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(
                    RoundedCornersShape(corners: .allCorners, radius: 40)
                        .fill(Color.ViewBackground)
                )
                .offset(y: -55)
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
