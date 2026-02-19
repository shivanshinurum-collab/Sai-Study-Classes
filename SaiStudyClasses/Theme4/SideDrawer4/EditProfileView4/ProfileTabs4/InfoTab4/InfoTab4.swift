import SwiftUI

struct InfoTab4 : View {
    
    @State var show : Int = 0
    
    var body: some View {
        ScrollView{
            
            Button{
                if show == 0 {
                    show = 9
                }else{
                    show = 0
                }
            }label: {
                HStack{
                    Image(systemName: "1.circle.fill")
                        .foregroundColor(uiColor.ButtonBlue)
                    Text("Basic Information")
                        .foregroundColor(.black)
                        .font(.caption)
                    Spacer()
                    
                    if show == 0 {
                        Button{
                            
                        }label: {
                            HStack{
                                Image(systemName: "pencil")
                                Text("Edit")
                            }.font(.caption)
                        }.padding(.horizontal)
                    }
                    Image(systemName: show == 0 ? "chevron.up" : "chevron.down" )
                        .foregroundColor(.black)
                }.padding()
            }
            if show == 0 {
                basicInfo()
            }
            
            Rectangle()
                .frame(height: 5)
                .foregroundColor(uiColor.system)
            
            Button{
                if show == 1 {
                    show = 9
                }else{
                    show = 1
                }
            }label: {
                HStack{
                    Image(systemName: "2.circle.fill")
                        .foregroundColor(uiColor.ButtonBlue)
                    Text("Address")
                        .foregroundColor(.black)
                        .font(.caption)
                    Spacer()
                    
                    if show == 1 {
                        Button{
                            
                        }label: {
                            HStack{
                                Image(systemName: "pencil")
                                Text("Edit")
                            }.font(.caption)
                        }.padding(.horizontal)
                    }
                    
                    Image(systemName: show == 1 ? "chevron.up" : "chevron.down" )
                        .foregroundColor(.black)
                }.padding()
            }
            if show == 1 {
                addressInfo()
            }
            
            Rectangle()
                .frame(height: 5)
                .foregroundColor(uiColor.system)
            
            Button{
                if show == 2 {
                    show = 9
                }else{
                    show = 2
                }
            }label: {
                HStack{
                    Image(systemName: "3.circle.fill")
                        .foregroundColor(uiColor.ButtonBlue)
                    Text("Educational Details")
                        .foregroundColor(.black)
                        .font(.caption)
                    Spacer()
                    
                    if show == 2 {
                        Button{
                            
                        }label: {
                            HStack{
                                Image(systemName: "pencil")
                                Text("Edit")
                            }.font(.caption)
                        }.padding(.horizontal)
                    }
                    
                    Image(systemName: show == 2 ? "chevron.up" : "chevron.down" )
                        .foregroundColor(.black)
                }.padding()
            }
            if show == 2 {
                EducationInfo()
            }
            
            Rectangle()
                .frame(height: 5)
                .foregroundColor(uiColor.system)
        }
    }
}

