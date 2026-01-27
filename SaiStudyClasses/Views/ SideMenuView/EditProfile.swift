import SwiftUI

struct EditProfile : View{
    @Binding var path : NavigationPath
    
    var EnrollmentId : String = UserDefaults.standard.string(forKey: "enrollmentId") ?? "Enroll ID"
    var Email : String = UserDefaults.standard.string(forKey: "userEmail") ?? "Email"
    
    var image = URL(string: UserDefaults.standard.string(forKey: "image") ?? "")
    
    var Name : String = UserDefaults.standard.string(forKey: "fullName") ?? "User"
    var studentId :String = UserDefaults.standard.string(forKey: "studentId") ?? ""
    var body: some View {
        
        ZStack(alignment: .top){
            HStack{
                Button{
                    path.removeLast()
                }label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 30))
                        .foregroundColor(uiColor.white)
                }
                Spacer()
                Text(uiString.ProfileTitle)
                    .font(.system(size: 25).bold())
                    .foregroundColor(uiColor.white)
                Spacer()
            }.padding(.horizontal , 15)
            ZStack{
                RoundedRectangle(cornerRadius: 45)
                    .foregroundColor(uiColor.white)
                    .ignoresSafeArea()
                    .padding(.top , 70)
                VStack(spacing: 10){
                    HStack{
                        Button{
                            
                        }label: {
                            ZStack(alignment: .bottom){
                                
                                AsyncImage(url: image){ img in
                                    img
                                        .image?.resizable()
                                        .scaledToFit()
                                }.frame(width: 90,height: 90)
                                    .padding(9)
                                    .overlay{
                                        Circle()
                                            .stroke(.blue.opacity(0.8) , lineWidth: 1)
                                    }
                                
                                
                                    
                                Circle()
                                    .frame(width: 35 , height: 35)
                                    .foregroundColor(uiColor.white)
                                    .overlay{
                                        Circle()
                                            .frame(width: 30 , height: 30)
                                            .overlay{
                                                Image(systemName: "camera.fill")
                                                    .foregroundColor(uiColor.white)
                                                    .font(.system(size: 15))
                                            }
                                    }
                                
                            }
                        }
                      
                        VStack(alignment: .leading){
                            Text("\(uiString.ProfileEnroll) \(EnrollmentId)")
                            Text("\(uiString.ProfileEmail) \(Email)")
                            Text("StudentId: \(studentId)")
                        }.padding(.leading)
                            .foregroundColor(uiColor.ButtonBlue)
                        
                    }
                    VStack(alignment: .leading){
                        Text(uiString.ProfileNameHead)
                            .foregroundColor(uiColor.DarkGrayText)
                        ZStack(alignment: .leading){
                            Text(Name)
                                .padding(.horizontal , 29)
                                .foregroundColor(uiColor.DarkGrayText)
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(.black.opacity(0.7) , lineWidth: 0.5)

                        }.frame(maxWidth: .infinity , maxHeight: 60)
                    }.padding()
                    
                    Button{
                        
                    }label: {
                        Text(uiString.ProfileSaveButton)
                            .font(.title3)
                            .foregroundColor(uiColor.white)
                            .padding(.vertical , 12)
                            .padding(.horizontal , 65)
                            .background(.blue.opacity(0.8))
                            .cornerRadius(12)
                    }
                    
                    
                    Button{
                        
                    }label: {
                        Text(uiString.ProfileChangeBatch)
                            .font(.title3)
                            .padding(.vertical , 25)
                    }
                    Spacer()
                }.padding(.top , 100)
            }
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity)
        .background(.blue.opacity(0.8))
        .navigationBarBackButtonHidden(true)
    }
}


