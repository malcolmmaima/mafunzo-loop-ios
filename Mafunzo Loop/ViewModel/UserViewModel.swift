//
//  UserViewModel.swift
//  Mafunzo Loop
//
//  Created by Mroot on 09/07/2022.
//

import Foundation
import Firebase

@MainActor
class UserViewModel: ObservableObject {
    @Published var user: User = .init()
   // var schoolD = SchoolData(id: "", schoolLocation: "", schoolName: "", schoolEmail: "")
    var schoolID: String = ""
    @Published var name = ""
    @Published var fetchedSchool = "" {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var userState: Bool = true
    @Published var schoolState: Bool = true
    @Published var map = MappedData(schoolID: ["" : false])
    // VIEWS
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg = ""
    @Published var verificationCode: String = ""
    //Status
    @Published var isLoading: Bool = false
    @Published var schoolStored = UserDefaults.standard.string(forKey: "schoolID") ?? ""
    //Firebase
    let db = Firestore.firestore()
//    //Initialze functions
//    init() {
//        getUserDetails()
//        getSchoolIDFromDetails(schoolIDDB: schoolStored)
//    }
    // MARK: Fetch User Details from DB
    func getUserDetails(schoolIDStore: String) {
        print("At user Details 11")
        let userNumber = UserDefaults.standard.string(forKey: "userNumber") ?? ""
        let number = String(describing: userNumber )
        print("Number \(number)")
        if number != "" {
            let docRef = db.collection("users").document(number)
            docRef.getDocument(source: .server) { document, error in
                if let document = document {
                    DispatchQueue.main.async {
                        let userData = document.data()
                        self.user.firstName = userData?["firstName"] as? String ?? ""
                        self.user.lastName = userData?["lastName"] as? String ?? ""
                        self.user.email = userData?["email"] as? String ?? ""
                        let state = userData?["enabled"] as? Bool ?? false
                        let schoolMapped = userData?["schoolMap"] as? [String: Bool] ?? [:]
                        
//                        let schoolData = userData?["schools"] as? [String] ?? []
//                        let schoolID = schoolData.joined(separator: " ")
//                        UserDefaults.standard.set(schoolID, forKey: "schoolID") //save school ID
                        
                        self.user.accountType = userData?["accountType"] as? String ?? ""
                        print("User Details1 \(String(describing: userData))")
                        print("School Map:: \(schoolMapped)")
                        let m = MappedData(schoolID: schoolMapped)
                        self.map = m
                        let schoolIds = Array(m.schoolID)
                        
                        let userSchoolIDs = Array(m.schoolID.keys.map { $0 }) // convert dictionary String to array
                        let schoolID = userSchoolIDs.joined(separator: " ")
                        
                        UserDefaults.standard.set(userSchoolIDs, forKey: "schoolID's")
                        UserDefaults.standard.set(schoolMapped, forKey: "schoolArray")
                        
                        
//                        UserDefaults.standard.set(schoolID, forKey: "schoolID") //save school ID
                        
                        let userSchools = UserDefaults.standard.stringArray(forKey: "schoolID's")  ?? [String]()
                        
                        // check if school ID is stored in user Default
                        if schoolIDStore == "" {
                            // check if the user id is in Array dictionary.
                            if schoolMapped.keys.contains(schoolIDStore) == false {
                                UserDefaults.standard.set(schoolID, forKey: "schoolID") //save school ID
                            }
                            
                        } else {
                            let stateschool = m.schoolID[schoolIDStore]
                            self.schoolState = stateschool ?? false
                            print("Value of school \(stateschool ?? false)")
                        }
                        
                        print("School Ids : \(schoolIds)")
                        self.userState = state
                        print("School Mapped:------- \(schoolMapped)")
                        print("Map Data:: \(userSchoolIDs)")
                        print("School ID fFROM DB:: \(userSchools)")
                        print("Check String Value \(schoolMapped.keys.contains(schoolIDStore))")
                        
                        self.name = self.user.firstName
                    }
                } else {
                    print(error?.localizedDescription ?? "No Data Found")
                }
            }
        }
    }
    // MARK: GET SCHOOL BY ID
    func getSchoolIDFromDetails(schoolIDStore: String) {
        let schoolID = String(describing: schoolIDStore)
        print("Get School ID \(schoolID)")
        if schoolID != "" {
            let docRef = db.collection("app_settings").document("schools").collection("KE").document(schoolID)
            docRef.getDocument(source: .server) { document, error in
                if let schoolDocument = document {
                    DispatchQueue.main.async {
                        let schoolDetails = schoolDocument.data()
                        let schoolName  = schoolDetails?["schoolName"] as? String ?? ""
                        self.fetchedSchool =  schoolName
                        print("School Name is: \(schoolName)")
                    }
                }
            }
        }
    }
    
//    func getSchoolIDDB(schoolIDStore: String) {
//        let schoolID = String(describing: schoolIDStore)
//        print("Get School ID @@ \(schoolID)")
//        if schoolID != "" {
//            let docRef = db.collection("app_settings").document("schools").collection("KE").document(schoolID)
//            docRef.getDocument(source: .server) { document, error in
//                if let schoolDocument = document {
//                    DispatchQueue.main.async {
//                        let schoolDetails = schoolDocument.data()
//                        let schoolName  = schoolDetails?["schoolName"] as? String ?? ""
//                        self.fetchedSchool =  schoolName
//                        print("School Name is: \(schoolName)")
//                    }
//                }
//            }
//        }
//    }
}
