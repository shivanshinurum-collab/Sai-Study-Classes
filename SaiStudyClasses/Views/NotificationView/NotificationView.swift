import SwiftUI

struct NotificationView: View {
    @Binding var path : NavigationPath
    
    let notifications : [NotificationModel] = [
        NotificationModel(title: "Math Class Kali kaariba pile thanda jore au control re kariba", body: "Math Class Kali kaariba pile thanda jore au control re kariba", date: "01/Dec/2025 12:43 PM"),
        NotificationModel(title: "Math Class Kali kaariba pile thanda jore au control re kariba", body: "Math Class Kali kaariba pile thanda jore au control re kariba", date: "01/Dec/2025 12:43 PM"),
        NotificationModel(title: "Math Class Kali kaariba pile thanda jore au control re kariba", body: "Math Class Kali kaariba pile thanda jore au control re kariba", date: "01/Dec/2025 12:43 PM"),
        NotificationModel(title: "Math Class Kali kaariba pile thanda jore au control re kariba", body: "Math Class Kali kaariba pile thanda jore au control re kariba", date: "01/Dec/2025 12:43 PM")
    ]

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                ZStack {
                    Color.blue.opacity(0.8)
                        .ignoresSafeArea(edges: .top)

                    HStack {
                        Button {
                            path.removeLast()
                        } label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Text("Notification")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))

                        Spacer()

                        Color.clear.frame(width: 24)
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)
                }
                .frame(height: 100)
                .clipShape(
                    RoundedCorner(
                        radius: 20,
                        corners: [.bottomLeft, .bottomRight]
                    )
                )
                
               
                List {
                    ForEach(notifications , id: \.self) { notice in
                        NotificationCard(notifi: notice)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .padding(.horizontal)
            }
        }.navigationBarBackButtonHidden(true)
        .ignoresSafeArea(edges: .top)
    }
}





