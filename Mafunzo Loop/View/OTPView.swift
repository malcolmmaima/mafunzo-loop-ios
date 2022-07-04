//
//  OTPView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 04/07/2022.
//

import SwiftUI

struct OTPView: View {
    @EnvironmentObject var otpViewModel: OTPViewModel
    @FocusState var activeField: OTPField?
    var body: some View {
        GeometryReader { geo in
            VStack {
                // MARK: - TOP VIEW
                TopView()
                    .frame(height: geo.size.height * 0.5, alignment: .top)
                // MARK: - BOTTOM View
                VStack {
                    Text("Enter OTP to Verify your Number")
                        .font(.title2)
                        .padding(.top, 10)
                    // MARK: OTP TEXT FIELD
                    OTPField()
                        .padding(.top, 10)
                    // MARK: VERIFY Button
                    Button {
                        Task {
                          await otpViewModel.verifyOTP()
                        }
                    } label: {
                        Text("Verify")
                            .padding()
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.blue).opacity(otpViewModel.isLoading ? 0 : 1)
                    .overlay {
                        ProgressView()
                            .opacity(otpViewModel.isLoading ? 1 : 0)
                    }
                    .cornerRadius(5)
                    .padding(.top, 20)
                    .disabled(checkStatus())
                    .opacity(checkStatus() ? 0.4 : 1)
                    Text("Did not receive OTP?")
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                        //.underline()
                        .padding(.top, 20)
                    // MARK: RESEND OTP
                    Button {
                        //TO-DO (RESEND OTP)
                        print("")
                    } label: {
                        Text("Resend OTP CODE")
                            .fontWeight(.medium)
                            .underline()
                            .padding(.top, 10)
                    }
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .onChange(of: otpViewModel.otpFields) { newValue in
                    OTPCondition(value: newValue)
                }
                // MARK: Curving view
                    .background(
                        RoundedCornersShape(corners: .allCorners, radius: 39)
                            .fill(Color.ViewBackground)
                    )
                    .offset(y: -50)
            }
            .onTapGesture {
                self.hideKeyboard()
            }
            .alert(otpViewModel.errorMsg, isPresented: $otpViewModel.showAlert) {}
        }
    }
    // MARK: Check Button Status
    func checkStatus() -> Bool {
        for index in 0..<6 {
            if otpViewModel.otpFields[index].isEmpty {
                return true
            }
        }
        return false
    }
    // MARK: OTP Condition
    func OTPCondition(value: [String]) {
        //check if OTP is Pressed
        for index in 0..<6 {
            if value[index].count == 6 {
                DispatchQueue.main.async {
                    otpViewModel.otpText = value[index]
                    otpViewModel.otpFields[index] = ""
                    //update all TextField with the sms value
                    for item in otpViewModel.otpText.enumerated() {
                        otpViewModel.otpFields[item.offset] = String(item.element)
                    }
                }
                return
            }
        }
        //moving to the next TextField
        for index in 0..<5 {
            if value[index].count == 1 && activeStateForIndex(index: index) == activeField {
                activeField = activeStateForIndex(index: index + 1)
            }
        }
        //move to previous TextField
        for index in 1...5 {
            if value[index].isEmpty && !value[index - 1].isEmpty {
                activeField = activeStateForIndex(index: index - 1)
            }
        }
        //limit TextField to 1 value
        for index in 0..<6 {
            if value[index].count > 1 {
                otpViewModel.otpFields[index] = String(value[index].last!)
            }
        }
    }
    // MARK: OTP Text Field
    @ViewBuilder
    func OTPField() -> some View {
        HStack (spacing: 16) {
            ForEach(0..<6,id: \.self) { index in
                VStack(spacing: 8) {
                    TextField("", text: $otpViewModel.otpFields[index])
                        .vCodeStyle()
                        .focused($activeField,equals: activeStateForIndex(index: index))
                }
                .frame(width: 40)
            }
        }
    }
    // MARK: TextField Status
    func activeStateForIndex(index: Int)-> OTPField {
        switch index {
        case 0: return .field1
        case 1: return .field2
        case 2: return .field3
        case 3: return .field4
        case 4: return .field5
        default: return .field6
        }
    }
}

struct OTP_View_Previews: PreviewProvider {
    static var previews: some View {
        OTPView()
    }
}

enum OTPField {
    case field1
    case field2
    case field3
    case field4
    case field5
    case field6
}
