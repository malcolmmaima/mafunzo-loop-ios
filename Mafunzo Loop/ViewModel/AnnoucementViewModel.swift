//
//  AnnoucementViewModel.swift
//  Mafunzo Loop
//
//  Created by Mroot on 18/07/2022.
//

import Foundation
import Firebase

class AnnoucementViewModel: ObservableObject {
    @Published var announcements: [Annoucements] = []
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg = ""
    @Published var verificationCode: String = ""
    //Status
    @Published var isLoading: Bool = false
    //Firebase
    let db = Firestore.firestore()
    init() {
        fetchAnnoucements()
    }
    // MARK: GET Annoucements
    func fetchAnnoucements() {
        announcements.removeAll()
        print("Here!!")
        let schoolStored = UserDefaults.standard.string(forKey: "schoolID") ?? ""
        let schoolID = String(describing: schoolStored)
        print("Get School ID \(schoolID)")
       if schoolID != "" {
            isLoading = true
            let ref = db.collection("announcements").document(schoolID).collection("PARENT")
           ref.getDocuments { snapshot, error in
               guard error == nil else {
                   print(error!.localizedDescription)
                   return
               }
               if let snapshot = snapshot {
                   for document in snapshot.documents {
                       let body = document["announcementBody"] as? String ?? ""
                       let image = document["announcementImage"] as? String ?? ""
                       let time = document["announcementTime"] as? Int ?? 0
                       let title = document["announcementTitle"] as? String ?? ""
                       let anouncement = Annoucements(announcementBody: body, announcementImage: image, announcementTime: time, announcementTitle: title)
                       self.announcements.append(anouncement)
                   }
               }
           }
       }
    }
    // MARK: ERROR HANDLER
    func handleError(error: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMsg = error
            self.showAlert.toggle()
        }
    }
}
