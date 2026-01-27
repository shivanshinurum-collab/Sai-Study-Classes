
import SwiftUI
import Combine

#Preview {
    temp()
}

import StoreKit

// MARK: - IAP Manager
@MainActor
class CourseIAPManager: ObservableObject {

    @Published var products: [Product] = []
    @Published var purchasedCourseIDs: Set<String> = []

    // 👉 Add all your course product IDs here
    private let productIDs: [String] = [
        "com.yourapp.course.math",
        "com.yourapp.course.physics"
    ]

    // Fetch products from App Store
    func fetchProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("❌ Failed to fetch products:", error)
        }
    }

    // Purchase course
    func purchase(product: Product) async {
        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try verified(verification)
                purchasedCourseIDs.insert(transaction.productID)
                await transaction.finish()
                print("✅ Purchased:", transaction.productID)

            case .userCancelled:
                print("⚠️ User cancelled purchase")

            default:
                break
            }
        } catch {
            print("❌ Purchase failed:", error)
        }
    }

    // Restore purchases
    func restorePurchases() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedCourseIDs.insert(transaction.productID)
            }
        }
        print("🔁 Restore completed")
    }

    // Verification helper
    private func verified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw NSError(domain: "IAPError", code: 0)
        }
    }

    // Access check
    func hasAccess(courseID: String) -> Bool {
        purchasedCourseIDs.contains(courseID)
    }
}

// MARK: - UI
struct temp: View {

    @StateObject private var iapManager = CourseIAPManager()

    var body: some View {
        NavigationView {
            List {
                ForEach(iapManager.products, id: \.id) { product in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.displayName)
                            .font(.headline)

                        Text(product.displayPrice)
                            .foregroundColor(.gray)

                        if iapManager.hasAccess(courseID: product.id) {
                            Text("Purchased ✅")
                                .foregroundColor(.green)
                        } else {
                            Button("Buy Course") {
                                Task {
                                    await iapManager.purchase(product: product)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 6)
                }

                Button("Restore Purchases") {
                    Task {
                        await iapManager.restorePurchases()
                    }
                }
                .foregroundColor(.blue)
            }
            .navigationTitle("Courses")
        }
        .task {
            await iapManager.fetchProducts()
            await iapManager.restorePurchases()
        }
    }
}



