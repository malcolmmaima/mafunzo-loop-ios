//
//  SubjectViewModel.swift
//  Mafunzo Loop
//
//  Created by Mroot on 03/08/2022.
//

import Foundation
import Firebase

class SubjectViewModel: ObservableObject {
    @Published var selectedDay: Int = 0
    @Published var selectedGrade: Int = 0
    @Published var grades = ["Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5", "Grade 6", "Grade 7", "Grade 8", "Grade 9", "Grade 10", "Grade 11", "Grade 12"]
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg = ""
    @Published var verificationCode: String = ""
    //Status
    @Published var isLoading: Bool = false
    //Model
    @Published var subject = [Subject]()
    //Firebase
    let db = Firestore.firestore()
    
    init() {
      //  getSubject()
    }
    
    
    // MARK: GET Subject
    func getSubject(selectedGrade: String, timeTableDay: Int) {
        subject.removeAll()
        print("Selected Grade at Func: \(selectedGrade)")
        print("Time Table Day: \(timeTableDay)")
        let subjectRef = db.collection("subjects").document(" LQvFVzvUTDLezBxaU90z").collection(selectedGrade).whereField("dayOfWeek", isEqualTo: timeTableDay)
        subjectRef.getDocuments(source: .default) { subjectQuerySnapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let subjectDoc = subjectQuerySnapshot {
                for documents in subjectDoc.documents {
                    let data = documents.data()
                    let assignedTeacher = data["assignedTeacher"] as? String ?? ""
                    let subjectName = data["subjectName"] as? String ?? ""
                    let startTime = data["startTime"] as? Int ?? 0
                    let endTime = data["endTime"] as? Int ?? 0
                    let dayOfWeek = data["dayOfWeek"] as? Int ?? 0
                    DispatchQueue.main.async {
                        let subjectInfo = Subject(assignedTeacher: assignedTeacher, dayOfWeek: dayOfWeek, endTime: endTime, startTime: startTime, subjectName: subjectName)
                        self.subject.append(subjectInfo)
                        print("Subject Data \(documents.data())")
                    }
                }
            }
        }
    }
}
