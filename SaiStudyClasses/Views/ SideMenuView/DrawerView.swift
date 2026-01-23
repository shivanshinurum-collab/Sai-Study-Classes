import SwiftUI

struct DrawerView : View {
    @Binding var path : NavigationPath
    var size = 25
    var body: some View {
        
        
        VStack(alignment: .leading , spacing: 15){
            ZStack(alignment: .bottom){
                RoundedRectangle(cornerRadius: 26 , style: .continuous)
                    .foregroundColor(.clear)
                    .background(.blue.opacity(0.7))
                Text(uiString.DrawerTitle)
                    .font(.system(size: 30))
                    .foregroundColor(uiColor.white)
                    .bold()
                    .padding(.bottom)
                    
            }.frame( width: 300, height: 200)
           
            VStack(alignment: .leading,spacing:22){
                
                Button{
                    path.append(Route.EditProfileView)
                }label:{
                    Image(systemName: "person")
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerEditProfile)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                Button{
                    path.append(Route.ExamView(ExamUrl: "\(uiString.baseURL)/bookmark_page/QJYvEnPAMfImtzN3O-4W1A"))
                    //path.append(Route.BookmarkView)
                }label:{
                    Image(systemName: "bookmark")
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerBookmark)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                Button{
                    path.append(Route.NoticeBoardView)
                }label:{
                    Image(systemName: "newspaper")
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerNotice)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                Button{
                    path.append(Route.PaymentHistoryView)
                }label:{
                    Image(systemName: "indianrupeesign.arrow.trianglehead.counterclockwise.rotate.90")
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerPayment)
                        .multilineTextAlignment(.leading)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                Button{
                    path.append(Route.BatchActivateView)
                }label:{
                    Text("</>")
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerBatch)
                        .multilineTextAlignment(.leading)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                Button{
                    path.append(Route.AttendanceView)
                }label:{
                    Image(systemName: "person.badge.shield.checkmark")
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerAttendance)
                        .multilineTextAlignment(.leading)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                Button{
                    path.append(Route.RefferNEarnView)
                }label:{
                    Image(systemName: "person.line.dotted.person")
                        .font(.system(size: 15))
                        .frame(maxWidth: 40)
                    Text(uiString.DrawerReffer)
                        .multilineTextAlignment(.leading)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
                
                Button{
                    UserLogOut()
                    path.removeLast(path.count)
                    
                    
                }label:{
                    Image(systemName: "power")
                        .frame(maxWidth: 40)
                        
                    Text(uiString.DrawerLogOut)
                        .multilineTextAlignment(.leading)
                }.font(.system(size: CGFloat(size)))
                    .foregroundColor(uiColor.black)
            }.padding(.leading , 20)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .background(.white)
        Spacer()
            
    }
    
    func UserLogOut(){
        UserDefaults.standard.set("", forKey: "goal")
        UserDefaults.standard.set("", forKey: "icon")
        UserDefaults.standard.set("", forKey: "user")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}

