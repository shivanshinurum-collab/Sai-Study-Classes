import SwiftUI

struct SelectGoalView: View {
    @Binding var path : NavigationPath
  
    let popularExams: [PopularExam] = [
        PopularExam(title: "Teaching Exams", bgColor: Color.blue.opacity(0.2), icon: "graduationcap.fill"),
        PopularExam(title: "OSSC & OSSSC", bgColor: Color.green.opacity(0.2), icon: "building.columns.fill"),
        PopularExam(title: "OJEE", bgColor: Color.yellow.opacity(0.3), icon: "book.fill")
    ]
    
    
    let allExams: [Exam] = [
        Exam(title: "B.Ed Exam", color: .blue),
        Exam(title: "RHT : LTR : SSB TGT", color: .orange),
        Exam(title: "JTs", color: .yellow),
        Exam(title: "OTET", color: .blue),
        Exam(title: "OSSTET", color: .purple),
        Exam(title: "Govt B.Ed Exam", color: .yellow),
        Exam(title: "CTET", color: .green),
        Exam(title: "DSSSB", color: .pink),
        Exam(title: "KVS", color: .teal),
        Exam(title: "NVS", color: .indigo),
        Exam(title: "Super TET", color: .mint),
        Exam(title: "UP TET", color: .cyan),
        Exam(title: "REET", color: .brown),
        Exam(title: "MP TET", color: .red)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
               
                Text(uiString.SelectGoalTitle)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                
               
                Text(uiString.SelectGoalPopular)
                    .font(.headline)
                    .padding(.horizontal)
                
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 14
                ) {
                    ForEach(popularExams) { exam in
                        Button{
                            saveGoal(goal: exam.title , icon: exam.icon)
                            path.append(Route.HomeView)
                        }label: {
                            PopularExamCard(exam: exam)
                        }
                        
                    }
                }
                .padding(.horizontal)
                
             
                Text(uiString.SelectGoalAllExams)
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    ForEach(allExams) { exam in
                        Button{
                            
                        } label: {
                            ExamRow(exam: exam)
                        }
                        
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }.navigationBarBackButtonHidden(true)
        .background(Color.white)
    }
    func saveGoal(goal:String , icon:String) {
        UserDefaults.standard.set(goal, forKey: "goal")
        UserDefaults.standard.set(icon, forKey: "icon")
    }
}


struct PopularExamCard: View {
    
    let exam: PopularExam
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: exam.icon)
                .foregroundColor(.black)
            
            Text(exam.title)
                .font(.subheadline)
                .foregroundColor(.black)
                .bold()
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(exam.bgColor)
        .cornerRadius(14)
    }
}


struct ExamRow: View {
    
    let exam: Exam
    
    var body: some View {
        HStack(spacing: 14) {
            
            Circle()
                .fill(exam.color)
                .frame(width: 44, height: 44)
                .overlay(
                    Text(String(exam.title.prefix(1)))
                        .foregroundColor(.white)
                        .bold()
                )
            
            Text(exam.title)
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.3))
        )
    }
}


struct PopularExam: Identifiable {
    let id = UUID()
    let title: String
    let bgColor: Color
    let icon: String
}

struct Exam: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
}


