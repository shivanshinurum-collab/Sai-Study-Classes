import SwiftUI
struct CourseContent : View {
    
    @Binding var path : NavigationPath
    
    let batch_id : String
    
    @State var Documents : [ContentItem] = []
    @State var url : String = ""
    
    var body: some View {
        ScrollView{
            VStack(spacing: 15){
                ForEach($Documents ){ $item in
                    let imageURL = "https://nbg1.your-objectstorage.com/cdnsecure/app2.lmh-ai.in/uploads/batch_image/\(item.image ?? "")"
                    //EXam
                    if(item.contentType == "Exam"){
                        
                        let student_id = UserDefaults.standard.string(forKey: "studentId")
                        let exam_id = item.id
                        
                        let encryptedStudent = encryptToUrlSafe(student_id!)
                        let encryptedExam = encryptToUrlSafe(exam_id)
                        
                       let examURL = "https://saistudyclasses.com/exam-panel/\(encryptedStudent)/\(encryptedExam)"
                        Button{
                            path.append(Route.ExamInfo(title: item.insTitle ?? "", dis: item.insDesc ?? "", url: examURL))
                        }label: {
                            FileView(image: "exam", name: item.name , imageURL: imageURL)
                        }
                        
                        if(item.isResultAvailable == 1 ){
                            HStack{
                                Button{
                                    
                                }label: {
                                    Text("View Result")
                                }.frame(maxWidth: .infinity)
                                Button{
                                    
                                }label: {
                                    Text("Leaderboard")
                                }.frame(maxWidth: .infinity)
                            }
                        }
                    }
                    //Folder
                    else if(item.contentType == "Folder"){
                        
                        Button{
                            path.append(Route.FoldersView(BatchId: batch_id, FolderId: item.id))
                        }label: {
                            FileView(image: "folder", name: item.name , imageURL: imageURL)
                        }
                    }
                    //Document - PDF
                    else if(item.contentType == "Document"){
                        
                        let url = "\(url)book/\(item.redirectionUrl ?? "")"
                        Button{
                            path.append(Route.PDFview(url: url, title: item.name))
                            
                        }label: {
                            FileView(image: "pdf", name: item.name , imageURL: imageURL)
                        }
                    }
                    //Audio
                    else if(item.contentType == "Audio") {
                       
                        Button{
                            if(item.type == "audio"){
                                let url = "\(url)video/\(item.redirectionUrl ?? "")"
                                path.append(Route.AudioPlayerView(url: url, title: item.name))
                            }else{
                                
                            }
                            
                        }label: {
                            FileView(image: "audio", name: item.name , imageURL: imageURL)
                        }
                    }
                    //Link
                    else if(item.contentType == "Link") {
                       
                        Button{
                            path.append(Route.ExamView(ExamUrl: item.redirectionUrl ?? ""))
                        }label: {
                            FileView(image: "browser", name: item.name , imageURL: imageURL)
                        }
                        
                    }
                    //Video
                    else if(item.contentType == "Video"){
                        let videoimg = "https://nbg1.your-objectstorage.com/cdnsecure/app2.lmh-ai.in/uploads/video/\(item.image ?? "")"
                        Button{
                            if(item.type == "youtube"){
                                path.append(Route.YouTubeView(videoId: item.redirectionUrl ?? "" , title: item.name))
                            }else{
                                let videoURL = "https://nbg1.your-objectstorage.com/cdnsecure/app2.lmh-ai.in/uploads/\(item.redirectionUrl ?? "")"
                                //custom url
                                path.append(Route.VideoView(url: videoURL, title: item.name))
                            }
                        }label: {
                            FileView(image: "video", name: item.name , imageURL: videoimg)
                        }
                        
                    }
                    //Notes
                    else if(item.contentType == "notes"){
                        
                        let url = "\(url)notes/\(item.redirectionUrl ?? "")"
                        Button{
                            path.append(Route.PDFview(url: url, title: item.name))
                            
                        }label: {
                            FileView(image: "pdf", name: item.name , imageURL: imageURL)
                        }
                    }
                
                }
            }
        }
        
        .onAppear{
            fetchBatchContent()
        }
    }
    

    
    func fetchBatchContent() {
        let components = URLComponents(string: "https://app2.lmh-ai.in/api/HomeNew/manage_content/\(batch_id)")
        
        /*components?.queryItems = [
            URLQueryItem(name: "batch_id", value: batch_id),
            //URLQueryItem(name: "student_id", value: studentId)
        ]*/
        
        guard let url = components?.url else {
            print("❌ Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("❌ API Error:", error.localizedDescription)
                return
            }
            
            guard let data else {
                print("❌ No data received")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BatchContentResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.Documents = response.allData
                    self.url = response.fullUrl
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
}
import Foundation

extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}
