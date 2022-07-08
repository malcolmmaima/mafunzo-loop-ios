//
//  AccountSetupView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 05/07/2022.
//

import SwiftUI

struct AccountSetupView: View {
    init(number: String, user: User) {
        UITableView.appearance().backgroundColor = UIColor.clear
            self.number = number
            self.user = user
        }
    @EnvironmentObject var otpViewModel: OTPViewModel
    @ObservedObject var user: User
    @State var number: String
    var body: some View {
      NavigationView {
            GeometryReader { geo in
                VStack {
                    setupTopView()
                        .frame(height: geo.size.height * 0.19)
                    VStack {
                        VStack {
                            Text("Welcome to Mafunzo Loop")
                            Text("Please setup your account")
                        }.font(.title3)
                            .padding(.top, 30)
                    // MARK: Text Field
                        VStack {
                            Form {
                                Section {
                                    TextField("First Name", text: $otpViewModel.user.firstName)
                                        .textFieldStyling()
                                    TextField("Second Name", text: $otpViewModel.user.lastName)
                                        .textFieldStyling()
                                    TextField("Email Address", text: $otpViewModel.user.email)
                                        .textFieldStyling()
                                    Picker(selection: $otpViewModel.accountSelected, label: Text("Account Type")) {
                                        ForEach(0 ..< otpViewModel.accountType.count) {
                                            Text(self.otpViewModel.accountType[$0])
                                        }
                                    }
                                    .textFieldStyling()
                                    Picker(selection: $otpViewModel.schoolSelected, label: Text("School")) {
                                        ForEach(0 ..< otpViewModel.user.schools.count) {
                                            Text(self.otpViewModel.user.schools[$0])
                                        }
                                    }
                                    .textFieldStyling()
                                }.padding()
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                Section {
                                    Button {
                                             createAccount()
                                    } label: {
                                        Text("Next")
                                            .foregroundColor(.white)
                                            .frame(height: 50)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .background(Color.blue).opacity(otpViewModel.isLoading ? 0 : 1)
                                    .overlay {
                                        ProgressView()
                                            .opacity(otpViewModel.isLoading ? 1 : 0)
                                    }
                                    .cornerRadius(5)
                                    .padding(.top, 40)
                                    .disabled(checkTexts())
                                    .opacity(checkTexts() ? 0.4 : 1)
                                }
                                .padding()
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(InsetGroupedListStyle())
                        }
                    }
                        .frame(minWidth: 0, maxWidth: .infinity)
                            .navigationBarHidden(true)
                     // MARK: Curving view
                         .background(
                             RoundedCornersShape(corners: .allCorners, radius: 39)
                                 .fill(Color.ViewBackground)
                         )
                         .offset(y: -55)
                }
            }
       }
    }
    // selected items
    func itemSelected() {
        //Passing item category
        let accountTypeSelected = otpViewModel.accountType[otpViewModel.accountSelected]
        user.firstName = otpViewModel.user.firstName
        user.lastName = otpViewModel.user.lastName
        user.email = otpViewModel.user.email
        user.accountType = accountTypeSelected
    }
    //TimeStamp
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddhhmmss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    func createAccount() {
        let schoolSelected = otpViewModel.user.schools[otpViewModel.schoolSelected]
        let school = [schoolSelected]
        itemSelected()
        let dateCreated = Int(generateCurrentTimeStamp()) ?? 0
        user.dateCreated = dateCreated
        otpViewModel.setupAccount(number: number, user: user, school: school)
    }
    // MARK: Check Textfield status
    func checkTexts() -> Bool {
        if otpViewModel.user.firstName == "" || otpViewModel.user.lastName == "" || otpViewModel.user.email == "" {
            return true
        }
        return false
    }
}
// MARK: TOP VIEW
struct setupTopView: View {
    var body: some View {
        VStack {
            Text("Setup Account")
                .foregroundColor(.white)
                .font(.title2)
                .bold()
                .padding(.top, 30)
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
    }
}
struct AccountSetupView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSetupView(number: "", user: User())
    }
}
