import SwiftUI

struct temp : View {
    let img = URL(string: "https://nbg1.your-objectstorage.com/cdnsecure/app2.lmh-ai.in/uploads/students/4bd41d66fc4d95567ec8063d5724c98a.jpeg")
    var body: some View {
        AsyncImage(url: img ){ image in
            image
                .image?.resizable()
                .scaledToFit()
                
        }
        Text("jalkfjdslkfjalkdjfkajsdflk")
    }
}
#Preview {
    temp()
}
