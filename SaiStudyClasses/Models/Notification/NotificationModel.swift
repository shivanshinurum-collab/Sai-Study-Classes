import Foundation

struct NotificationModel : Codable , Hashable {
    var id  = UUID()
    let title : String
    let body : String
    let date : String
}
