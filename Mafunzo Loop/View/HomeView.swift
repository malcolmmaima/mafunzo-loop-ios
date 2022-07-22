//
//  HomeView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 08/07/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    HomeTopView()
                        .frame(height: geo.size.height * 0.25)
                    VStack {
                        ScrollView {
                            HomeCell()
    //                        CategoryCell(image: "ic_announcement", CategoryTitle: "Announcements", image2: "ic_calendar", CategoryTitle2: "Calendar")
    //                        CategoryCell(image: "ic_requests", CategoryTitle: "Requests", image2: "ic_teachers", CategoryTitle2: "Teachers")
    //                        CategoryCell(image: "ic_school_bus", CategoryTitle: "School Bus", image2: "ic_contacts", CategoryTitle2: "Contacts")
                        }
                        .frame(height: geo.size.height * 0.7)
                       .offset(y: -50)
                        Button {
                            print("")
                        } label: {
                            Text(userViewModel.schoolD.schoolName)
                                .font(.body)
                                .foregroundColor(.black)
                                .frame(width: 350, height: 35)
                        }
                        .background(
                            RoundedCornersShape(corners: .allCorners, radius: 20)
                                .fill(Color.homeCategory)
                        )
                        .shadow(radius: 1)
                    }
                    .padding()
                 // MARK: Curving view
                     .background(
                         RoundedCornersShape(corners: .allCorners, radius: 45)
                            .fill(Color.ViewBackground)
                     )
                     .offset(y: -50)
                }
                .background(Color.ViewBackground)
                .navigationBarHidden(true)
            }
            .navigationBarHidden(true)
        }
    }
}
// MARK: TOP VIEW
struct HomeTopView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        HStack {
            Text("Hi, \(userViewModel.user.firstName)")
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
                Button {
                    print("Clicked")
                } label: {
                    VStack {
                        Image(image)
                            .resizable()
                            .frame(width: 80, height: 80)
                        Text(CategoryTitle)
                            .font(.body)
                    }
                }
            } .padding()
                .frame(width: 160, height: 160)
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
                .frame(width: 160, height: 160)
            .background(
                RoundedCornersShape(corners: .allCorners, radius: 20)
                    .fill(Color.homeCategory)
            )
            .shadow(radius: 1)
        }
        .padding(.horizontal, 10)
       .padding(.bottom, 8)
            .background(Color.clear)
    }
}

struct HomeCell: View {
    @State var toAccouncement = false
    var body: some View {
       // NavigationView {
            VStack {
                HStack {
                    // MARK: Announcements
                    NavigationLink {
                        AnnoucementView()
                    } label: {
                        VStack {
                            Image("ic_announcement")
                                .resizable()
                                .frame(width: 80, height: 80)
                            Text("Announcements")
                                .font(.body)
                        }
                    }
                    .foregroundColor(Color.buttonHomeColor)
                    .padding()
                    .frame(width: 160, height: 160)
                    .background(
                    RoundedCornersShape(corners: .allCorners, radius: 20)
                        .fill(Color.homeCategory)
                    )
                    .shadow(radius: 1)
                    Spacer()
                    // MARK: Calendar
                    Button {
                        print("")
                    } label: {
                        VStack {
                            Image("ic_calendar")
                                .resizable()
                                .frame(width: 80, height: 80)
                            Text("Calendar")
                                .font(.body)
                        }
                    }
                    .foregroundColor(Color.buttonHomeColor)
                    .padding()
                    .frame(width: 160, height: 160)
                    .background(
                    RoundedCornersShape(corners: .allCorners, radius: 20)
                        .fill(Color.homeCategory)
                    )
                    .shadow(radius: 1)
                }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 8)
                    .background(Color.clear)
                HStack {
                    // MARK: Requests
                    Button {
                        print("")
                    } label: {
                        VStack {
                            Image("ic_requests")
                                .resizable()
                                .frame(width: 80, height: 80)
                            Text("Requests")
                                .font(.body)
                        }
                    }
                    .foregroundColor(Color.buttonHomeColor)
                    .padding()
                    .frame(width: 160, height: 160)
                    .background(
                    RoundedCornersShape(corners: .allCorners, radius: 20)
                        .fill(Color.homeCategory)
                    )
                    .shadow(radius: 1)
                    Spacer()
                    // MARK: Teachers
                    Button {
                        print("")
                    } label: {
                        VStack {
                            Image("ic_teachers")
                                .resizable()
                                .frame(width: 80, height: 80)
                            Text("Teachers")
                                .font(.body)
                        }
                    }
                    .foregroundColor(Color.buttonHomeColor)
                    .padding()
                    .frame(width: 160, height: 160)
                    .background(
                    RoundedCornersShape(corners: .allCorners, radius: 20)
                        .fill(Color.homeCategory)
                    )
                    .shadow(radius: 1)
                }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 8)
                    .background(Color.clear)
                HStack {
                    // MARK: Bus
                    Button {
                        print("")
                    } label: {
                        VStack {
                            Image("ic_school_bus")
                                .resizable()
                                .frame(width: 80, height: 80)
                            Text("Bus")
                                .font(.body)
                        }
                    }
                    .foregroundColor(Color.buttonHomeColor)
                    .padding()
                    .frame(width: 160, height: 160)
                    .background(
                    RoundedCornersShape(corners: .allCorners, radius: 20)
                        .fill(Color.homeCategory)
                    )
                    .shadow(radius: 1)
                    Spacer()
                    // MARK: Contacts
                    Button {
                        print("")
                    } label: {
                        VStack {
                            Image("ic_contacts")
                                .resizable()
                                .frame(width: 80, height: 80)
                            Text("Contacts")
                                .font(.body)
                        }
                    }
                    .foregroundColor(Color.buttonHomeColor)
                    .padding()
                    .frame(width: 160, height: 160)
                    .background(
                    RoundedCornersShape(corners: .allCorners, radius: 20)
                        .fill(Color.homeCategory)
                    )
                    .shadow(radius: 1)
                }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 8)
                    .background(Color.clear)
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
            //HomeView()
        HomeCell()
    }
}
