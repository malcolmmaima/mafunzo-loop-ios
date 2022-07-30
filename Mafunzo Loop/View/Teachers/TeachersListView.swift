//
//  TeachersListView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 30/07/2022.
//

import SwiftUI

struct TeachersListView: View {
    @StateObject var teacherViewModel = TeachersViewModel()
    var body: some View {
        GeometryReader { geo in
            VStack {
                AnnoucementTopView()
                    .frame(height: geo.size.height * 0.09)
                VStack {
                    List {
                        ForEach(teacherViewModel.teacher , id: \.id) { teacher in
                            NavigationLink(destination: TeacherView(teacher: teacher)) {
                                TeacherListViewCell(profilePicture: teacher.profilePic, firstName: teacher.firstName, lastName: teacher.lastName, subjects: teacher.subjects, grades: teacher.grades, bio: teacher.bio)
                            }
                            .listRowSeparator(.hidden)
                        }
                        .listRowBackground(Color.ViewBackground)
                    }
                    .listStyle(.plain)
                    .padding(.top, 25)
                    .refreshable {
                        teacherViewModel.getAllTeachers()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedCornersShape(corners: .allCorners, radius: 40)
                        .fill(Color.ViewBackground)
                )
                .offset(y: -55)
            }
            .onAppear {
                teacherViewModel.getAllTeachers()
            }
            .overlay {
                ProgressView()
                    .opacity(teacherViewModel.isLoading ? 1 : 0)
                    .font(.system(size: 2))
                    .padding()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.yellow))
                }
        }
        .navigationBarTitle(Text("Teachers"), displayMode: .inline)
    }
}

struct TeachersListView_Previews: PreviewProvider {
    static var previews: some View {
        TeachersListView()
    }
}
