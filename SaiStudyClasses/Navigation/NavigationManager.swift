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
                        //MyDownloads(path: $path)
                        DownloadsView(path: $path)
                        
                        
                    case .LiveChatView:
                        LiveChat()
                        
                    case .NotificationView:
                        NotificationView(path: $path)
                        
                    case .BuyCourseView(let course_id , let course_name):
                        BuyCourseView(path: $path, course_id: course_id,course_name: course_name)
                        
                    case .CourseCardView(let course):
                        CourseCardView(path: $path, course: course)
                    case .BatchesTabView:
                        BatchesTabView(path: $path)
                        
                    //case .MyCoursesAbout(let course_id):
                     //   AboutCourses(path: $path, course :course_id)
                        
                        
                    case .RegistrationView:
                        RegisterView(path: $path)
                    case .RegistrationLocationView:
                        RegisterLocationView(path: $path)
                        
                    case .temp :
                        temp()
                        
                        //Document View
                    case .PDFview(let url ,let title):
                        PDFView(pdfURL: url, title: title)
                        
                    case .VideoView(let url, let title):
                        VideoView(videoURL: url, title: title,path: $path)
                        
                    case .YouTubeView(let videoId, let title):
                        YouTubeVideoView(videoId: videoId, title: title,path: $path)
                        
                    case .AudioPlayerView(let url,let title):
                        AudioPlayerView(path: $path,audioURL: url, title: title)
                        
                    case .FoldersView(let BatchId, let FolderId):
                        FoldersView(path: $path, batch_id: BatchId, folder_id: FolderId)
                        
                    case .ExamView(let ExamUrl):
                        ExamView(url: ExamUrl)
                    case .ExamInfo(let title, let  dis, let  url):
                        ExamInfo(path: $path, title: title, discription: dis, url: url)
                        
                    case .StoreAbout(let Id):
                        StoreAboutView(path: $path,id: Id)
                        
                    case .AddressFormView:
                            AddressFormView(path: $path)
                        
                    case .AllDocView(let title, let url):
                        AllDocView(path: $path, url: url, title: title)
                        
                    case .DigitalEbookView:
                        DigitalEbookView(path: $path)
                    //case .IAPView:
                     //   IAPView(path: $path)
                        
                    }
                }
        }
        
    }
    
}



