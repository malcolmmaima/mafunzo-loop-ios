//
//  RequestListView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 30/07/2022.
//

import SwiftUI

struct RequestListView: View {
    @StateObject var requestViewModel = RequestViewModel()
    var body: some View {
        GeometryReader { geo in
            VStack {
                AnnoucementTopView()
                    .frame(height: geo.size.height * 0.09)
                VStack {
                    
                    List {
                        ForEach(requestViewModel.requestFetch, id: \.id) {
                            request in
                            RequestListViewCell(requestTitle: request.subject, requestStatus: request.status, createdDate: request.createdAt)
                                .listRowSeparator(.hidden)
                        }.listRowBackground(Color.ViewBackground)
                    }.listStyle(.plain)
                    .padding(.top, 25)
                    .refreshable {
                        requestViewModel.getRequests()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedCornersShape(corners: .allCorners, radius: 40)
                        .fill(Color.ViewBackground)
                )
                .offset(y: -55)
            }
        }
        .navigationBarTitle(Text("My Requests"), displayMode: .inline)
    }
}

struct RequestListView_Previews: PreviewProvider {
    static var previews: some View {
        RequestListView()
    }
}
