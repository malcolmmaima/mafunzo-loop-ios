//
//  Test.swift
//  Mafunzo Loop
//
//  Created by Mroot on 04/08/2022.
//

import SwiftUI

struct Test: View {
    @ObservedObject var user: User
    @StateObject var userViewModel = UserViewModel()
    var body: some View {
        VStack {
            let _ = print("Test on Screen \(userViewModel.name)")
            Text(user.firstName)
        }.onAppear {
            userViewModel.getUserDetails()
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test(user: User())
    }
}
