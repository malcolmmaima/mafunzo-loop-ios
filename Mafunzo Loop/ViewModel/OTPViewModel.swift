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
    @Published var user = User()
    //OTP
    @Published var otpText: String = ""
    @Published var otpFields: [String] = Array(repeating: "", count: 6)
    @Published var countryCode = ""
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg = ""
    @Published var verificationCode: String = ""
    //Status
    @Published var isLoading: Bool = false
    @Published var verificationTag: String?
    @AppStorage("log_status") var log_status = false
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
            let _ = try await Auth.auth().signIn(with: credential)
            DispatchQueue.main.async {[self] in
                isLoading = false
                log_status = true
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
