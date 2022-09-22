//
//  AccountSetupView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 05/07/2022.
//

import SwiftUI
import AlertToast

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
                  setupTopView
                        .frame(height: geo.size.height * 0.19)
                    VStack {
                        title
                        form
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
                .toast(isPresenting: $otpViewModel.showAlertToast, duration: 5.0) {
                    return AlertToast(type: .systemImage("checkmark", Color.blue), title: "\(otpViewModel.user.firstName),  Welcome to Mafunzo")
                }
                .fullScreenCover(isPresented: $otpViewModel.toHomeScreen) {
                    HomeView(user: User())
                }
            }
          .alert(otpViewModel.errorMsg, isPresented: $otpViewModel.showAlert) {}
       }
    }
    // selected items
    func itemSelected() {
        //Passing item category
        let accountTypeSelected = otpViewModel.account_Types.users[otpViewModel.accountSelected]
        user.firstName = otpViewModel.user.firstName
        user.lastName = otpViewModel.user.lastName
        user.email = otpViewModel.user.email
        user.accountType = accountTypeSelected
    }

    func createAccount() async {
        //current time
        let currentTime = Date.now
        let currentTimeMillisecond = currentTime.millisecondsSince1970
        // school selected
        let schoolSelected = otpViewModel.user.schools[otpViewModel.schoolSelected].id
        let school = schoolSelected
        itemSelected()
        let dateCreated = Int(currentTimeMillisecond)
        user.dateCreated = dateCreated
        await otpViewModel.setupAccount(number: number, user: user, school: school)
    }
    // MARK: Check Textfield status
    func checkTexts() -> Bool {
        if otpViewModel.user.firstName == "" || otpViewModel.user.lastName == "" || otpViewModel.user.email == "" {
            return true
        }
        return false
    }
}


struct AccountSetupView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSetupView(number: "", user: User())
    }
}

private extension AccountSetupView {
    // MARK: -TOP VIEW
    var setupTopView: some View {
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
    
    // MARK: -Form
    var form: some View {
        VStack {
            Form {
                Section {
                    Group {
                        firstName
                        lastName
                        email
                        account
                        school
                    }
                    .textFieldStyling()
                }.padding()
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                Section {
                    next
                }
                .padding()
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    // MARK: title
    var title: some View {
        VStack {
            Text("Welcome to Mafunzo Loop")
            Text("Please setup your account")
        }.font(.title3)
        .padding(.top, 30)
    }
    
    // MARK: first name
    var firstName: some View {
        TextField("First Name", text: $otpViewModel.user.firstName)
    }
    
    // MARK: last name
    var lastName: some View {
        TextField("Second Name", text: $otpViewModel.user.lastName)
    }
    
    // MARK: email
    var email: some View {
        TextField("Email Address", text: $otpViewModel.user.email)
    }
    
    // MARK: account
    var account: some View {
        Picker(selection: $otpViewModel.accountSelected, label: Text("Account Type")) {
            ForEach(0 ..< otpViewModel.account_Types.users.count, id: \.self) {
                Text("\(self.otpViewModel.account_Types.users[$0])")
            }
        }
    }
    
    // MARK: school
    var school: some View {
        Picker(selection: $otpViewModel.schoolSelected, label: Text("School")) {
            ForEach(0 ..< otpViewModel.user.schools.count, id: \.self) {
                Text("\(self.otpViewModel.user.schools[$0].schoolName)")
            }
        }
    }
    
    // MARK: create account
    var next: some View {
        Button {
            Task {
               await createAccount()
            }
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
}
