//
//  SchoolListView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 06/08/2022.
//

import SwiftUI

struct SchoolListView: View {
    @StateObject var schoolViewModel = SchoolViewModel()
    @State private var addSchoolAlert: Bool = false
    @State var selectedSchool = ""
    @State var schoolid = ""
    var body: some View {
        GeometryReader { geo in
            VStack {
                NavigationTopView()
                    .frame(height: geo.size.height * 0.1)
                VStack {
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
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(
                    RoundedCornersShape(corners: .allCorners, radius: 40)
                        .fill(Color.ViewBackground)
                )
                .offset(y: -55)
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
                    }),
                  secondaryButton: .destructive(Text("No")))
        }
        .navigationBarTitle(Text("Schools"), displayMode: .inline)
    }

}

struct SchoolListView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolListView()
    }
}
