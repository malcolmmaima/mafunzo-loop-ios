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
            ZStack {
                VStack {
                    NavigationTopView()
                        .frame(height: geo.size.height * 0.09)
                    VStack {
                        List {
                            ForEach(requestViewModel.requestFetch, id: \.id) {
                                request in
                                NavigationLink(destination: RequestViewInfo(status: request.status, requestInfo: request)) {
                                    RequestListViewCell(requestTitle: request.subject, requestStatus: request.status, createdDate: request.createdAt)
                                }
                                .listRowSeparator(.hidden)
                            }.listRowBackground(Color.ViewBackground)
                        }.listStyle(.plain)
                        .padding(.top, 25)
                        .refreshable {
                            requestViewModel.getAllRequests()
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
                Text("No Requests")
                    .opacity(requestViewModel.noRequest ? 1 : 0)
            }
            .overlay {
                ProgressView()
                    .opacity(requestViewModel.isLoading ? 1 : 0)
                    .font(.system(size: 2))
                    .padding()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.yellow))
            }
        }.onAppear {
            requestViewModel.getAllRequests()
        }
        .navigationBarTitle(Text("My Requests"), displayMode: .inline)
        .alert(requestViewModel.errorMsg, isPresented: $requestViewModel.showAlert) {}
    }
}

struct RequestListView_Previews: PreviewProvider {
    static var previews: some View {
        RequestListView()
    }
}
