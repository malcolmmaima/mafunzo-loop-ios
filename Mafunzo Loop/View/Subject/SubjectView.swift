//
//  SubjectView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 03/08/2022.
//

import SwiftUI

struct SubjectView: View {
    @StateObject var subjectViewModel = SubjectViewModel()
    var body: some View {
        GeometryReader { geo in
            VStack {
                NavigationTopView()
                    .frame(height: geo.size.height * 0.1)
                VStack {
                    HStack {
                        Text("Select Grade")
                        Spacer()
                        Picker(selection: $subjectViewModel.selectedGrade, label: Text("Grade")) {
                            ForEach(0..<subjectViewModel.grades.count, id: \.self) {
                                Text(self.subjectViewModel.grades[$0])
                            }
                        }.onChange(of: subjectViewModel.selectedGrade) { newGrade in
                            let selected = self.subjectViewModel.grades[newGrade]
                            let convertedGrade = (selectedGrades(grade: selected))
                            print("New Grade \(convertedGrade)")
                            subjectViewModel.getSubject(selectedGrade: convertedGrade, timeTableDay: subjectViewModel.selectedDay)
                        }
                    }.padding()
                    
                    Tabs( tabs: .constant(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]), selection: $subjectViewModel.selectedDay, underlineColor: .blue) { day, isSelected in
                        Text(day)
                    }.padding()
                        .onChange(of: subjectViewModel.selectedDay) { newValue in
                            print("New Value \(newValue)")
                            subjectViewModel.getSubject(selectedGrade: selectedGrades(grade: subjectViewModel.grades[subjectViewModel.selectedGrade]), timeTableDay: newValue)
                    }
                    switch(subjectViewModel.selectedDay) {
                    case 0: Day()
                    case 1: Day()
                    case 2: Day()
                    case 3: Day()
                    case 4: Day()
                    default:
                        Day()
                    }
                    ZStack {
                        List {
                            ForEach(subjectViewModel.subject, id: \.dayOfWeek) { subject in
                                SubjectListViewCell(subjectName: subject.subjectName, startTime: subject.startTime, endTime: subject.endTime)
                                    .listRowSeparator(.hidden)
                            }.listRowBackground(Color.ViewBackground)
                        }.listStyle(.plain)
                        Text("No Subjects")
                           .opacity(subjectViewModel.noSubject ? 1 : 0)
                    }        .overlay {
                        ProgressView()
                            .opacity(subjectViewModel.isLoading ? 1 : 0)
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
    @StateObject var subjectViewModel = SubjectViewModel()
    var body: some View {
        ZStack {
        }
    }
}



struct SubjectView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectView()
    }
}
