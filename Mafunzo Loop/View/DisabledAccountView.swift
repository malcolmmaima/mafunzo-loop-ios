//
//  DisabledAccountView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 05/08/2022.
//

import SwiftUI
import Firebase

struct DisabledAccountView: View {
    var body: some View {
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
                print("")
            } label: {
                Text("Logout")
                    
            }
            .frame(alignment: .bottom)
            .padding()
            .padding(.bottom, 50)
        }
    }
}

struct DisabledAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DisabledAccountView()
    }
}
