//
//  RequestViewModel.swift
//  Mafunzo Loop
//
//  Created by Mroot on 28/07/2022.
//

import Foundation
import Firebase

class RequestViewModel: ObservableObject {
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg = ""
    @Published var verificationCode: String = ""
    //Status
    @Published var isLoading: Bool = false
    @Published var request: Request = .init()
    @Published var requestSelected = 0
//    @Published var request_type = [Request_Types]()
    @Published var request_type = Request_Types(types: [])
//    @Published var showAlert: Bool = false

    //Firebase
    let db = Firestore.firestore()
    
    init() {
         getAccountTypes()
    }
    
    //MARK : Get Account Types
    func getAccountTypes() {
        //remove all accounts
      //  request_type.removeAll()
            let ref = db.collection("app_settings").document(" request_types")
        ref.getDocument(source: .server) { document, error in
            if let document = document {
                let data = document.data()
                let requestTypesArray = data?["types"] as? [String] ?? []
                print("Requests \(requestTypesArray)")
                self.request_type.types = requestTypesArray
            } else {
                print(error?.localizedDescription ?? "No Data Found")
            }
        }
    }
    
    //MARK: Create Request
    func createRequest(request: Request) async {
        do {
            isLoading = true
            let schoolStored = UserDefaults.standard.string(forKey: "schoolID") ?? ""
            let schoolID = String(describing: schoolStored)
            print("Get School ID \(schoolID)")
            
            if schoolID != "" {
                let ref = db.collection("requests").document(schoolID).collection("+254790457258").document()
                try await ref.setData([
                    "createdAt": request.createdAt,
                    //"id": request.
                    "message": request.message,
                    "status": request.status,
                    "subject": request.subject,
                    "type": request.type
                ])
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        } catch {
            print("Error!! \(error.localizedDescription)")
        }
    }
}
