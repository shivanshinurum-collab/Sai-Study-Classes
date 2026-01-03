import SwiftUI

struct StoreTabView : View {
    let title = "No Digital Content Available"
    let about = "Please check back later or explore our courses collection for more learning resources."
    var body: some View {
        NotFoundView(title: title, about: about)
    }
}
