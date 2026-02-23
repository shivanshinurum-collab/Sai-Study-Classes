import SwiftUI

struct TabView4: View {
    @Binding var path : NavigationPath
    
    @State private var selectedTab = 0
    @State var showMenu: Bool = false
    private let menuWidth: CGFloat = 280
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            // MAIN CONTENT
            VStack(spacing: 0) {
                
                // Top Header
                if !showMenu {
                    HStack {
                        Button {
                            withAnimation {
                                showMenu.toggle()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                        
                        Text("MARINE WISDOM")
                            .font(.title3)
                            .bold()
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        Button {
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .bold()
                        }
                    }
                    .padding(.horizontal)
                    .font(.title3)
                    .foregroundColor(.red)
                    .padding(.vertical, 10)
                    .background(.white)
                }
                
                // Main Content
                TabView(selection: $selectedTab) {
                    
                    HomeTab4(path: $path).tag(0)
                    AttendanceTabView4().tag(1)
                    ShortsView().tag(2)
                    NoticeTabView4().tag(3)
                    ResultTabView4().tag(4)
                    paymentHistory4().tag(7)
                    myCourse4(path: $path).tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Bottom Tab Bar
                HStack {
                    TabBarItem4(icon: "house.fill", title: "Home", index: 0, selectedTab: $selectedTab)
                    TabBarItem4(icon: "checkmark.circle", title: "Attendance", index: 1, selectedTab: $selectedTab)
                    TabBarItem4(icon: "play.rectangle.fill", title: "Shorts", index: 2, selectedTab: $selectedTab)
                    TabBarItem4(icon: "megaphone.fill", title: "Notice", index: 3, selectedTab: $selectedTab)
                    TabBarItem4(icon: "chart.bar.fill", title: "Results", index: 4, selectedTab: $selectedTab)
                }
                .padding()
                .background(Color.red)
            }
            .disabled(showMenu) // disable clicks when menu open
            
            
            // DARK OVERLAY
            if showMenu {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }
            }
            
            
            // SIDE MENU
            SideMenuView4(path: $path,selectedTab: $selectedTab, showMenu: $showMenu)
                .frame(width: menuWidth)
                .offset(x: showMenu ? 0 : -menuWidth)
                .animation(.easeInOut(duration: 0.3), value: showMenu)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
    }
}

struct TabBarItem4: View {
    
    let icon: String
    let title: String
    let index: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        Button {
            selectedTab = index
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(selectedTab == index ? .white : .white.opacity(0.5))
            .frame(maxWidth: .infinity)
        }
    }
}




