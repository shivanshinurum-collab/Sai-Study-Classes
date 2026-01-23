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
                    let imageURL = "\(url)batch_image/\(item.image ?? "")"
                    //EXam
                    if(item.contentType == "Exam"){
                        
                        let student_id = UserDefaults.standard.string(forKey: "studentId")
                        let exam_id = item.id
                        
                        let encryptedStudent = encryptToUrlSafe(student_id!)
                        let encryptedExam = encryptToUrlSafe(exam_id)
                        
                       let examURL = "\(uiString.baseURL)exam-panel/\(encryptedStudent)/\(encryptedExam)"
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
                        let videoimg = "\(url)video/\(item.image ?? "")"
                        Button{
                            if(item.type == "youtube"){
                                path.append(Route.YouTubeView(videoId: item.redirectionUrl ?? "" , title: item.name))
                            }else{
                                let videoURL = "\(url)\(item.redirectionUrl ?? "")"
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
                            print(url)
                            path.append(Route.PDFview(url: url, title: item.name))
                            
                        }label: {
                            FileView(image: "pdf", name: item.name , imageURL: imageURL)
                        }
                    }
                    //Document - PDF
                    else if(item.contentType == "Document"){
                        
                        let url = "\(url)book/\(item.redirectionUrl ?? "")"
                        Button{
                            print(url)
                            path.append(Route.AllDocView(title: item.name, url: url))
                            //path.append(Route.ExamView(ExamUrl: url))
                            //path.append(Route.PDFview(url: url, title: item.name))
                            
                        }label: {
                            if url.contains(".xls") {
                                FileView(image: "xls", name: item.name , imageURL: imageURL)
                            }
                            else if url.contains(".doc") {
                                FileView(image: "doc", name: item.name , imageURL: imageURL)
                            }
                            else if url.contains(".pdf") {
                                FileView(image: "pdf", name: item.name , imageURL: imageURL)
                            }
                            else if url.contains(".txt") {
                                FileView(image: "txt", name: item.name , imageURL: imageURL)
                            }
                            else if url.contains(".pptx") {
                                FileView(image: "pptx", name: item.name , imageURL: imageURL)
                            }
                            else{
                                FileView(image: "otherDoc", name: item.name , imageURL: imageURL)
                            }
                        }
                    }
                
                }
            }
        }
        
        .onAppear{
            fetchBatchContent()
        }
    }
  /*
    if(data.getRedirectionUrl().contains(".xlsx")){
        imgDocument.setImageDrawable(mContext.getDrawable(R.drawable.xls));
    }else if(data.getRedirectionUrl().contains(".doc")){
        imgDocument.setImageDrawable(mContext.getDrawable(R.drawable.doc));
    }else if(data.getRedirectionUrl().contains(".pdf")){
        imgDocument.setImageDrawable(mContext.getDrawable(R.drawable.ic_pdf));
    }else if(data.getRedirectionUrl().contains(".txt")){
        imgDocument.setImageDrawable(mContext.getDrawable(R.drawable.text));
    }else{
        imgDocument.setImageDrawable(mContext.getDrawable(R.drawable.other_doc));
    }
   
   
   
   
   if(myurl.contains(".pptx")){
       myurl = "https://view.officeapps.live.com/op/view.aspx?src= https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf" + Uri.encode(myurl);
   }else if(myurl.contains(".docx")){
       myurl = "https://view.officeapps.live.com/op/view.aspx?src=" + myurl;
   }
   
   
   
    */
    
    func fetchBatchContent() {
        let components = URLComponents(string: "\(uiString.baseURL)api/HomeNew/manage_content/\(batch_id)")
        print("MAIN URL API \(String(describing: components))")
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
               print("Bach ID = ",batch_id)
                print(response)
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
