//
//  UserViewModel.swift
//  Mafunzo Loop
//
//  Created by Mroot on 09/07/2022.
//

import Foundation
import Firebase
class UserViewModel: ObservableObject {
    @Published var user: User = .init()
    var schoolD = SchoolData(id: "", schoolLocation: "", schoolName: "")
    var schoolID: String = ""
    // VIEWS
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg = ""
    @Published var verificationCode: String = ""
    //Status
    @Published var isLoading: Bool = false
    //Firebase
    let db = Firestore.firestore()
    //Initialze functions
    init() {
        getUserDetails()
        getSchoolIDFromDetails()
    }
    // MARK: Fetch User Details from DB
    func getUserDetails() {
        print("At user Details 11")
        let userNumber = UserDefaults.standard.string(forKey: "userNumber") ?? ""
        let number = String(describing: userNumber )
        print("Number \(number)")
        if number != "" {
            let docRef = db.collection("users").document(number)
            docRef.getDocument(source: .server) { document, error in
                if let document = document {
                    let userData = document.data()
                    self.user.firstName = userData?["firstName"] as? String ?? ""
                    self.user.lastName = userData?["lastName"] as? String ?? ""
                    self.user.email = userData?["email"] as? String ?? ""
                    let schoolData = userData?["schools"] as? [String] ?? []
                    let schoolID = schoolData.joined(separator: " ")
                    UserDefaults.standard.set(schoolID, forKey: "schoolID") //save school ID
                    self.user.accountType = userData?["accountType"] as? String ?? ""
                    print("User School \(self.user.firstName)")
                } else {
                    print(error?.localizedDescription ?? "No Data Found")
                }
            }
        }
    }
    // MARK: GET SCHOOL BY ID
    func getSchoolIDFromDetails() {
        let schoolStored = UserDefaults.standard.string(forKey: "schoolID") ?? ""
        let schoolID = String(describing: schoolStored)
        print("Get School ID ]\(schoolID)")
        if schoolID != "" {
            let docRef = db.collection("app_settings").document("schools").collection("KE").document(schoolID)
            docRef.getDocument(source: .server) { document, error in
                if let schoolDocument = document {
                    let schoolDetails = schoolDocument.data()
                    let schoolName = schoolDetails?["schoolName"] as? String ?? ""
                    //self.user.schools[].schoolName = schoolName
                    self.schoolD.schoolName = schoolName
                    print("School Name is: \(String(describing: schoolName))")
                }
            }
        }
    }
}
