import Foundation
struct MyBatchesModel : Codable , Hashable {
    var id = UUID()
    let title : String
    let image : String
    let Active : Bool
}
