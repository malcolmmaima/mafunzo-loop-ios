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
                    grade
                    
                    day
                    
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
                        subject
                        noSubject
                    }
                    .overlay {
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

private extension TimetableView {
    // MARK: Grade
    var grade: some View {
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
    }
    
    // MARK: DAY
    var day: some View {
        Tabs( tabs: .constant(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]), selection: $timeTableViewModel.selectedDay, underlineColor: .blue) { day, isSelected in
            Text(day)
        }.padding()
            .onChange(of: timeTableViewModel.selectedDay) { newValue in
                print("New Value \(newValue)")
                timeTableViewModel.getSubject(selectedGrade: selectedGrades(grade: timeTableViewModel.grades[timeTableViewModel.selectedGrade]), timeTableDay: newValue)
        }
    }
    
    // MARK: Subjects
    var subject: some View {
        List {
            ForEach(timeTableViewModel.timeTable, id: \.dayOfWeek) { subject in
                TimetableListViewCell(subjectName: subject.subjectName, startTime: subject.startTime, endTime: subject.endTime)
                    .listRowSeparator(.hidden)
            }.listRowBackground(Color.ViewBackground)
        }.listStyle(.plain)
    }
    
    // MARK: No Subject
    var noSubject: some View {
        Text("No Subjects")
           .opacity(timeTableViewModel.noSubject ? 1 : 0)
    }
}


//MARK: -TabView Controller
private struct Tabs<Label: View>: View {
  @Binding var tabs: [String] // The tab titles
  @Binding var selection: Int // Currently selected tab
  let underlineColor: Color // Color of the underline of the selected tab
  // Tab label rendering closure - provides the current title and if it's the currently selected tab
  let label: (String, Bool) -> Label

  var body: some View {
    // Pack the tabs horizontally and allow them to be scrolled
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(alignment: .center, spacing: 30) {
        ForEach(tabs, id: \.self) {
          self.tab(title: $0)
        }
      }.padding(.horizontal, 3) // Tuck the out-most elements in a bit
  }
}

  private func tab(title: String) -> some View {
    let index = self.tabs.firstIndex(of: title)!
    let isSelected = index == selection
    return Button(action: {
      // Allows for animated transitions of the underline, as well as other views on the same screen
      withAnimation {
         self.selection = index
      }
    }) {
      label(title, isSelected)
            //.borderedCaption()
            .font(.system(size: 13, weight: .bold, design: .default))
            .padding(10)
            .frame(width: 100)
            .foregroundColor(isSelected ? .white : .gray)
            .background(isSelected ? .blue : .clear)
            .cornerRadius(20)
    }
  }
}
