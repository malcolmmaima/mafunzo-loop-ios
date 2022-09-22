//
//  SchoolListView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 06/08/2022.
//

import SwiftUI
import AlertToast

struct SchoolListView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var schoolViewModel = SchoolViewModel()
    @State private var addSchoolAlert: Bool = false
    @State var selectedSchool = ""
    @State var schoolid = ""
    var body: some View {
        GeometryReader { geo in
            VStack {
                NavigationTopView()
                    .frame(height: geo.size.height * 0.1)
                bottomView
            }
        }
        
         // MARK: Add School
        .alert(isPresented: $addSchoolAlert) {
            Alert(title: Text("Add School"),
                  message: Text("Are you sure you want to add \(selectedSchool) ?"),
                  primaryButton: .default(Text("Yes"), action: {
                    Task {
                        await schoolViewModel.addSchool(selected: schoolid)
                    }
                    dismiss()
                    }),
                  secondaryButton: .destructive(Text("No")))
        }
        .toast(isPresenting: $schoolViewModel.showAlertToast, duration: 2.0) {
            return AlertToast(type: .systemImage("checkmark", Color.blue), title: "School added to your Workspace ")
        }
        .navigationBarTitle(Text("Schools"), displayMode: .inline)
    }

}

struct SchoolListView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolListView()
    }
}


private extension SchoolListView {
    // MARK: -Bottom VIew
    var bottomView: some View {
        VStack {
            schools
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(
            RoundedCornersShape(corners: .allCorners, radius: 40)
                .fill(Color.ViewBackground)
        )
        .offset(y: -55)
    }
    
    // MARK: Schools
    var schools: some View {
        List {
            ForEach(schoolViewModel.schoolSearch, id: \.id) { school in
                SchoolListViewCell(schoolName: school.schoolName, schoolLocation: school.schoolLocation)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        addSchoolAlert = true
                        selectedSchool = school.schoolName
                        schoolid = school.id
                    }
            }.listRowBackground(Color.ViewBackground)
        }.listStyle(.plain)
        .searchable(text: $schoolViewModel.searchSchool, prompt: "Search School")
        .refreshable {
            schoolViewModel.getALLSchools()
        }
        .padding(.top, 10)
    }
}
