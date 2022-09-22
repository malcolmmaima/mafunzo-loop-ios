//
//  DBStatusView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 12/08/2022.
//

import SwiftUI

struct SystemOfflineView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("system_offline")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
            Text("Mafunzo is currenty offline for maintainance. Please try again later")
                .bold()
                .font(.title2)
                .padding()
                .multilineTextAlignment(.center)
                
        }
    }
}

struct DBStatusView_Previews: PreviewProvider {
    static var previews: some View {
        SystemOfflineView()
    }
}
