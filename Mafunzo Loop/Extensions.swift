//
//  Extensions.swift
//  Mafunzo Loop
//
//  Created by mroot on 01/07/2022.
//

import Foundation
import SwiftUI

//View Shape - Verification Views
struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
//Standard Button Color from Assets
extension Color {
    static let ViewBackground = Color("ViewColor")
    static let textLineColor = Color("textLineColor")
}
//MARK: -Verification Code Text Styling
struct CodeTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 50, height: 50)
            .background(Color.gray).opacity(0.5)
            .multilineTextAlignment(.center)
            .cornerRadius(10)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
    }
}
extension View {
    func vCodeStyle() -> some View {
        modifier(CodeTextStyle())
    }
}
// MARK: Hide Keyboard
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
