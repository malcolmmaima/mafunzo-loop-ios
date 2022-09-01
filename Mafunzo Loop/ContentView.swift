//
//  ContentView.swift
//  Mafunzo Loop
//
//  Created by mroot on 30/06/2022.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var log_status = false
    var body: some View {
        if log_status {
            // MARK: To Home View
            HomeView(user: User())
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
