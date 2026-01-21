import Foundation

enum Route : Hashable {
    
    case loginNumView
    case loginEmailView
    case WelcomeView
    case OTPView(user:String , isMobile : Bool)
    case SelectGoalView
    case HomeView
    
    //Registration
    case RegistrationView
    case RegistrationLocationView
    
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
    case CourseCardView(course : batchData)
    case BuyCourseView(course_id : String , course_name :String)
    
  //  case MyCoursesAbout(course : batchData)
    
    case temp
    
    //Document View
    case PDFview(url: String , title: String)
    case VideoView(url: String , title : String)
    case YouTubeView(videoId: String , title : String)
    case AudioPlayerView(url : String , title : String)
    
    case FoldersView(BatchId : String,FolderId : String)
    
    case ExamView(ExamUrl : String)
    case ExamInfo(title : String , dis : String , url : String)
    
}
