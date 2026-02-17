import SwiftUI

struct HomeTabView4:View{
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    let items: [GridItemModel] = [
        .init(title: "FREE\nTests", color: .blue, isFree: true, image: "doc.text"),
        .init(title: "FREE\nVideos", color: .blue, isFree: true, image: "play.rectangle.fill"),
        .init(title: "FREE\nMaterials", color: .blue, isFree: true, image: "book.fill"),
        
            .init(title: "GDC\nPRIME", color: .red, isFree: false, image: "books.vertical.fill"),
        .init(title: "Bookशाला", color: .red, isFree: false, image: "book.closed.fill"),
        .init(title: "Test\nSeries", color: .red, isFree: false, image: "checklist"),
        
            .init(title: "GDC पाठशाला", color: .teal, isFree: false, image: "person.3.fill"),
        .init(title: "D.Pharm", color: .teal, isFree: false, image: "person.fill"),
        .init(title: "B.Pharm", color: .teal, isFree: false, image: "person.fill")
    ]
    
    var body: some View{
        ScrollView{
            ScrollView(.horizontal){
                HStack{
                    ForEach(1..<6){_ in
                        Image("banner")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            
            VStack(alignment: .leading){
                Text("What do you want to learn?")
                    .foregroundColor(.black)
                    .font(.headline)
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(1..<6){_ in
                            VStack{
                                Image("course")
                                    .resizable()
                                    .background(uiColor.CreamBlueGreen)
                                    .frame(width: 80 , height: 80)
                                    .clipShape(.circle)
                                
                                Text("course")
                                    .font(.caption)
                            }.padding(8)
                        }
                    }
                }.scrollIndicators(.hidden)
                
            }.padding()
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 8)
                .foregroundColor(uiColor.system)
            
            VStack(alignment: .leading){
                Text("What are You looking for?")
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(items) { item in
                            Button{
                                
                            }label: {
                                HomeTabGridCardView4(item: item)
                            }
                        }
                    }
                    .padding()
                }
                
            }.padding()
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 8)
                .foregroundColor(uiColor.system)
            
            VStack{
                HStack{
                    Text("Free Videos")
                    Spacer()
                    Button{
                        
                    }label: {
                        Text("see All")
                        Image(systemName: "arrow.right")
                    }
                }
                
                ScrollView(.horizontal){
                    HStack(spacing: 8){
                        ForEach(1..<6){_ in
                            HomeTabVideoCard4(image: "banner", time: "00:10:15", courseName: "UPCS Course 1Shot")
                        }
                    }
                }.scrollIndicators(.hidden)
                
                
            }.padding()
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 8)
                .foregroundColor(uiColor.system)
            
            
            VStack{
                HStack{
                    Text("Featured Courses")
                    Spacer()
                    Button{
                        
                    }label: {
                        Text("see All")
                        Image(systemName: "arrow.right")
                    }
                }
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(1..<7){_ in
                            HomeTabCourseCard4(image: "banner", name: "UPSC QUICK RIVISION", price: "1799", oprice: "3999")
                                .padding(5)
                        }
                    }
                }.scrollIndicators(.hidden)
                
            }.padding()
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 8)
                .foregroundColor(uiColor.system)
            
            VStack(alignment: .leading){
                Text("Connect With Us")
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(1..<10){_ in
                            Button{
                                
                            }label: {
                                VStack{
                                    Image("logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70 , height: 80)
                                    
                                    Text("WebSite")
                                        .font(.caption)
                                    
                                }
                            }.buttonStyle(.plain)
                        }
                    }
                }.scrollIndicators(.hidden)
                
            }.padding()
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 10)
                .foregroundColor(uiColor.system)
            
        }
        .scrollIndicators(.hidden)
        .refreshable {
            print("Refresh")
        }
    }
}
#Preview{
    HomeTabView4()
}
