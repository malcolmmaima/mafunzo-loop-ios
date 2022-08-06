//
//  SchoolViewModel.swift
//  Mafunzo Loop
//
//  Created by Mroot on 06/08/2022.
//

import Foundation
import Firebase

class SchoolViewModel: ObservableObject {
    @Published var searchSchool = ""
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg = ""
    @Published var verificationCode: String = ""
    //Status
    @Published var isLoading: Bool = false
    //Model
    @Published var school = [SchoolData]()
    @Published var selectedSchool = [SelectedSchool]()
    //Firebase
    let db = Firestore.firestore()
    //Initialze functions
    init() {
        getALLSchools()
        getUserSchools()
    }
        // MARK: Search School
    var schoolSearch: [SchoolData] {
        if searchSchool.isEmpty {
            return school
        } else {
            return school.filter {$0.schoolName.localizedCaseInsensitiveContains(searchSchool)}
        }
    }
    // MARK: GET Schools from user
    func getUserSchools() {
        let userSchools = UserDefaults.standard.stringArray(forKey: "schoolID's")  ?? [String]()
        print("Dataa1 \(userSchools)")
        selectedSchool.removeAll()
        let ref = db.collection("app_settings").document("schools").collection("KE").whereField("id", in: userSchools)
           // .whereField("id", in: userSchools)
            //.whereField("id", arrayContainsAny: userSchools)
        print("1")
        ref.getDocuments { snapshot, error in
            print("2")
            guard error == nil else {
                print("Error!!! \(error!.localizedDescription)")
                self.handleError(error: error!.localizedDescription)
                return
            }
            print("3")
            if let snapshot = snapshot {
                print("4")
                for document in snapshot.documents {
                    print("5")
                    if document == document {
                        print("6")
                        let data = document.data()
                        let docId = data["id"] as? String ?? ""
                        let schoolName = data["schoolName"] as? String ?? ""
                        let schoolLocation = data["schoolLocation"] as? String ?? ""
                        let schoolEmail = data["schoolEmail"] as? String ?? ""
                        let userSchools = SelectedSchool(id: docId, schoolLocation: schoolLocation, schoolName: schoolName, schoolEmail: schoolEmail)
                        self.selectedSchool.append(userSchools)
                    }
                }
            }
        }
    }
    
    // MARK: GET Schools
    func getALLSchools() {
        //remove all schools
        school.removeAll()
        let ref = db.collection("app_settings").document("schools").collection("KE")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print("Error!!! \(error!.localizedDescription)")
                self.handleError(error: error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    if document == document {
                        let data = document.data()
                        let docId = data["id"] as? String ?? ""
                        let schoolName = data["schoolName"] as? String ?? ""
                        let schoolLocation = data["schoolLocation"] as? String ?? ""
                        let schoolEmail = data["schoolEmail"] as? String ?? ""
                        let schoolDataList = SchoolData(id: docId, schoolLocation: schoolLocation, schoolName: schoolName, schoolEmail: schoolEmail)
                        self.school.append(schoolDataList)
                    }
                }
            }
        }
    }
    // MARK: ERROR HANDLER
    func handleError(error: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMsg = error
            self.showAlert.toggle()
        }
    }
}
