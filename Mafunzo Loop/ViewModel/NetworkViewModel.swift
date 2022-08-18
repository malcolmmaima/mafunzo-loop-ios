//
//  NetworkViewModel.swift
//  Mafunzo Loop
//
//  Created by Mroot on 18/08/2022.
//

import Foundation
import Network

class NetworkViewModel: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkViewModel")
    @Published var isNotConnected = true
    //image
    var imageName: String {
        return isNotConnected ? "wifi" : "wifi.slash"
    }
    //description
    var conncetionDescription: String {
        return "No internet connection"
    }
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isNotConnected = path.status == .unsatisfied
            }
        }
        monitor.start(queue: queue)
    }
}
