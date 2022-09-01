//
//  TopView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 04/07/2022.
//

import SwiftUI

// MARK: TOP IMAGE VIEW
struct TopView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image("black_student_happy")
                .resizable()
                .edgesIgnoringSafeArea(.top)
        }.background(.yellow).opacity(0.9)
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
