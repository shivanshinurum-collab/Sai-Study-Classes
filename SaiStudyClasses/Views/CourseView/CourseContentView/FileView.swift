import SwiftUI

struct FileView : View {
    let image : String
    let name : String 
    
    var body: some View {
        HStack(spacing: 20){
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 70,height: 70)
            
            Text(name)
                .font(.title2)
                .foregroundColor(.black)
            
            
            
            Spacer()
            
            Image(systemName: "triangle.fill")
                .font(.subheadline)
                .foregroundColor(uiColor.DarkGrayText)
                .rotationEffect(Angle(degrees: 90))
        }.padding()
    }
}

