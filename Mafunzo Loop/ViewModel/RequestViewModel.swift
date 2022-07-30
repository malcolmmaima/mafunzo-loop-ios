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
    //Model
    @Published var requestSelected = 0
    @Published var request: Request = .init()
    @Published var requestFetch = [RequestDecoder]()
    @Published var request_type = Request_Types(types: [])
    //Firebase
    let db = Firestore.firestore()
    init() {
        getAccountTypes()
    }
    
    //MARK: Get Account Types
    func getAccountTypes() {
            let ref = db.collection("app_settings").document(" request_types")
        ref.getDocument(source: .default) { document, error in
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
    
    //MARK: Submit Request
    func submitRequest(request: Request) async {
        do {
            isLoading = true
            let schoolStored = UserDefaults.standard.string(forKey: "schoolID") ?? ""
            let userSavedNumber = UserDefaults.standard.string(forKey: "userNumber") ?? ""
            let userNumber = String(describing: userSavedNumber)
            let schoolID = String(describing: schoolStored)
            if schoolID != "" {
                let ref = db.collection("requests").document(schoolID).collection(userNumber).document()
                try await ref.setData([
                    "createdAt": request.createdAt,
                    "id": ref.documentID, // auto generated Document ID
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
    
    // MARK: Get ALL Requests
    func getRequests() {
        isLoading = true
      requestFetch.removeAll()
        let schoolStored = UserDefaults.standard.string(forKey: "schoolID") ?? ""
        let userSavedNumber = UserDefaults.standard.string(forKey: "userNumber") ?? ""
        let userNumber = String(describing: userSavedNumber)
        let schoolID = String(describing: schoolStored)
        
        if schoolID != "" {
            let requestRef = db.collection("requests").document(schoolID).collection(userNumber).order(by: "createdAt", descending: true).limit(to: 3)
            requestRef.getDocuments(source: .default) { requestDoc, error in
                guard error == nil else {
                    print("Error!! \(error!.localizedDescription)")
                    return
                }
                if let results = requestDoc {
                    for document in results.documents {
                        if document == document {
                            let data = document.data()
                            let id = data["id"] as? String ?? ""
                            let createdAt = data["createdAt"] as? Int ?? 0
                            let message = data["message"] as? String ?? ""
                            let status = data["status"] as? String ?? ""
                            let subject = data["subject"] as? String ?? ""
                            let type = data["type"] as? String ?? ""
                        
                            let statusRawValue = RequestStatus(rawValue: status) // Pass status String as a RequestStatus raw Value
                            let requestData = RequestDecoder(createdAt: createdAt, id: id, message: message, status: statusRawValue!, subject: subject, type: type)
                            self.requestFetch.append(requestData) //Add all Requests to [RequestDecoder]
                            self.isLoading = false
                        }
                    }
                }
            }
        }
    }
    
    func getAllRequests() {
        isLoading = true
      requestFetch.removeAll()
        let schoolStored = UserDefaults.standard.string(forKey: "schoolID") ?? ""
        let userSavedNumber = UserDefaults.standard.string(forKey: "userNumber") ?? ""
        let userNumber = String(describing: userSavedNumber)
        let schoolID = String(describing: schoolStored)
        
        if schoolID != "" {
            let requestRef = db.collection("requests").document(schoolID).collection(userNumber).order(by: "createdAt", descending: true)
            requestRef.getDocuments(source: .default) { requestDoc, error in
                guard error == nil else {
                    print("Error!! \(error!.localizedDescription)")
                    return
                }
                if let results = requestDoc {
                    for document in results.documents {
                        if document == document {
                            let data = document.data()
                            let id = data["id"] as? String ?? ""
                            let createdAt = data["createdAt"] as? Int ?? 0
                            let message = data["message"] as? String ?? ""
                            let status = data["status"] as? String ?? ""
                            let subject = data["subject"] as? String ?? ""
                            let type = data["type"] as? String ?? ""
                        
                            let statusRawValue = RequestStatus(rawValue: status) // Pass status String as a RequestStatus raw Value
                            let requestData = RequestDecoder(createdAt: createdAt, id: id, message: message, status: statusRawValue!, subject: subject, type: type)
                                self.requestFetch.append(requestData)
                            self.isLoading = false
                        }
                    }
                }
            }
        }
    }
}
