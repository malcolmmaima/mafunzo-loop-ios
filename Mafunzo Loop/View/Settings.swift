//
//  Settings.swift
//  Mafunzo Loop
//
//  Created by Mroot on 01/08/2022.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        GeometryReader { geo in
            VStack {
                NavigationTopView()
                    .frame(height: geo.size.height * 0.1)
                VStack {
                    Form {
                        Section {
                            TextField("First Name", text: $userViewModel.user.firstName)
                                .textFieldStyling()
                            TextField("Second Name", text: $userViewModel.user.lastName)
                                .textFieldStyling()
                                .padding(.top, 40)
                            TextField("Email Address", text: $userViewModel.user.email)
                                .textFieldStyling()
                                .padding(.top, 40)
//                            Picker(selection: $otpViewModel.accountSelected, label: Text("Account Type")) {
//                                ForEach(0 ..< otpViewModel.accountType.count) {
//                                    Text(self.otpViewModel.accountType[$0])
//                                }
//                            }
//                            .textFieldStyling()

                        }
                        //.padding()
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        Section {
                            Button {
//                                Task {
//                                   await createAccount()
//                                }
                            } label: {
                                Text("Update")
                                    .foregroundColor(.white)
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                            }
                            .background(Color.blue).opacity(userViewModel.isLoading ? 0 : 1)
                            .overlay {
                                ProgressView()
                                    .opacity(userViewModel.isLoading ? 1 : 0)
                            }
                            .cornerRadius(5)
                            .padding(.top, 40)
//                            .disabled(checkTexts())
//                            .opacity(checkTexts() ? 0.4 : 1)
                        }
                        .padding()
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(InsetGroupedListStyle())
                    .onAppear(perform: {
                        UITableView.appearance().backgroundColor = UIColor.clear
                        UITableViewCell.appearance().backgroundColor = UIColor.clear
                    })
                }
                .padding()
                .background(
                    RoundedCornersShape(corners: .allCorners, radius: 40)
                        .fill(Color.ViewBackground)
                )
                .offset(y: -55)
            }
        }
        .navigationBarTitle(Text("Settings"), displayMode: .inline)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
