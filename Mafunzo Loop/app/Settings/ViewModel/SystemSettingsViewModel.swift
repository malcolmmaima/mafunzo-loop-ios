//
//  SystemSettingsViewModel.swift
//  Mafunzo Loop
//
//  Created by Mroot on 12/08/2022.
//

import Foundation
import UIKit
import Firebase

class SystemSettingsViewModel: ObservableObject {
    @Published var systemStatus: Bool = false
    //Firebase
    let db = Firestore.firestore()
    
    init() {
        systemSettings()
    }
    
    func systemSettings() {
        let systemRef = db.collection("app_settings").document("system_settings")
        systemRef.getDocument(source: .default) { systemSnapshot, error in
            if let systemSnapshot = systemSnapshot {
                let systemSettings = systemSnapshot.data()
                let dbStatus = systemSettings?["offline"] as? Bool ?? false
                self.systemStatus = dbStatus
                print("System Offline Status: \(self.systemStatus)")
            }
        }
    }
}
