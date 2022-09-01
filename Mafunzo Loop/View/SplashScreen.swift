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
    @StateObject var systemSettingsViewModel = SystemSettingsViewModel()
    var body: some View {
        if isActive {
            if systemSettingsViewModel.systemStatus == true {
                SystemOfflineView()
            } else {
                ContentView()
            }
        } else {
            VStack {
                VStack {
                    Image("app_log")
                        .resizable()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black.opacity(0.1),lineWidth:4)
                            .shadow(color: Color.gray, radius: 5, x: -2, y: 0))
                        .mask(Circle().padding(.leading, -30))
                        .frame(width: 200, height: 200, alignment: .center)
                        .padding(.top, 20)
                    Spacer()
                    VStack {
                        Image("black_student_happy")
                            .resizable()
                            .padding(.top, 50)
                            ProgressView()
                                .scaleEffect(2)
                                .font(.system(size: 8))
                                .padding()
                                .padding(.bottom, 10)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                    }.frame(alignment: .bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.yellow).opacity(0.9)
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
