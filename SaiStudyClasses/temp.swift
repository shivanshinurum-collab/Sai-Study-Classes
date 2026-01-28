import SwiftUI
import StoreKit
import Foundation
import Combine


struct temp: View {

    @StateObject private var store = StoreViewModel()

    var body: some View {
        VStack(spacing: 20) {

            Text(store.isPurchased ? " Feature Unlocked" : " Feature Locked")
                .font(.title2)
                .fontWeight(.bold)

            if let product = store.product {
                Button {
                    Task {
                        await store.purchase()
                    }
                } label: {
                    Text(store.isPurchased ? "Purchased" : "Buy \(product.displayPrice)")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(store.isPurchased ? Color.gray : Color.blue)
                        .cornerRadius(12)
                }
                .disabled(store.isPurchased)
                .padding(.horizontal)
                
            } else {
                ProgressView("Loading Store…")
            }
        }
        .padding()
    }
}


@MainActor
final class StoreViewModel: ObservableObject {

    private let productIdentifier = "com.app.marine.wisdom.study.course0"

    @Published var product: Product?
    @Published var isPurchased = false

    private var transactionListenerTask: Task<Void, Never>?

    
    init() {
        transactionListenerTask = listenForTransactions()

        Task {
            await loadProduct()
            await updatePurchaseStatus()
        }
    }

    deinit {
        transactionListenerTask?.cancel()
    }

    
    func loadProduct() async {
        product = try? await Product.products(for: [productIdentifier]).first
    }

    
    func purchase() async {
        guard let product else { return }

        do {
            let result = try await product.purchase()

            switch result {

            case .success(let verificationResult):
                let transaction = try checkVerified(verificationResult)
                await transaction.finish()
                await updatePurchaseStatus()

            case .userCancelled:
                print(" User cancelled purchase")

            case .pending:
                print(" Purchase pending")

            @unknown default:
                break
            }
        } catch {
            print(" Purchase failed:", error)
        }
    }

  
    func updatePurchaseStatus() async {
        if let result = await Transaction.latest(for: productIdentifier),
           case .verified(let transaction) = result {
            isPurchased = transaction.revocationDate == nil
        } else {
            isPurchased = false
        }
    }

   
    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await update in Transaction.updates {
                guard let self else { return }

                if case .verified(let transaction) = update,
                   transaction.productID == self.productIdentifier {

                    await transaction.finish()
                    await self.updatePurchaseStatus()
                }
            }
        }
    }

    
    private func checkVerified<T>(
        _ result: VerificationResult<T>
    ) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw StoreError.failedVerification
        }
    }
}


enum StoreError: Error {
    case failedVerification
}



/*import SwiftUI
import Combine
import StoreKit
import Foundation

struct temp : View {
    @StateObject private var store = StoreViewModel()
    
    var body : some View {
        VStack{
            Text(store.isPurchased ? "Feature Unlocked" : "Locked")
                .font(.title)
            
            if let product = store.product {
                Button{
                    Task{
                        await store.purchase()
                    }
                } label: {
                    Text(store.isPurchased ? "Purchased" : "Buy \(product.displayPrice)")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(uiColor.ButtonBlue)
                .cornerRadius(15)
                .padding()
                .disabled(store.isPurchased)
            } else{
                Text("Loading Store...")
            }
        }
    }
}


@MainActor
final class StoreViewModel : ObservableObject {
    //private let productIdentifier = "com.app.marine.wisdom.study.course0"
    private let productIdentifier = "com.app.marine.wisdom.study.course0"
    
    @Published var product : Product?
    @Published var isPurchased = false
    
    init() {
        Task{
            await loadProduct()
            await updatePurchaseStatus()
        }
    }
    
    func loadProduct() async {
        if let loaded = try? await Product.products(for: [productIdentifier]).first {
            product = loaded
        }
    }
    
    func purchase() async {
        guard let product else { return }
        
        if case .success(let result) = try? await product.purchase(),
           case .verified(let transaction) = result {
            await transaction.finish()
            await updatePurchaseStatus()
        }
    }
    
    func updatePurchaseStatus() async {
        if let result = await Transaction.latest(for: productIdentifier),
           case .verified(let transaction) = result {
            isPurchased = (transaction.revocationDate == nil)
        } else{
            isPurchased = false
        }
    }
    
    private func listenForTransaction() {
        Task{
            for await update in Transaction.updates {
                if case .verified(let transaction) = update ,
                   transaction.productID == productIdentifier {
                    await transaction.finish()
                    await self.updatePurchaseStatus()
                }
            }
        }
    }
}
*/
