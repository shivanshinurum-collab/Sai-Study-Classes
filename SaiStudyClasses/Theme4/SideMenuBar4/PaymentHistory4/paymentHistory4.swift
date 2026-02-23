import SwiftUI

struct paymentHistory4 : View {
    
    var body : some View {
        VStack(alignment: .leading){
            Text("Payment History")
                .font(.title3)
                .bold()
            
            ScrollView{
                paymentCard4()
                paymentCard4()
            }
        }.padding()
    }
}
#Preview {
    paymentHistory4()
}
