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
                            subjectViewModel.getSubjecta(selectedGrade: selectedGrades(grade: subjectViewModel.grades[subjectViewModel.selectedGrade]), timeTableDay: subjectViewModel.selectedDay)
                        }
                    }.padding()
                    
                    Tabs( tabs: .constant(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]), selection: $subjectViewModel.selectedDay, underlineColor: .blue) { day, isSelected in
                        Text(day)
                    }.padding()
                        .onChange(of: subjectViewModel.selectedDay) { newValue in
                            print("New Value \(newValue)")
                            subjectViewModel.getSubjecta(selectedGrade: selectedGrades(grade: subjectViewModel.grades[subjectViewModel.selectedGrade]), timeTableDay: newValue)
                    }
//                    let _ = print("Selected Day is: \(selectedCategory)")
//                    let _ = print("Converted \(selectedGrades(grade: grades[selectedGrade]))")
                    
                   // Spacer()
                    switch(subjectViewModel.selectedDay) {
                    case 0: Monday(gradeSelected: selectedGrades(grade: subjectViewModel.grades[subjectViewModel.selectedGrade]), daySelected: subjectViewModel.selectedDay)
                    case 1: Tuesday()
                    case 2: Wednesday()
                    case 3: Thursday()
                    case 4: Friday()
                    default:
                        Monday(gradeSelected: selectedGrades(grade: subjectViewModel.grades[subjectViewModel.selectedGrade]), daySelected: subjectViewModel.selectedDay)
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

struct SubjectView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectView()
    }
}
