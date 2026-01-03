import SwiftUI

struct NoticeBoardView: View {
    @Binding var path : NavigationPath
    
    let notices: [NoticeModel] = [
        NoticeModel(
            title: "କାଲି ସକାଳ ସମୟ 9:30 am & 11 am ରେ",
            subtitle: "Reasoning and Math class ହେବ",
            description: "କାଲି ସକାଳ ସମୟ 9:30 am & 11 am ରେ Reasoning and Math class ହେବ",
            date: "2025-10-10"
        ),
        NoticeModel(
            title: "କାଲି ସକାଳ ସମୟ 9:30 am & 11 am ରେ",
            subtitle: "Reasoning and Math class ହେବ",
            description: "କାଲି ସକାଳ ସମୟ 9:30 am & 11 am ରେ Reasoning and Math class ହେବ",
            date: "2025-10-10"
        )
    ]

    var body: some View {
        ZStack {
            VStack(spacing: 10) {


                ZStack {
                    uiColor.ButtonBlue
                        .ignoresSafeArea(edges: .top)

                    HStack {
                        Button {
                            path.removeLast()
                        } label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(uiColor.white)
                        }

                        Spacer()

                        Text(uiString.NoticeTitle)
                            .foregroundColor(uiColor.white)
                            .font(.system(size: 18, weight: .semibold))

                        Spacer()

                        Color.clear.frame(width: 24)
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)
                }
                .frame(height: 100)
                .clipShape(
                    RoundedCorner(
                        radius: 20,
                        corners: [.bottomLeft, .bottomRight]
                    )
                )

               
                List {
                    ForEach(notices) { notice in
                        NoticeCell(notice: notice)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .padding(.horizontal)
            }
        }.navigationBarBackButtonHidden(true)
        .ignoresSafeArea(edges: .top)
    }
}

struct NoticeCell: View {
    
    let notice: NoticeModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(notice.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            Text(notice.subtitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
            
            Text(notice.description)
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .padding(.top, 4)
            
            HStack {
                Spacer()
                Text(notice.date)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.12),
                radius: 10, x: 5, y: 5)
        .padding(13)
    }
}

