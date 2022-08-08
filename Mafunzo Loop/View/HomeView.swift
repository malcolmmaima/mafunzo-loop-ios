//
//  HomeView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 08/07/2022.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @ObservedObject var userViewModel = UserViewModel()
    @StateObject var schoolViewModel = SchoolViewModel()
    @ObservedObject var user: User
    @State var settings: Bool = false
    @State var logout: Bool = false
    @State private var schoolList: Bool = false
    @State private var showLogoutAlert = false
    @State private var showWorkSpace = false
    @State private var blurRadius: Double = 1.0
    var body: some View {
        ZStack {
            NavigationView {
                GeometryReader { geo in
                    VStack {
                       // MARK: TopView
                        HStack {
                            Text("Hi, \(userViewModel.name)")
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                            Spacer()
                            Menu {
                                Button("Settings") {
                                    self.settings = true
                                }
                                Button("Logout") {
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
                            .blur(radius: showWorkSpace ? 10 : 0)
                            .disabled(showWorkSpace ? true : false)
                        // MARK: SChool Modules
                        VStack {
                            ScrollView {
                                ZStack {
                                    HomeCell()
                                        .blur(radius: showWorkSpace ? 5 : 0)
                                        .disabled(showWorkSpace ? true : false)
                                     //   .opacity(userViewModel.userState ? 1 : 0)
    //                                VStack {
    //                                    InActiveAccountView()
    //                                    Text("Contact your school to activate your workspace")
    //                                        .foregroundColor(.red)
    //                                    Spacer()
    //                                }
    //                                .opacity(userViewModel.userState ? 0 : 1)
                                    WorkSpaceView()
                                        .opacity(showWorkSpace ? 1 : 0)
                                }
                            }
                            .frame(height: geo.size.height * 0.7)
                           .offset(y: -50)
                           .onTapGesture {
                               showWorkSpace = false //diable Workspace View
                           }
                            Button {
                                // MARK: SCHOOL BUTTON
                                showWorkSpace = true
                            } label: {
                                Text(userViewModel.fetchedSchool)
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
            .opacity(userViewModel.userState ? 1 : 0)
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
            DisabledAccountView()
                .opacity(userViewModel.userState ? 0 : 1)
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
                       TimetableView()
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

// MARK: WORK SPACE ERROR
struct WorkSpaceErrorView: View {
    var body: some View {
        HStack {
            // MARK: Announcements
            Button {
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
    }
}

// MARK: WORK SPACE
struct WorkSpaceView: View {
    @StateObject var schoolViewModel = SchoolViewModel()
    var body: some View {
        VStack {
            VStack {
                Text("Switch WorkSpace")
                    .bold()
                    .font(.title)
                    .padding()
                ForEach(schoolViewModel.selectedSchool, id: \.id) { school in
                    Text(school.schoolName)
                        .frame(alignment: .leading)
                        .padding(.bottom, 1)
                        .onTapGesture {
                            /*
                             let schoolStored = UserDefaults.standard.string(forKey: "schoolID") ?? ""
                             let userSavedNumber = UserDefaults.standard.string(forKey: "userNumber") ?? ""
                             let userNumber = String(describing: userSavedNumber)
                             let schoolID = String(describing: schoolStored)
                             
                             UserDefaults.standard.set(schoolID, forKey: "schoolID") //save school ID
                             */
                            
                            let schoolID = school.id
                            UserDefaults.standard.set(schoolID, forKey: "schoolID")
                            print("School Id = \(schoolID)")
                            print("School Name \(school.schoolName) Pressed::::::::::")
                        }
                }
                Spacer()
                NavigationLink {
                    // MARK: SCHOOL BUTTON
                    SchoolListView()
                } label: {
                    Text("Add School")
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(width: 250, height: 35)
                }
                .background(Color.blue)
                .padding(.bottom, 10)
            }
        }
        .frame(width: 300, height: 280, alignment: .center)
        .background(
            RoundedCornersShape(corners: .allCorners, radius: 15)
                .fill(Color.homeCategory)
        )
        .shadow(radius: 2.0)
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: User())
    }
}
