import SwiftUI

struct temp : View {
    
    @State private var selectedPlanID: String?
    
    
    var multiPrice: [MultiPrice] = [
        MultiPrice(
            id: "52",
            course_id: "100",
            duration_type: "months",
            duration_value: "1",
            course_price: "100.00",
            created_at: "2026-01-29 15:53:59"
        ),
        MultiPrice(
            id: "53",
            course_id: "100",
            duration_type: "days",
            duration_value: "7",
            course_price: "70.00",
            created_at: "2026-01-29 15:53:59"
        ),
        MultiPrice(
            id: "54",
            course_id: "100",
            duration_type: "years",
            duration_value: "1",
            course_price: "1000.00",
            created_at: "2026-01-29 15:53:59"
        )
    ]
    
    
    var body : some View {
        
        ForEach(multiPrice) { plan in
            Button{
                selectedPlanID = plan.id
                print("PLAIN ID SELCET",selectedPlanID ?? "")
            }label:{
                HStack(spacing: 12) {
                    
                    Image(systemName: selectedPlanID == plan.id
                          ? "largecircle.fill.circle"
                          : "circle")
                    .foregroundColor(
                        selectedPlanID == plan.id ? uiColor.ButtonBlue : .gray
                    )
                    
                    Text("\(plan.duration_value ?? "") \(plan.duration_type ?? "") validity")
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: 160, alignment: .leading)
                        .foregroundColor(.black)
                    
                    Rectangle()
                        .frame(width: 0.5, height: 25)
                        .foregroundColor(.gray.opacity(0.4))
                    
                    Text("₹\(plan.course_price ?? "")")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            selectedPlanID == plan.id
                            ? uiColor.ButtonBlue
                            : Color.gray.opacity(0.3),
                            lineWidth: 1.4
                        )
                )
            }
        }
    }
}

