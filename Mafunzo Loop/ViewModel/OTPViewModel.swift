//
//  UserViewModel.swift
//  Mafunzo Loop
//
//  Created by mroot on 01/07/2022.
//

import Foundation
import SwiftUI
import Firebase

class OTPViewModel: ObservableObject {
    @Published var user: User = .init()
    @Published var schoolData = SchoolData(id: "", schoolLocation: "", schoolName: "", schoolEmail: "")
    //OTP
    @Published var otpText: String = ""
    @Published var otpFields: [String] = Array(repeating: "", count: 6)
    @Published var countryCode = ""
    @Published var accountType = ["PARENT", "TEACHER", "STUDENT", "BUS_DRIVER"]
    @Published var accountSelected = 0
    @Published var schoolSelected = 0
    // VIEWS
    @Published var toAccountSetup = false
    @Published var toHomeScreen = false
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg = ""
    @Published var verificationCode: String = ""
    //Status
    @Published var isLoading: Bool = false
    @Published var verificationTag: String?
    @AppStorage("log_status") var log_status = false
    //Firebase
    let db = Firestore.firestore()
    //Initialze functions
    init() {
        getSchools()
    }
    // MARK: Send OTP
    func sendOTP(phone: String) async {
        do {
            isLoading = true
            print("User Phone: \(phone)")
            let result = try await PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil)
            DispatchQueue.main.async {
                self.isLoading = false
                self.verificationCode = result
                self.verificationTag = "VERIFICATION"
            }
        } catch {
            handleError(error: error.localizedDescription)
        }
    }
    // MARK: VERIFY OTP
    func verifyOTP(phone: String) async {
        do {
            isLoading = true
            otpText = otpFields.reduce("") { partialResult, value in
                partialResult + value
            }
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationCode, verificationCode: otpText)
            _ = try await Auth.auth().signIn(with: credential)
            await checkUserStatus(number: phone)
        } catch {
            handleError(error: error.localizedDescription)
        }
    }
    // MARK: Check if user Exists
    func checkUserStatus(number: String) async {
        do {
            let docRef = db.collection("users").document(number)
            let doc = try await docRef.getDocument()
            if(!doc.exists) {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.toAccountSetup = true
                }
                print("User Does not exist")
            } else {
                UserDefaults.standard.set(number, forKey: "userNumber") //save number
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.toHomeScreen = true
                    self.log_status = true
                }
                print("User Details \(String(describing: doc.data()))")
            }
        } catch {
            handleError(error: error.localizedDescription)
        }
    }
    // MARK: Get Schools
    func getSchools() {
        //remove all schools
        user.schools.removeAll()
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
                        self.user.schools.append(schoolDataList)
                    }
                }
            }
        }
    }
    // MARK: Get Account Type (Not able to fetch!!!!!)
    func getAccountType() {
        db.collection("app_settings").whereField("account_types", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("Account Data is: \(document.documentID) => \(document.data())")
                    }
                }
        }
    }
    // MARK: SETUP ACCOUNT
    func setupAccount(number: String, user: User, school: [String]) async {
        do {
            print("Phone number At setup Account \(number)")
            isLoading = true
            let db = Firestore.firestore()
            let ref = db.collection("users").document(number)
            try await ref.setData([
                "accountType": user.accountType,
                "dateCreated": user.dateCreated,
                "email": user.email,
                "firstName": user.firstName,
                "lastName": user.lastName,
                "profilePic": user.profilePic,
                "schoolMap": ["LQvFVzvUTDLezBxaU90z" : false ],
                "enabled": false,
                "schools": school
            ])
            DispatchQueue.main.async {
                self.isLoading = false
                self.toHomeScreen = true
                self.log_status = true
                UserDefaults.standard.set(number, forKey: "userNumber") //save number
                //UserDefaults.standard.set(true, forKey: UserDefaults.Keys.allowDownloadsOverCellular.rawValue)
                UserDefaults.standard.set(true, forKey: "selectedSchool")
            }
        } catch {
            handleError(error: error.localizedDescription)
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
