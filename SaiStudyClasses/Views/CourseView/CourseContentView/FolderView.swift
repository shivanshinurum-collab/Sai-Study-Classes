import SwiftUI

struct FolderView : View {
    let image : String
    let name : String
    let folderNo : String
    let fileNo : String
    
    var body : some View {
        HStack(spacing: 20){
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 70,height: 70)
            
            VStack(alignment: .leading){
                Text(name)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                
                Text("\(folderNo) folders \(fileNo) files")
                    .font(.headline)
                    .foregroundColor(uiColor.DarkGrayText)
            }
            
            Spacer()
            
            Image(systemName: "triangle.fill")
                .font(.subheadline)
                .foregroundColor(uiColor.DarkGrayText)
                .rotationEffect(Angle(degrees: 90))
        }.padding()
    }
}

