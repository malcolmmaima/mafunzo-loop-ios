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
    //OTP
    @Published var otpText: String = ""
    @Published var otpFields: [String] = Array(repeating: "", count: 6)
    @Published var countryCode = ""
    @Published var accountType = ["PARENT", "TEACHER", "STUDENT", "BUS_DRIVER"]
    @Published var accountSelected = 0
    @Published var schoolSelected = 0
    // VIEWS
    @Published var toAccountSetup = false
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
        //getAccountType()
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
    func verifyOTP() async {
        do {
            isLoading = true
            otpText = otpFields.reduce("") { partialResult, value in
                partialResult + value
            }
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationCode, verificationCode: otpText)
            _ = try await Auth.auth().signIn(with: credential)
            DispatchQueue.main.async {[self] in
                isLoading = false
                toAccountSetup = true
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
                    let data = document.data()
                    let schoolDetails = data["schoolName"] as? String ?? ""
                    self.user.schools.append(schoolDetails)
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
    func setupAccount(number: String, user: User, school: [String]) {
            print("Phone number At setup Account \(number)")
            isLoading = true
            let db = Firestore.firestore()
            let ref = db.collection("users").document(number)
            ref.setData([
                "accountType": user.accountType,
                "dateCreated": user.dateCreated,
                "email": user.email,
                "firstName": user.firstName,
                "lastName": user.lastName,
                "profilePic": user.profilePic,
                "schools": school
            ]) { error in
                if let error = error {
                    self.handleError(error: error.localizedDescription)
                    print(error.localizedDescription)
                }
            }
        DispatchQueue.main.async {[self] in
            isLoading = false
            log_status = true
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
