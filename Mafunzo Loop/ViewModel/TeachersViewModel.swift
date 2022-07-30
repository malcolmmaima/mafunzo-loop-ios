//
//  TeachersViewModel.swift
//  Mafunzo Loop
//
//  Created by Mroot on 30/07/2022.
//

import Foundation
import Firebase

class TeachersViewModel: ObservableObject {
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg = ""
    @Published var verificationCode: String = ""
    //Status
    @Published var isLoading: Bool = false
    //Model
    @Published var teacher = [Teacher]()
    //Firebase
    let db = Firestore.firestore()
    
    // MARK: GET ALL Teachers
    func getAllTeachers() {
        isLoading = true
        teacher.removeAll()
        let schoolStored = UserDefaults.standard.string(forKey: "schoolID") ?? ""
        let schoolID = String(describing: schoolStored)
        if schoolID != "" {
            let teacherRef = db.collection("teachers").document(schoolID).collection("collection")
            teacherRef.getDocuments(source: .default) { teacherQuerySnapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                if let teachers = teacherQuerySnapshot {
                    for document in teachers.documents {
                        let data = document.data()
                        let dateCreated = data["dateCreated"] as? Int ?? 0
                        let emailAddress = data["emailAddress"] as? String ?? ""
                        let firstName = data["firstName"] as? String ?? ""
                        let lastName = data["lastName"] as? String ?? ""
                        let id = data["id"] as? String ?? ""
                        let bio = data["bio"] as? String ?? ""
                        let status = data["status"] as? String ?? ""
                        let profilePic = data["profilePic"] as? String ?? ""
                        let phoneNumber = data["phoneNumber"] as? String ?? ""
                        let subjects = data["subjects"] as? [String] ?? []
                        let grades = data["grades"] as? [String] ?? []
                        
                        let teachersData = Teacher(bio: bio, dateCreated: dateCreated, emailAddress: emailAddress, firstName: firstName, grades: grades, id: id, lastName: lastName, phoneNumber: phoneNumber, profilePic: profilePic, status: status, subjects: subjects)
                        self.teacher.append(teachersData) //append user Data to [Teacher]
                        self.isLoading = false

                    }
                }
            }
        }
    }
}
