import SwiftUI

struct DigitalEbookView : View {
    
    @Binding var path : NavigationPath
    
    var body : some View {
        ZStack {
            uiColor.ButtonBlue
                .ignoresSafeArea(edges: .top)

            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .bold()
                }

                Spacer()

                Text("Digital Ebook")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .bold()

                Spacer()

                Color.clear.frame(width: 24)
            }
            .padding(.horizontal)
            .padding(.top, 50)
        }.ignoresSafeArea()
        .frame(height: 50)
        .navigationBarBackButtonHidden(true)
        NotFoundView(title: "Not Found Data", about: "")
    }
}

