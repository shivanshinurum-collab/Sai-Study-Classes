import SwiftUI

struct NavigationManager: View {
   @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path){
        SplashView(path: $path)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .loginNumView:
                        LoginNumView(path: $path)
                    case .loginEmailView:
                       LoginEmailView(path: $path)
                    case .WelcomeView:
                        WelcomeView(path: $path)
                    case .OTPView(let user , let isMobile):
                        OTPView(path: $path , user: user , isMobile: isMobile)
                    case .HomeView :
                        HomeTabVew(path: $path)
                    case .SelectGoalView:
                        SelectGoalView(path: $path)
                    case .EditProfileView:
                        EditProfile(path: $path)
                    case .BookmarkView:
                        Bookmark(path: $path)
                    case .NoticeBoardView:
                        NoticeBoardView(path: $path)
                    case .PaymentHistoryView:
                        PaymentHistory(path: $path)
                    case .BatchActivateView:
                        ActivateBatch(path: $path)
                    case .AttendanceView:
                        AttendanceView(path: $path)
                    case .RefferNEarnView:
                        RefferNEarn(path: $path)
                          
                    case .MyBatchesView:
                        MyBatchesView(path: $path)
                    case .MyDownloadsView:
                        MyDownloads()
                    case .LiveChatView:
                        LiveChat()
                        
                    case .NotificationView:
                        NotificationView(path: $path)
                        
                    case .BuyCourseView(let course):
                        BuyCourseView(path: $path, course: course)
                        
                    case .CourseCardView(let course):
                        CourseCardView(path: $path, course: course)
                    case .BatchesTabView:
                        BatchesTabView(path: $path)
                        
                    case .MyCoursesAbout(let course):
                        AboutCourses(path: $path, course: course)
                    }
                }
        }
        
    }
    
}



