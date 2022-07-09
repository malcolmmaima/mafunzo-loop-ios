//
//  HomeView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 08/07/2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { geo in
            VStack {
                HomeTopView()
                    .frame(height: geo.size.height * 0.25)
                VStack {
                    ScrollView {
                        CategoryCell(image: "ic_announcement", CategoryTitle: "Announcements", image2: "ic_calendar", CategoryTitle2: "Calendar")
                        CategoryCell(image: "ic_requests", CategoryTitle: "Requests", image2: "ic_teachers", CategoryTitle2: "Teachers")
                        CategoryCell(image: "ic_school_bus", CategoryTitle: "School Bus", image2: "ic_contacts", CategoryTitle2: "Contacts")
                    }
                    .offset(y: -50)
                }.frame(height: 600)
                .padding()
             // MARK: Curving view
                 .background(
                     RoundedCornersShape(corners: .allCorners, radius: 45)
                        .fill(Color.ViewBackground)
                 )
                 .offset(y: -50)
            }
            .background(Color.ViewBackground)
        }
    }
}
// MARK: TOP VIEW
struct HomeTopView: View {
    var body: some View {
        HStack {
            Text("Hi Admin")
                .foregroundColor(.white)
                .font(.title2)
                .bold()
            Spacer()
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 45, height: 45)
        }.padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
        .background(Color.yellow)
    }
}
// MARK: Category Cell
struct CategoryCell: View {
    @State var image: String
    @State var CategoryTitle: String
    @State var image2: String
    @State var CategoryTitle2: String
    var body: some View {
        HStack {
            VStack {
                Image(image)
                    .resizable()
                    .frame(width: 80, height: 80)
                Text(CategoryTitle)
                    .font(.body)
            } .padding()
                .frame(width: 140, height: 140)
            .background(
                RoundedCornersShape(corners: .allCorners, radius: 20)
                    .fill(Color.homeCategory)
            )
            .shadow(radius: 1)
            Spacer()
            VStack {
                Image(image2)
                    .resizable()
                    .frame(width: 80, height: 80)
                Text(CategoryTitle2)
                    .font(.body)
            } .padding()
                .frame(width: 140, height: 140)
            .background(
                RoundedCornersShape(corners: .allCorners, radius: 20)
                    .fill(Color.homeCategory)
            )
            .shadow(radius: 1)
        }
        .padding()
        .padding(.bottom, 20)
            .background(Color.clear)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
            HomeTopView()
            CategoryCell(image: "ic_announcement", CategoryTitle: "Announcements", image2: "ic_calendar", CategoryTitle2: "Calendar")
        }
    }
}
