//
//  SubjectViewModel.swift
//  Mafunzo Loop
//
//  Created by Mroot on 03/08/2022.
//

import Foundation
import Firebase

class TimetableViewModel: ObservableObject {
    @Published var selectedDay: Int = 0
    @Published var selectedGrade: Int = 0
    @Published var grades = ["Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5", "Grade 6", "Grade 7", "Grade 8", "Grade 9", "Grade 10", "Grade 11", "Grade 12"]
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg = ""
    @Published var verificationCode: String = ""
    //Status
    @Published var isLoading: Bool = false
    @Published var noSubject: Bool = false
    //Model
    @Published var timeTable = [Timetable]()
    //Firebase
    let db = Firestore.firestore()
    
    
    // MARK: GET Subject
    func getSubject(selectedGrade: String, timeTableDay: Int) {
        print("Selected Grade at Func: \(selectedGrade) && Time Table Day: \(timeTableDay)")
        noSubject = false
        isLoading = true
        timeTable.removeAll()
        let schoolStored = UserDefaults.standard.string(forKey: "schoolID") ?? ""
        let schoolID = String(describing: schoolStored)
        //check school status
        if schoolID != "" {
            let subjectRef = db.collection("subjects").document(" LQvFVzvUTDLezBxaU90z").collection(selectedGrade).whereField("dayOfWeek", isEqualTo: timeTableDay)
            subjectRef.getDocuments(source: .default) { subjectQuerySnapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                if let subjectDoc = subjectQuerySnapshot {
                    if subjectDoc.documents == [] {
                        self.isLoading = false
                        self.noSubject = true
                    }
                    for documents in subjectDoc.documents {
                        self.noSubject = false
                        let data = documents.data()
                        let assignedTeacher = data["assignedTeacher"] as? String ?? ""
                        let subjectName = data["subjectName"] as? String ?? ""
                        let startTime = data["startTime"] as? Int ?? 0
                        let endTime = data["endTime"] as? Int ?? 0
                        let dayOfWeek = data["dayOfWeek"] as? Int ?? 0
                        DispatchQueue.main.async {
                            let subjectInfo = Timetable(assignedTeacher: assignedTeacher, dayOfWeek: dayOfWeek, endTime: endTime, startTime: startTime, subjectName: subjectName)
                            self.timeTable.append(subjectInfo)
                            self.isLoading = false
                            print("Subject Data \(documents.data())")
                        }
                    }
                }
            }
        }
    }
}
