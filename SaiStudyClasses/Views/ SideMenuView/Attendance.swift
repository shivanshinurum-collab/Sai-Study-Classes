import SwiftUI

struct AttendanceModel : Hashable{
    let id = UUID()
    let date : String
    let time : String
    let status : Bool
}

struct AttendanceView : View {
    @Binding var path : NavigationPath
    
   @State var attendance : [AttendanceModel] = [
        AttendanceModel(date: "2026-01-04", time: "11:33:06", status: true),
        AttendanceModel(date: "2026-01-05", time: "05:00:15", status: true),
        AttendanceModel(date: "2026-01-06", time: "10:30:23", status: true),
    ]
    
    var body: some View {
        VStack(){
            ZStack(alignment:.top) {
                uiColor.ButtonBlue
                    .ignoresSafeArea(edges: .top)
                    .clipShape(
                        RoundedCorner(
                            radius: 30,
                            corners: [.bottomLeft, .bottomRight]
                        )
                    )
                    .frame(height: 160)
                    .ignoresSafeArea()
                Color.clear.frame(width: 24)
                
                HStack {
                    Button {
                        //path.removeLast()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(uiColor.white)
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    Text("Attendance")
                        .foregroundColor(uiColor.white)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Spacer()
                    
                    
                }
                .padding(.horizontal)
                
               DatePickerView()
                    .padding(.top,30)
                    .shadow(color: uiColor.DarkGrayText,radius: 1)
                
            }
            .frame(height: 180)
            
            
            VStack{
                HStack{
                    Text("Date")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                    Text("Time")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                    Text("Status")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                    
                }.padding()
                .foregroundColor(uiColor.white)
                .background(uiColor.ButtonBlue)
                
                
                ScrollView{
                    ForEach(attendance , id: \.self){ date in
                        HStack{
                            HStack{
                                Text(date.date)
                                    .frame(maxWidth: .infinity)
                                Text(date.time)
                                    .frame(maxWidth: .infinity)
                                Text(date.status ? "Present" : "Absent")
                                    .frame(maxWidth: .infinity)
                                
                            }.padding()
                                .font(.headline)
                                .foregroundColor(uiColor.DarkGrayText)
                                .background(uiColor.white)
                        }
                    }
                }
            }
            .cornerRadius(15)
            .padding()
            
            Spacer()
           
        }
    }
}

struct DatePickerView : View {
    
        @State private var selectedMonth = "01"
        @State private var selectedYear = "2026"
    
    let months = Array(1...12).map { String(format: "%02d", $0) }
        let years = ["2026","2027", "2028", "2029","2030"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Select Month And Year To Filter Results")
                .font(.system(size: 15))
                .foregroundColor(.gray)

            HStack(spacing: 12) {

                Picker("Month", selection: $selectedMonth) {
                    ForEach(months, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.white)
                .cornerRadius(6)

                Picker("Year", selection: $selectedYear) {
                    ForEach(years, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.white)
                .cornerRadius(6)

                Button {
                    // Filter Action
                } label: {
                    Text("OK")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .frame(width: 60, height: 40)
                        .background(uiColor.ButtonBlue)
                        .cornerRadius(6)
                }
            }.frame(width:325)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6)
        .padding(20)
    }
}

