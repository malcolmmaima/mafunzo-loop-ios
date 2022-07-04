//
//  LoginView.swift
//  Mafunzo Loop
//
//  Created by mroot on 01/07/2022.
//

import SwiftUI

struct LoginView: View {
    @StateObject var otpViewModel = OTPViewModel()
    @ObservedObject private var countryDetails = CountryCodeViewModel()
    @State private var selectedCode = 113 //position of country-Kenya in [countryInfo]
    @State var number = ""
    @FocusState private var dismissKeyboard: Bool
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    // MARK: - Top View
                    TopView()
                        .frame(height: geo.size.height * 0.5, alignment: .top)
                    // MARK: - BOTTOM VIEW
                    VStack {
                        Text("Welcome to Mafunzo")
                            .font(.title)
                            .padding(.top, 10)
                        // MARK: Country Code
                        HStack {
                            Text("Select Country Code")
                                .font(.body)
                            Spacer()
                            Picker("Please choose a country Code", selection: $selectedCode) {
                                ForEach(0..<countryDetails.codeCountry.count, id: \.self) {
                                    Text("\(countryDetails.codeCountry[$0].flag) \(countryDetails.codeCountry[$0].name) \(countryDetails.codeCountry[$0].dialCode)")
                                }
                            }
                            .foregroundColor(.black)
                        }.frame(maxWidth: 350, maxHeight: 40)
                            .padding(.top, 20)
                        // MARK: Phone Number
                        TextField("Enter phone number", text: $number)
                            .frame(width: 350.0)
                            .multilineTextAlignment(.center)
                            .overlay(VStack {
                                Divider().frame(height: 2).background(Color.textLineColor).offset(x: 0, y: 15)
                            })
                            .padding(.top, 30)
                            .keyboardType(.numberPad)
                            .focused($dismissKeyboard)
                        // MARK: Login Button
                        Button(action: {
                            Task {
                                await logIn()
                            }
                        }, label: {
                            Text("Login")
                                 .accentColor(.white)
                                 .frame(width: 350, height: 50)
                        })
                        .background(Color.blue).opacity(otpViewModel.isLoading ? 0 : 1)
                        .overlay {
                            ProgressView()
                                .opacity(otpViewModel.isLoading ? 1 : 0)
                        }
                        .cornerRadius(5)
                        .padding(.top, 40)
                        .disabled(number == "")
                        .opacity(number == "" ? 0.4 : 1)
                    }
                   .padding()
                   .frame(minWidth: 0, maxWidth: .infinity)
                    // MARK: Curving view
                        .background(
                            RoundedCornersShape(corners: .allCorners, radius: 39)
                                .fill(Color.ViewBackground)
                        )
                        .offset(y: -50)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                dismissKeyboard = false
                            }
                        }
                    }
                }
            }
            .background {
                NavigationLink(tag: "VERIFICATION", selection: $otpViewModel.verificationTag) {
                    OTPView()
                        .environmentObject(otpViewModel)
                } label: {}
                    .labelsHidden()
            }
            .alert(otpViewModel.errorMsg, isPresented: $otpViewModel.showAlert) {}
        }
    }
    // MARK: LOGIN
    func logIn() async {
        let countryCodeSelect = countryDetails.codeCountry[selectedCode].dialCode
        //print("number: \(number)")
        let numberPlaced = Int(number) // removing the leading '0' by changing to Int
        //print("numberPlaced: \(numberPlaced!)")
        let numberConvert = "\(numberPlaced!)" //changing back to String
        let phoneNumber = countryCodeSelect + numberConvert
        //print(phoneNumber)
        await otpViewModel.sendOTP(phone: phoneNumber)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
       LoginView()
    }
}
