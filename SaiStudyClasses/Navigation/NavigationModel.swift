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
    case BookmarkView(url : String , title : String)
    case NoticeBoardView
    case PaymentHistoryView
    case BatchActivateView
    case AttendanceView
    case RefferNEarnView
    
    
    // Study Tab
    case MyBatchesView
    case MyDownloadsView
    case LiveChatView
    case DigitalEbookView
    
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
    
    case StoreAbout(Id : String)
    
    case AddressFormView
    
    case AllDocView(title : String , url : String)
    
    
    case IAPView(productId : String)
    
    
    
    ///Theme 3
    case HomeTabView2
    case SelectGoal2
    case TestListView2(folder_id : String , folder_Name : String)
    
    case NotesListView2(folder_id : String, folder_Name : String)
    
    case VideoListView2(folder_id : String, folder_Name : String)
    
    
    
    //Theme4
    case WelcomeView4
    case TabView4
    case Notification4
    case CourseBuy4
    case courseCat4
    case CourseList4
    case FreeStudyMaterial4(selectedTab:Int)
    case filterView4
    case FreeVideosList4
    
}
