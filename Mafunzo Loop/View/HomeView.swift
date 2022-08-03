//
//  HomeView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 08/07/2022.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State var settings: Bool = false
    @State var logout: Bool = false
    @State private var showLogoutAlert = false
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                   //HomeTopView
                    HStack {
                        Text("Hi, \(userViewModel.user.firstName)")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                        Spacer()
                        Menu {
                            Button("Settings") {
                                self.settings = true
                            }
                            Button("Logout") {
//                                Logout()
//                                self.settings = true
                                showLogoutAlert = true
                            }
                        } label: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .foregroundColor(Color.buttonHomeColor)
                        }
                    }.padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding()
                        .background(Color.yellow)
                        .frame(height: geo.size.height * 0.25)
                    VStack {
                        ScrollView {
                            HomeCell()
                        }
                        .frame(height: geo.size.height * 0.7)
                       .offset(y: -50)
                        Button {
                            // MARK: SCHOOL BUTTON
                            print("")
                        } label: {
                            Text(userViewModel.schoolD.schoolName)
                                .font(.body)
                                .foregroundColor(Color.buttonHomeColor)
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
            .background(
                NavigationLink(destination: Settings(), isActive: $settings) {
                    EmptyView()
            })
            .fullScreenCover(isPresented: $logout) {
                    LoginView()
            }
        }
        .onAppear {
            userViewModel.getUserDetails()
            userViewModel.getSchoolIDFromDetails()
        }
        // MARK: Logout Alert
                .alert(isPresented: $showLogoutAlert) {
                    Alert(
                        title: Text("Logout!!"),
                        message: Text("Are you sure you want to logout?"),
                        primaryButton: .default(
                            Text("Cancel")
                        ),
                        secondaryButton: .destructive(Text("Logout"), action: {
                        Logout()
                        logout.toggle()
                    }))
                }
    }
    func Logout() {
            do {
                UserDefaults.standard.reset()
                @AppStorage("log_status") var log_status = true
                try Auth.auth().signOut()
            } catch {
                print("already logged out")
                
            }
    }
}
// MARK: TOP VIEW
struct HomeTopView: View {
    @State var settings: Bool = false
    @State var logout: Bool = false
    @EnvironmentObject var userViewModel: UserViewModel
    //@StateObject var userViewModel = UserViewModel()
    var body: some View {
        HStack {
            Text("Hi, \(userViewModel.user.firstName)")
                .foregroundColor(.white)
                .font(.title2)
                .bold()
            Spacer()
            Menu {
                NavigationLink {
                    Settings()
                } label: {
                     Text("Settings")
                }
            } label: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
            }
        }.padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
        .background(Color.yellow)
        .onAppear {
            userViewModel.getUserDetails()
        }
    }
}
// MARK: Item Home Modules
struct HomeCell: View {
    var body: some View {
            VStack {
                HStack {
                    // MARK: Announcements
                    NavigationLink {
                        AnnoucementListView()
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
                    NavigationLink {
                        CalendarListView()
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
                    NavigationLink {
                        RequestView(request: Request())
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
                    NavigationLink {
                        TeachersListView()
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
                    NavigationLink {
                       SubjectView()
                    } label: {
                        VStack {
                            Image("ic_timetable")
                                .resizable()
                                .frame(width: 80, height: 80)
                            Text("Timetable")
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
                            Image("ic_school_bus")
                                .resizable()
                                .frame(width: 80, height: 80)
                            Text("School bus")
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
       // HomeCell()
        HomeTopView()
    }
}
