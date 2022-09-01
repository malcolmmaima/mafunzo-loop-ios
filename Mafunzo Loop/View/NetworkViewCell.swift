//
//  NetworkViewCell.swift
//  Mafunzo Loop
//
//  Created by Mroot on 18/08/2022.
//

import SwiftUI

struct NetworkViewCell: View {
    let netStatus: String
    let image: String
    var body: some View {
        HStack {
           Text(netStatus)
               .padding()
           Image(systemName: image)
           Spacer()
        }
        .frame(height: 30)
       .background(Color.red)
    }
}

struct NetworkViewCell_Previews: PreviewProvider {
    static var previews: some View {
        NetworkViewCell(netStatus: "No internet", image: "")
    }
}
