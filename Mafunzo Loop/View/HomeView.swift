//
//  HomeView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 08/07/2022.
//

import SwiftUI
import Firebase
import AlertToast

struct HomeView: View {
    @StateObject var userViewModel = UserViewModel()
    @StateObject var schoolViewModel = SchoolViewModel()
    @ObservedObject var networkManager = NetworkViewModel()
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
                        // MARK: School Modules
                        VStack {
                            ScrollView {
                                ZStack {
                                    HomeCell()
                                        .blur(radius: showWorkSpace ? 5 : 0)
                                        .disabled(showWorkSpace ? true : false)
                                        .opacity(userViewModel.schoolStatus ? 1 : 0)
                                    VStack {
                                        // MARK: -WORKSPACE ERROR!!! VIEW
                                        WorkSpaceErrorView()
                                        Text("Contact your school to activate your workspace")
                                            .foregroundColor(.red)
                                        Spacer()
                                    }
                                    .opacity(userViewModel.schoolStatus ? 0 : 1)
                                    // MARK: -WORKSPACE VIEW SELECT
                                    //WorkSpaceView()
                                    VStack {
                                        VStack {
                                            Text("Switch WorkSpace")
                                                .bold()
                                                .font(.title)
                                                .padding()
                                            List {
                                                ForEach(schoolViewModel.selectedSchool, id: \.id) { school in
                                                    Text(school.schoolName)
                                                        .frame(alignment: .leading)
                                                        .padding(.bottom, 1)
                                                        .listRowSeparator(.hidden)
                                                        .onTapGesture {
                                                            let schoolID = school.id
                                                            UserDefaults.standard.set(schoolID, forKey: "schoolID") //save selected School ID
                                                            userViewModel.getSchoolIDFromDetails(schoolIDStore: schoolID)
                                                            userViewModel.getUserDetails(schoolIDStore: schoolID)
                                                            print("School Id Picked: \(userViewModel.schoolStored)")
                                                            print("School Name Selected: \(school.schoolName)")
                                                        }
                                                }.listRowBackground(Color.clear)
                                            }
                                            .listStyle(.plain)
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
                                    .onAppear {
                                        schoolViewModel.getUserSchools()
                                    }
                                    .opacity(showWorkSpace ? 1 : 0)
                                    // MARK: -
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
                            // MARK: Network Listener
//                             if networkManager.isNotConnected {
//                                 NetworkViewCell(netStatus: networkManager.conncetionDescription, image: networkManager.imageName)
//                             }
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
            .opacity(userViewModel.userStatus ? 1 : 0)
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
            .onAppear {
                userViewModel.getUserDetails(schoolIDStore: userViewModel.schoolStored)
                userViewModel.getSchoolIDFromDetails(schoolIDStore: userViewModel.schoolStored)
            }
            DisabledAccountView()
                .opacity(userViewModel.userStatus ? 0 : 1)
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
    @State var bus = false
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
                        bus = true
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
            .toast(isPresenting: $bus, duration: 1.0) {
                return AlertToast(type: .systemImage("bus", Color.gray), title: "Coming Soon")
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
    @StateObject var userViewModel = UserViewModel()
    var body: some View {
        VStack {
            VStack {
                Text("Switch WorkSpace")
                    .bold()
                    .font(.title)
                    .padding()
                List {
                    ForEach(schoolViewModel.selectedSchool, id: \.id) { school in
                        Text(school.schoolName)
                            .frame(alignment: .leading)
                            .padding(.bottom, 1)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                let schoolID = school.id
                                //userViewModel.schoolStored = schoolID
                                UserDefaults.standard.set(schoolID, forKey: "schoolID")
                                userViewModel.getSchoolIDFromDetails(schoolIDStore: schoolID)
                                print("School Id = \(userViewModel.schoolStored)")
                                print("School Name \(school.schoolName) Pressed::::::::::")
                                
                            }
                    }.listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .onDisappear {
                    userViewModel.getSchoolIDFromDetails(schoolIDStore: userViewModel.schoolStored)
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
        .onAppear {
            schoolViewModel.getUserSchools()
        }
        .onDisappear {
            print("disappear")
            
            userViewModel.getSchoolIDFromDetails(schoolIDStore: userViewModel.schoolStored)
            userViewModel.getUserDetails(schoolIDStore: userViewModel.schoolStored)
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: User())
    }
}
