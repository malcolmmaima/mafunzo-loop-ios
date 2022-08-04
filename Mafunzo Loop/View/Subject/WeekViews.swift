//
//  WeekViews.swift
//  Mafunzo Loop
//
//  Created by Mroot on 03/08/2022.
//

import SwiftUI

struct WeekViews: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Monday: View {
    @State var gradeSelected: String
    @State var daySelected: Int
    @StateObject var subjectViewModel = SubjectViewModel()
    var body: some View {
        ZStack {
            List {
                let _ = print("Day \(subjectViewModel.subject)")
                
                ForEach(subjectViewModel.subject, id: \.dayOfWeek) { subject in
                    SubjectListViewCell(subjectName: subject.subjectName, startTime: subject.startTime, endTime: subject.endTime)
                        .listRowSeparator(.hidden)
                }.listRowBackground(Color.ViewBackground)
            }.listStyle(.plain)
                .refreshable {
                    subjectViewModel.getSubject(selectedGrade: gradeSelected, timeTableDay: daySelected)
                }
                .onChange(of: gradeSelected) { grade in
                    print("Grade------- \(grade)")
                    subjectViewModel.getSubject(selectedGrade: grade, timeTableDay: daySelected)
    //                subjectViewModel.getSubjecta(selectedGrade: selectedGrades(grade: subjectViewModel.grades[subjectViewModel.selectedGrade]), timeTableDay: subjectViewModel.selectedDay)
                }
            Text("No Subjects")
               .opacity(subjectViewModel.noSubject ? 1 : 0)
        }
        .overlay {
            ProgressView()
                .opacity(subjectViewModel.isLoading ? 1 : 0)
                .font(.system(size: 2))
                .padding()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.yellow))
         }
        .onAppear {
            subjectViewModel.getSubject(selectedGrade: gradeSelected, timeTableDay: daySelected)
        }
    }
}
struct Tuesday: View {
    @StateObject var subjectViewModel = SubjectViewModel()
    var body: some View {
        ZStack {
            List {
                ForEach(subjectViewModel.subject, id: \.dayOfWeek) { subject in
                    SubjectListViewCell(subjectName: subject.subjectName, startTime: subject.startTime, endTime: subject.endTime)
                        .listRowSeparator(.hidden)
                }.listRowBackground(Color.ViewBackground)
            }.listStyle(.plain)
            Text("No Subjects")
               .opacity(subjectViewModel.noSubject ? 1 : 0)
        }
    }
}
struct Wednesday: View {
    @StateObject var subjectViewModel = SubjectViewModel()
    var body: some View {
        ZStack {
            List {
                ForEach(subjectViewModel.subject, id: \.dayOfWeek) { subject in
                    SubjectListViewCell(subjectName: subject.subjectName, startTime: subject.startTime, endTime: subject.endTime)
                        .listRowSeparator(.hidden)
                }.listRowBackground(Color.ViewBackground)
            }.listStyle(.plain)
            Text("No Subjects")
               .opacity(subjectViewModel.noSubject ? 1 : 0)
        }
    }
}
struct Thursday: View {
    @StateObject var subjectViewModel = SubjectViewModel()
    var body: some View {
        ZStack {
            List {
                ForEach(subjectViewModel.subject, id: \.dayOfWeek) { subject in
                    SubjectListViewCell(subjectName: subject.subjectName, startTime: subject.startTime, endTime: subject.endTime)
                        .listRowSeparator(.hidden)
                }.listRowBackground(Color.ViewBackground)
            }.listStyle(.plain)
            Text("No Subjects")
               .opacity(subjectViewModel.noSubject ? 1 : 0)
        }
    }
}
struct Friday: View {
    @StateObject var subjectViewModel = SubjectViewModel()
    var body: some View {
        ZStack {
            List {
                ForEach(subjectViewModel.subject, id: \.dayOfWeek) { subject in
                    SubjectListViewCell(subjectName: subject.subjectName, startTime: subject.startTime, endTime: subject.endTime)
                        .listRowSeparator(.hidden)
                }.listRowBackground(Color.ViewBackground)
            }.listStyle(.plain)
            Text("No Subjects")
               .opacity(subjectViewModel.noSubject ? 1 : 0)
        }
    }
}

struct WeekViews_Previews: PreviewProvider {
    static var previews: some View {
        WeekViews()
    }
}
