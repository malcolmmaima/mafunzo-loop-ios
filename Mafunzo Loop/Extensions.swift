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
    static let homeCategory = Color("homeCategory")
    static let buttonHomeColor = Color("ButtonTextHome")
}
// MARK: Verification Code Text Styling
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
// MARK: Text Field Styling
struct TextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
        .frame(maxWidth: .infinity)
        .overlay(VStack{Divider().frame(height: 2).background(Color.textLineColor).offset(x: 0, y: 15)})
    }
}
extension View {
    func textFieldStyling() -> some View {
        modifier(TextFieldStyle())
    }
}
// MARK: DATE
extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0))
    }
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
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
