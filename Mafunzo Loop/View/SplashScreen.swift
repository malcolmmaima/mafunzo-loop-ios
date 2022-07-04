//
//  SplashScreen.swift
//  Mafunzo Loop
//
//  Created by Mroot on 04/07/2022.
//

import SwiftUI

struct SplashScreen: View {
    @State var isActive: Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    var body: some View {
        if isActive {
           ContentView()
        } else {
            VStack {
                VStack {
                    Image("mafunzo_round_logo")
                        .resizable()
                        .frame(width: 200, height: 200, alignment: .center)
                        .padding(.top, 20)
                    Spacer()
                    VStack {
                        Image("black_student_happy")
                            .resizable()
                            .padding(.top, 50)
                            ProgressView()
                                .scaleEffect(2)
                                .font(.system(size:8))
                                .padding()
                                .padding(.bottom, 10)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.yellow))
                    }.frame(alignment: .bottom)
                        
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.blue).opacity(0.9)
            } .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 ) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
