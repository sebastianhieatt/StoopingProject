import SwiftUI

struct WorkInProgressView: View {
    let title: String

    var body: some View {
        ScrollView {

            VStack(alignment: .leading, spacing: 16) {

                if title == "Rules and Guidelines" {

                    Text("📌 The only rules are:")
                        .font(.title3)
                        .fontWeight(.bold)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("1. 10 items per checkout")
                        Text("2. 1 checkout per week")
                        Text("3. Everything is free")
                    }
                    .font(.body)

                } else {

                    Text("Work in Progress 🚧")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle(title)
    }
}
