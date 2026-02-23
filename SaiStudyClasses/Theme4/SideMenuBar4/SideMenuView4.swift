import SwiftUI

struct SideMenuView4: View {
    @Binding var path : NavigationPath
    @Binding var selectedTab: Int
    @Binding var showMenu: Bool
    
    var body: some View {
        
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                
                VStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.red)
                    
                    Text("Student Portal")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    Text("Play Store")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                
                
                ScrollView{
                    VStack(alignment: .leading, spacing: 18) {
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "house.fill",
                                     title: "Home",
                                     index: 0,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "checkmark.circle",
                                     title: "Attendance",
                                     index: 1,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "play.rectangle",
                                     title: "Shorts",
                                     index: 2,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "doc.text",
                                     title: "Notices",
                                     index: 3,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "chart.bar",
                                     title: "Results",
                                     index: 4,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "book",
                                     title: "My Course",
                                     index: 5,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "person",
                                     title: "Profile",
                                     index: 6,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        Button{
                            
                        }label: {
                            MenuRow4(icon: "creditcard",
                                     title: "Payments",
                                     index: 7,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }.buttonStyle(.plain)
                        
                        
                        Button {
                            
                        } label: {
                            MenuRow4(icon: "rectangle.portrait.and.arrow.right",
                                     title: "Logout",
                                     index: 8,
                                     selectedTab: $selectedTab,
                                     showMenu: $showMenu)
                        }
                        
                    }
                    .padding(.horizontal)
                
                }
            }
        }
        .frame(width: 280)
    }
}


