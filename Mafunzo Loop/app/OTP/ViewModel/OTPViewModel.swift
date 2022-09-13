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
    @Published var account_Types = Account_Types(users: [])
    @Published var accountSelected = 0
    @Published var schoolSelected = 0
    // VIEWS
    @Published var toAccountSetup = false
    @Published var toHomeScreen = false
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg = ""
    @Published var verificationCode: String = ""
    @Published var showAlertToast: Bool = false
    //Status
    @Published var isLoading: Bool = false
    @Published var verificationTag: String?
    @AppStorage("log_status") var log_status = false
    //Firebase
    let db = Firestore.firestore()
    let userStatus = Auth.auth().currentUser
    //Initialze functions
   init() {
        if userStatus != nil {
            getSchools()
            getAccountType()
            print("Current user is \(String(describing: userStatus))")
        }
   }
    // MARK: Send OTP
    @MainActor
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
    @MainActor
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
        let ref = db.collection("app_settings").document("account_types")
        ref.getDocument(source: .default) { document, error in
            if let document = document {
                let accountData = document.data()
                let accountsArray = accountData?["users"] as? [String] ?? []
                print("Account Types \(accountsArray)")
                self.account_Types.users = accountsArray
            } else {
                print(error?.localizedDescription ?? "No Data Found")
            }
        }
    }
    // MARK: SETUP ACCOUNT
    @MainActor
    func setupAccount(number: String, user: User, school: String) async {
        do {
            print("Phone number At setup Account \(number)")
            isLoading = true
            let db = Firestore.firestore()
            let ref = db.collection("users").document(number)
            try await ref.setData([
                "accountType": user.accountType,
                "dateCreated": user.dateCreated,
                "email": user.email,
                "phone": number,
                "firstName": user.firstName,
                "lastName": user.lastName,
                "profilePic": user.profilePic,
                "schools": [school : false ],
                "enabled": true,
            ])
            DispatchQueue.main.async {
                self.isLoading = false
                self.showAlertToast = true
                self.toHomeScreen = true
                self.log_status = true
                UserDefaults.standard.set(number, forKey: "userNumber") //save number
                UserDefaults.standard.set(school, forKey: "schoolID") //save school ID
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
