/*import SwiftUI
import StoreKit
import Combine

@MainActor
class IAPManager: ObservableObject {

    @Published var product: Product?
    @Published var isPurchased = false

    private let productID = "com.app.marine.wisdom.study.course"

    // Load product from App Store
    func loadProduct() async {
        do {
            let products = try await Product.products(for: [productID])
            print("📦 Products:", products)

            guard let product = products.first else {
                print("❌ Product not found")
                return
            }
            self.product = product
        } catch {
            print("❌ Load product error:", error)
        }
    }

    // Start payment
    func buy() async {
        guard let product else {
            print(" Product is nil")
            return
        }

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                isPurchased = true
                await transaction.finish()
                print(" Purchased:", transaction.productID)

            case .userCancelled:
                print(" User cancelled")

            case .pending:
                print(" Pending approval")

            default:
                break
            }
        } catch {
            print(" Purchase failed:", error)
        }
    }


    private func checkVerified<T>(
        _ result: VerificationResult<T>
    ) throws -> T {
        if case .verified(let safe) = result {
            return safe
        }
        throw NSError(domain: "IAP", code: 0)
    }
}

// MARK: - UI
struct IAPView: View {

    @Binding var path : NavigationPath
    @StateObject private var iap = IAPManager()

    var body: some View {
        VStack(spacing: 20) {

            if let product = iap.product {

                Text(product.displayName)
                    .font(.title2)

                Text(product.displayPrice)
                    .font(.headline)

                if iap.isPurchased {
                    Text("Course Unlocked ✅")
                        .foregroundColor(.green)
                } else {
                    Button("Buy Course") {
                        Task { await iap.buy() }
                    }
                }

            } else {
                ProgressView("Loading product…")
            }

         
        }
        .padding()
        .task {
            await iap.loadProduct()
           
        }
    }
}

*/
