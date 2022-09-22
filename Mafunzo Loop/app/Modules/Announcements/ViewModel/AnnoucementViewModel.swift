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
    //Status
    @Published var isLoading: Bool = false
    @Published var noAnnouncement: Bool = false
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
           noAnnouncement = false
            let ref = db.collection("announcements").document(schoolID).collection("PARENT")
           ref.getDocuments { announcementSnapshot, error in
               guard error == nil else {
                   print(error!.localizedDescription)
                   return
               }
               if let snapshot = announcementSnapshot {
                   if snapshot.documents == [] {
                       self.isLoading = false
                       self.noAnnouncement = true
                   }
                   for document in snapshot.documents {
                       self.noAnnouncement = false
                       let body = document["announcementBody"] as? String ?? ""
                       let image = document["announcementImage"] as? String ?? ""
                       let time = document["announcementTime"] as? Int ?? 0
                       let title = document["announcementTitle"] as? String ?? ""
                       let anouncement = Annoucements(announcementBody: body, announcementImage: image, announcementTime: time, announcementTitle: title)
                       self.announcements.append(anouncement)
                       self.isLoading = false
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
