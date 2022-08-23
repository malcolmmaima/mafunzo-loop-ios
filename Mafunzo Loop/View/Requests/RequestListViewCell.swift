//
//  RequestListViewCell.swift
//  Mafunzo Loop
//
//  Created by Mroot on 29/07/2022.
//
import SwiftUI

struct RequestListViewCell: View {
    private let dateConverter = DateConverter()
    @State var requestTitle: String
    @State var requestStatus: RequestStatus
    @State var createdDate: Int
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("")
            }
            .frame(width: 15.0, height: 73)
            .background(
                RoundedCornersShape(corners: [.topLeft, .bottomLeft], radius: 10)
                    .fill(requestStatus(status: requestStatus))
            )
          HStack(alignment: .top) {
            VStack(alignment: .leading) {
                    Text(requestTitle)
                    Text("\(requestDateCreated(time: createdDate))")
                        .foregroundColor(.blue)
                }
              Spacer()
          }
            .padding()
            .frame(width: .none)
        }
        .background(
            RoundedCornersShape(corners: .allCorners, radius: 10)
                .fill(Color.homeCategory)
        )
        .shadow(radius: 2.0)
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
    
    // MARK: Time to Hour & Min (10:00 AM/PM)
    func requestDateCreated(time: Int) -> String {
        let stating = Date(timeIntervalSince1970: (Double(time) / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM YYYY, h:mm a"
        return dateFormatter.string(from: stating)
    }
    
}

struct RequestListViewCell_Previews: PreviewProvider {
    static var previews: some View {
        RequestListViewCell(requestTitle: "Meals", requestStatus: .REQUEST_STATUS_CANCELLED, createdDate: 1659093825119)
    }
}
