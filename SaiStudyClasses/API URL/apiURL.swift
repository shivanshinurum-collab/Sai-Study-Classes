struct apiURL {
    static let baseURL = "https://marinewisdom.com/"
    //static let baseURL = "https://app2.lmh-ai.in/"
    
    
    static let qustionOfDay = "https://drpawar.in/question-day/1"
    
    
    //Login Banners
    static let loginBanners = "\(apiURL.baseURL)ajaxcall/api_login_banners"
    
    
    
    ///LOGIN
    //Generate OTP
    static let generateOTP = "\(apiURL.baseURL)api/MobileApi/generateOTP"
    //Check OTP
    static let checkOTP = "\(apiURL.baseURL)api/MobileApi/checkOTP"
    
    
    ///REGISTER
    //Update Custom Detail
    static let updateCustomDetail = "\(apiURL.baseURL)api/MobileApi/updateCustomDetail"
    //Get Custom Field
    static let getCustomField = "\(apiURL.baseURL)api/MobileApi/getCustomField"
    //Update Student Details
    static let updateStudentDetail = "\(apiURL.baseURL)api/MobileApi/updateStudentDetail"
    
    
    
    ///HOME
    //Get Category Data
    static let getCategoryData = "\(apiURL.baseURL)api/HomeNew/getCategoryData"
    //Get Notification
    static let getNotification = "\(apiURL.baseURL)api/home/get_notification"
    
    
    ///Study TAB
    //My Course
    static let myCourse = "\(apiURL.baseURL)api/home/myCourse"
    
    //Get Test SeriesBatch
    static let getTestSeriesBatch = "\(apiURL.baseURL)api/Home/getTestSeriesBatch"
    
    //Get Home Banner
    static let getHomeBanner = "\(apiURL.baseURL)api/home/getHomeBanner"
    
    //Get Sub Category List
    static let getSubCategoryList = "\(apiURL.baseURL)api/HomeNew/getSubcategoryList/"
    
    //Get Batch By Cat SubCat
    static let getBatchByCatSubCat = "\(apiURL.baseURL)api/Home/getBatchByCatSubCat"
    
    //Get Store Content
    static let getStoreContent = "\(apiURL.baseURL)api/HomeNew/getStoreContent/"
    
    //Get Testimonial
    static let getTestimonial = "\(apiURL.baseURL)api/HomeNew/getTestimonial"
    
    
    ///ABOUT COURSE
    //Applied Coupon
    static let appliedCoupon = "\(apiURL.baseURL)api/v2/Home/appliedCoupon"
    //Get Batch Detail
    static let getBatchDetail = "\(apiURL.baseURL)api/Home/getBatchDetail"
    //Check Active Live Class
    static let checkActiveLiveClass = "\(apiURL.baseURL)api/Home/checkActiveLiveClass"
    //Get Content Detail
    static let getContentDetail = "\(apiURL.baseURL)api/HomeNew/getContentDetail"
    //Manage Course Content
    static let manageContent = "\(apiURL.baseURL)api/HomeNew/manage_content/"
    
    
    ///DOCUMENT
    //Doc Batch Image
    static let DocbatchImage = "\(apiURL.baseURL)uploads/batch_image/"
    //Doc Exam Panel
    static let DocexamPanel = "\(apiURL.baseURL)exam-panel/"
    //Doc Video Image
    static let DocVideoImg = "\(apiURL.baseURL)uploads/video/"
    //Doc Video
    static let DocVideo = "\(apiURL.baseURL)uploads/"
    
    
    
    ///DRWAER  SIDE BAR
    static let profileUpdate = "\(apiURL.baseURL)api/home/profile_update"
    //Bookmark Page
    static let BookmarkPage = "\(apiURL.baseURL)/bookmark_page/QJYvEnPAMfImtzN3O-4W1A"
    //Activate Batch
    static let activateBatch = "\(apiURL.baseURL)api/home/add_activation_batch_code"
    //Get Attendance
    static let getAttendance = "\(apiURL.baseURL)api/v2/home/getAttendance"
    //Get Profile
    static let getProfile = "\(apiURL.baseURL)api/home/getProfile/"
    //Get Notice
    static let getNotice = "\(apiURL.baseURL)api/home/get_notice"
    //Get Payment History
    static let getPaymentHistory = "\(apiURL.baseURL)api/home/get_payment_history"
   
    
    
    
    //General Settings
    static let generalSetting = "\(apiURL.baseURL)api/v2/home/general_setting"
    
  
    
    
    ///Theme 2
    static let SelectGoal2 = "\(apiURL.baseURL)api/Theme3/getBatchWithCategory"
    
    //static let getNotes2 = "\(apiURL.baseURL)api/Theme3/getFolderForVideo/"
    static let getNotes2 = "https://limbusmed.com/api/Theme3/getFolderForVideo/"
}
