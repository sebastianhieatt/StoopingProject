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

                } else if title == "About Us" {

                    VStack(alignment: .leading, spacing: 16) {

                        Text("Stooping Club is the world's first free online chain store. We offer new and preloved household items at no cost to promote sustainability and community sharing.")

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Our Vision")
                                .font(.headline)

                            Text("To transform society's throwaway culture into a reuse culture and build a circular economy.")
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Our Mission")
                                .font(.headline)

                            Text("To give useful items a second life by making reuse free and accessible for everyone.")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

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
