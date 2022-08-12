//
//  UserViewModel.swift
//  Mafunzo Loop
//
//  Created by Mroot on 09/07/2022.
//

import Foundation
import Firebase

class UserViewModel: ObservableObject {
  
    var schoolID: String = ""
    @Published var name = ""
    @Published var fetchedSchool = ""
    //Model
    @Published var user: User = .init()
    @Published var schools = Schools(schoolID: ["" : false])
    //Status
    @Published var userStatus: Bool = true
    @Published var schoolStatus: Bool = true
    @Published var schoolStored = UserDefaults.standard.string(forKey: "schoolID") ?? ""
    @Published var isLoading: Bool = false
    // VIEWS
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg = ""
    @Published var verificationCode: String = ""
    //Firebase
    let db = Firestore.firestore()

    // MARK: Fetch User Details from DB
    func getUserDetails(schoolIDStore: String) {
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
                        self.user.accountType = userData?["accountType"] as? String ?? ""
                        let state = userData?["enabled"] as? Bool ?? false
                        let schoolsMappedDB = userData?["schools"] as? [String: Bool] ?? [:]
                        
                        let schoolDictionary = Schools(schoolID: schoolsMappedDB)
                        self.schools = schoolDictionary
                        let schoolIds = Array(schoolDictionary.schoolID) //Convert schoolDictionary to array

                        let userSchoolIDs = Array(schoolDictionary.schoolID.keys.map { $0 }) // convert dictionary String to array
                        let schoolID = userSchoolIDs.joined(separator: " ")
                        
                        UserDefaults.standard.set(userSchoolIDs, forKey: "schoolID's") //save school IDs [String]
                        UserDefaults.standard.set(schoolsMappedDB, forKey: "schoolArray") // School Dictionary [String: Bool]
                        
                        let userSchools = UserDefaults.standard.stringArray(forKey: "schoolID's")  ?? [String]()
                        
                        // check if school ID is stored in user Default
                        if schoolIDStore == "" {
                            // check if the user id is in Array dictionary.
                            if schoolsMappedDB.keys.contains(schoolIDStore) == false {
                                UserDefaults.standard.set(schoolID, forKey: "schoolID") //save school ID
                                
                            }
                            
                        } else {
                            let stateschool = schoolDictionary.schoolID[schoolIDStore]
                            self.schoolStatus = stateschool ?? false
                            print("Value of school \(stateschool ?? false)")
                        }
                        self.name = self.user.firstName
                        self.userStatus = state
                        
                        print("School Ids : \(schoolIds)")
                        print("School Mapped:------- \(schoolsMappedDB)")
                        print("Map Data:: \(userSchoolIDs)")
                        print("School ID fFROM DB:: \(userSchools)")
                        print("Check String Value \(schoolsMappedDB.keys.contains(schoolIDStore))")
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
    
    // MARK: UPDATE USER
    func updateUser(user: User) async {
        do {
            isLoading = true
            let userSavedNumber = UserDefaults.standard.string(forKey: "userNumber") ?? ""
            let userNumber = String(describing: userSavedNumber)
            let userRef = db.collection("users").document(userNumber)
            try await userRef.updateData([
                "firstName": user.firstName,
                "lastName": user.lastName,
                "email": user.email
            ])
            DispatchQueue.main.async {
                self.isLoading = false
            }
        } catch {
            print("Update User Error!! \(error.localizedDescription)")
        }
    }
}
