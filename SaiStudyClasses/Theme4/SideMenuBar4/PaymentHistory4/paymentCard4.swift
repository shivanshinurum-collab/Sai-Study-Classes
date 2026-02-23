import SwiftUI
struct paymentCard4 : View {
    let head :String = "Advance Diploma in Clinical Research"
    let id : String = "1234565sfsfsdf"
    let date : String = "21 Feb 2026"
    let amount : String = "35000"
    let status : Bool = true
    
    var body : some View {
        VStack(alignment: .leading , spacing: 8){
            HStack{
                Text(head)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                 
                Spacer()
                Text("₹\(amount)")
                    .font(.headline)
                    .foregroundColor(uiColor.green)
            }
            
            Text("Txn ID:\(id)")
                .font(.subheadline)
                .foregroundColor(uiColor.DarkGrayText)
            
            HStack{
                Text(date)
                    .font(.subheadline)
                    .foregroundColor(uiColor.DarkGrayText)
                Spacer()
                Text(status ? "SUCCESS" : "FAILED")
                    .font(.headline)
                    .foregroundColor(status ? uiColor.green : uiColor.Error)
            }
        }.padding()
            .background(.white)
            .cornerRadius(15)
            .shadow(color: uiColor.DarkGrayText, radius: 1)
            .padding(5)
    }
}

