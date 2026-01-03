import SwiftUI
struct ShortsTabView : View {
    @State var showToast : Bool = false
    
    var body: some View {
        VStack{
            
        }.onAppear{
            showToast = true
        }
        .toast(isShowing: $showToast, message: "No Testimonial found!")
    }
}
