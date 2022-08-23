//
//  TeacherView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 30/07/2022.
//

import SwiftUI

struct TeacherView: View {
    var teacher: Teacher
    var body: some View {
        GeometryReader { geo in
            VStack {
                NavigationTopView()
                    .frame(height: geo.size.height * 0.1)
                VStack(alignment: .leading) {
                    HStack {
                        AsyncImage(url: URL(string: teacher.profilePic)) { image in
                             image.resizable()
                         } placeholder: {
                         Image(systemName: "person.circle.fill")
                         .resizable()
                         } .frame(width: 100, height: 100, alignment: .leading)
                        VStack(alignment: .leading) {
                            Text("\(teacher.firstName) \(teacher.lastName)")
                                .foregroundColor(Color.buttonHomeColor)
                            Text(teacher.subjects.joined(separator: ", "))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.blue)
                            Text(teacher.grades.joined(separator: ", "))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.green)
                        }
                        .frame(width: 200)
                    }
                    .padding()
                    .background(
                        RoundedCornersShape(corners: .allCorners, radius: 10)
                            .fill(Color.homeCategory)
                    )
                    .shadow(radius: 2.0)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Phone: \(teacher.phoneNumber)")
                                .foregroundColor(Color.buttonHomeColor)
                                .onTapGesture {
                                    callNumber()
                                }
                            Text("Email: \(teacher.emailAddress)")
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    sendEmail()
                                }
                            Text("Status: \(teacher.status)")
                                .foregroundColor(.green)
                        }
                        .padding(.top, 10)
                    }
                }
                .padding()
                .padding(.top, 20)
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(
                    RoundedCornersShape(corners: .allCorners, radius: 40)
                        .fill(Color.ViewBackground)
                )
                .offset(y: -55)
            }
        }
        .navigationBarTitle(Text("Teacher"), displayMode: .inline)
    }
    // MARK: Call Number Tapped
    private func callNumber() {
        let phone = "tel://"
        let phoneNumberformatted = phone + teacher.phoneNumber
        guard let url = URL(string: phoneNumberformatted) else { return }
        UIApplication.shared.open(url)
    }
    private func sendEmail() {
        let url = NSURL(string: "mailto:\(teacher.emailAddress)")
        UIApplication.shared.open(url! as URL)
    }
}

//struct TeacherView_Previews: PreviewProvider {
//    static var previews: some View {
//        TeacherView()
//    }
//}
