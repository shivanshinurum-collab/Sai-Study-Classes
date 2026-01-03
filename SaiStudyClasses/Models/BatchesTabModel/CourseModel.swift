import Foundation
struct CourseModel: Identifiable , Hashable {
    let id = UUID()
    let title: String
    let category: CourseCategory
    let price: Int
    let originalPrice: Int
    let discountText: String
    let startDate: String
    let imageName: String
    let isNew: Bool
}
