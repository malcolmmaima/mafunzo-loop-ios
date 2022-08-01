//
//  RequestViewItem.swift
//  Mafunzo Loop
//
//  Created by Mroot on 30/07/2022.
//
import SwiftUI

struct RequestViewInfo: View {
    var status: RequestStatus
    var requestInfo: RequestDecoder
    var body: some View {
        GeometryReader { geo in
            VStack {
                AnnoucementTopView()
                    .frame(height: geo.size.height * 0.1)
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(requestInfo.subject)
                            .font(.title2)
                            .padding()
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                            Text("\(requestDateCreated(time: requestInfo.createdAt))")
                                .foregroundColor(.blue)
                        }
                        Text(status.rawValue)
                            .foregroundColor(requestStatus(status: status))
                        Divider()
                        Text(requestInfo.message)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                .background(
                    RoundedCornersShape(corners: .allCorners, radius: 40)
                        .fill(Color.ViewBackground)
                )
                .offset(y: -55)
            }
        }
    }
    
    // MARK: Time to Hour & Min (10:00 AM/PM)
    func requestDateCreated(time: Int) -> String {
        let stating = Date(timeIntervalSince1970: (Double(time) / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM YYYY, h:mm a"
        return dateFormatter.string(from: stating)
    }
    // MARK: Request Status Color
    private func requestStatus(status: RequestStatus) -> Color {
        switch status {
        case .REQUEST_STATUS_PENDING:
            return .gray
        case .REQUEST_STATUS_PROCESSING:
            return .blue
        case .REQUEST_STATUS_CANCELLED:
            return .red
        case .REQUEST_STATUS_REJECTED:
            return .red
        case .REQUEST_STATUS_APPROVED:
            return .green
        }
    }
}

//struct RequestViewItem_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestViewItem()
//    }
//}
