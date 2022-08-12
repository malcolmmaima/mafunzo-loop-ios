//
//  DisabledAccountView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 05/08/2022.
//

import SwiftUI
import Firebase

struct DisabledAccountView: View {
    @State var logout: Bool = false
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Spacer()
                Image("disabled_account")
                    .resizable()
                    .frame(width: 150, height: 150)
                Text("Your Account has been disabled")
                    .bold()
                Text("Please contact support mafunzoloop@gmail.com.")
                    .font(.body)
                Spacer()
                Button {
                   Logout()
                } label: {
                    Text("Logout")
                }
                .frame(alignment: .bottom)
                .padding()
                .padding(.bottom, 50)
            }
            .fullScreenCover(isPresented: $logout) {
                    LoginView()
            }
        }
    }
    func Logout() {
            do {
                UserDefaults.standard.reset()
                @AppStorage("log_status") var log_status = true
                try Auth.auth().signOut()
                logout.toggle()
            } catch {
                print("already logged out")
            }
    }
}

struct DisabledAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DisabledAccountView()
    }
}
