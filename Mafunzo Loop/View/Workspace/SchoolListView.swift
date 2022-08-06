//
//  SchoolListView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 06/08/2022.
//

import SwiftUI

struct SchoolListView: View {
    @StateObject var schoolViewModel = SchoolViewModel()
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
                        }.listRowBackground(Color.ViewBackground)
                    }.listStyle(.plain)
                    .searchable(text: $schoolViewModel.searchSchool, prompt: "Search School")
                    .refreshable {
                        schoolViewModel.getALLSchools()
                    }
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
        .navigationBarTitle(Text("Schools"), displayMode: .inline)
    }
}

struct SchoolListView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolListView()
    }
}
