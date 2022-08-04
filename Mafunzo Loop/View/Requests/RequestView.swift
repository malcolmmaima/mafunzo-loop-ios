//
//  RequestView.swift
//  Mafunzo Loop
//
//  Created by Mroot on 28/07/2022.
//
import SwiftUI

struct RequestView: View {
    @StateObject var requestViewModel = RequestViewModel()
    @ObservedObject var request: Request
    var body: some View {
        GeometryReader { geo in
            VStack {
                NavigationTopView()
                    .frame(height: geo.size.height * 0.1)
                VStack {
                    Form {
                        Section {
                            Picker(selection: $requestViewModel.requestSelected, label: Text("Select Request Type")) {
                                ForEach(0..<requestViewModel.request_type.types.count, id: \.self) {
                                    Text("\(self.requestViewModel.request_type.types[$0])")
                               }
                            }
                            TextField("Request Subject", text: $requestViewModel.request.subject)
                                .textFieldStyling()
                            TextField("Request Description", text: $requestViewModel.request.message)
                                .textFieldStyling()
                        }
                        .padding(.bottom, 25)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        Section {
                            Button {
                                Task {
                                   await submitRequest()
                                }
                            } label: {
                                Text("Submit")
                                    .foregroundColor(.white)
                                    .frame(height: 40)
                                    .frame(maxWidth: .infinity)
                            }
                            .background(Color.blue).opacity(requestViewModel.isLoading ? 0 : 1)
                            .overlay {
                                ProgressView()
                                    .opacity(requestViewModel.isLoading ? 1 : 0)
                            }
                            .disabled(requestViewModel.request.subject == "" && requestViewModel.request.message == "")
                            .opacity(requestViewModel.request.subject == "" && requestViewModel.request.message == "" ? 0.4 : 1)
                            .cornerRadius(5)
                        }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .frame(height: geo.size.height * 0.53)
                    .listStyle(InsetGroupedListStyle())
                    .onAppear(perform: {
                        UITableView.appearance().backgroundColor = UIColor.clear
                        UITableViewCell.appearance().backgroundColor = UIColor.clear
                    })
                    NavigationLink {
                        RequestListView()
                    } label: {
                        Text("View all requests")
                            .foregroundColor(.blue)
                            .font(.body)
                    }
                    ZStack {
                        List {
                            ForEach(requestViewModel.requestFetch, id: \.id) {
                                request in
                                NavigationLink(destination: RequestViewInfo(status: request.status, requestInfo: request)) {
                                    RequestListViewCell(requestTitle: request.subject, requestStatus: request.status, createdDate: request.createdAt)
                                }
                                .listRowSeparator(.hidden)
                            }.listRowBackground(Color.ViewBackground)
                        }
                        .listStyle(.plain)
                        
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
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(
                    RoundedCornersShape(corners: .allCorners, radius: 40)
                        .fill(Color.ViewBackground)
                )
                .offset(y: -55)
            }
        }.onAppear {
            requestViewModel.getRequests()
        }
        .navigationBarTitle(Text("Requests"), displayMode: .inline)
    }
    //Request Types
    func submitRequest() async {
        let requestType = requestViewModel.request_type.types[requestViewModel.requestSelected]
        print("Selected Type \(requestType)")
        request.subject = requestViewModel.request.subject
        request.type = requestType
        request.message = requestViewModel.request.message
        request.createdAt = generateCurrentTimeStamp()
        
        await requestViewModel.submitRequest(request: request)
    }
    //TimeStamp
    func generateCurrentTimeStamp () -> Int {
        let currentTime = Date.now
        let dateToMilliseconds = currentTime.millisecondsSince1970
        let timeStamp = Int(dateToMilliseconds)
        return timeStamp
    }
}

struct RequestView_Previews: PreviewProvider {
    static var previews: some View {
        RequestView(request: Request())
    }
}
