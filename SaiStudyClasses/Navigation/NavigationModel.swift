import Foundation

enum Route : Hashable {
    
    case loginNumView
    case loginEmailView
    case WelcomeView
    case OTPView(user:String , isMobile : Bool)
    case SelectGoalView
    case HomeView
    
    //Side Bar
    case EditProfileView
    case BookmarkView
    case NoticeBoardView
    case PaymentHistoryView
    case BatchActivateView
    case AttendanceView
    case RefferNEarnView
    
    
    // Study Tab
    case MyBatchesView
    case MyDownloadsView
    case LiveChatView
    
    case NotificationView
    
    //Tabs
    case BatchesTabView
    case CourseCardView(course : CourseModel)
    case BuyCourseView(course : CourseModel)
    
    case MyCoursesAbout(course : CourseModel)
}
