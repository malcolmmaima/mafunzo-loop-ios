//
//  SubjectView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 03/08/2022.
//

import SwiftUI

struct TimetableView: View {
    @StateObject var timeTableViewModel = TimetableViewModel()
    var body: some View {
        GeometryReader { geo in
            VStack {
                NavigationTopView()
                    .frame(height: geo.size.height * 0.1)
                VStack {
                    HStack {
                        Text("Select Grade")
                        Spacer()
                        Picker(selection: $timeTableViewModel.selectedGrade, label: Text("Grade")) {
                            ForEach(0..<timeTableViewModel.grades.count, id: \.self) {
                                Text(self.timeTableViewModel.grades[$0])
                            }
                        }.onChange(of: timeTableViewModel.selectedGrade) { newGrade in
                            let selected = self.timeTableViewModel.grades[newGrade]
                            let convertedGrade = (selectedGrades(grade: selected))
                            print("New Grade \(convertedGrade)")
                            timeTableViewModel.getSubject(selectedGrade: convertedGrade, timeTableDay: timeTableViewModel.selectedDay)
                        }
                    }.padding()
                    
                    Tabs( tabs: .constant(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]), selection: $timeTableViewModel.selectedDay, underlineColor: .blue) { day, isSelected in
                        Text(day)
                    }.padding()
                        .onChange(of: timeTableViewModel.selectedDay) { newValue in
                            print("New Value \(newValue)")
                            timeTableViewModel.getSubject(selectedGrade: selectedGrades(grade: timeTableViewModel.grades[timeTableViewModel.selectedGrade]), timeTableDay: newValue)
                    }
                    switch(timeTableViewModel.selectedDay) {
                    case 0: Day()
                    case 1: Day()
                    case 2: Day()
                    case 3: Day()
                    case 4: Day()
                    default:
                        Text("Please select Grade and Day")
                    }
                    ZStack {
                        List {
                            ForEach(timeTableViewModel.timeTable, id: \.dayOfWeek) { subject in
                                TimetableListViewCell(subjectName: subject.subjectName, startTime: subject.startTime, endTime: subject.endTime)
                                    .listRowSeparator(.hidden)
                            }.listRowBackground(Color.ViewBackground)
                        }.listStyle(.plain)
                        Text("No Subjects")
                           .opacity(timeTableViewModel.noSubject ? 1 : 0)
                    }        .overlay {
                        ProgressView()
                            .opacity(timeTableViewModel.isLoading ? 1 : 0)
                            .font(.system(size: 3))
                            .padding()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
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
        }
        .navigationBarTitle(Text("Timetable"), displayMode: .inline)
    }
    func selectedGrades(grade: String) -> String {
        var trimmed = grade.filter({$0 != " "}) //remove white space
        trimmed.insert("_", at: trimmed.index(trimmed.startIndex, offsetBy: 5)) //add underscore
        print("SelectedGrades: \(trimmed.lowercased())")
        return trimmed.lowercased()
    }
}

struct Day: View {
    @StateObject var subjectViewModel = TimetableViewModel()
    var body: some View {
        ZStack {
        }
    }
}

struct SubjectView_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView()
    }
}
