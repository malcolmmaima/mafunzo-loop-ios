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

extension UserDefaults {
    enum Keys: String, CaseIterable {
        case schoolID
        case userNumber
        case log_status
//        case userSchoolIDs
//        case schoolsMappedDB
    }
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
}



struct BorderedCaption: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 13, weight: .bold, design: .default))
            .padding(10)
            .frame(width: 100)
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(20)
    }
}

extension View {
    func borderedCaption() -> some View {
        modifier(BorderedCaption())
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
