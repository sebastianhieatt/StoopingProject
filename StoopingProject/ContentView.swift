import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                Text("Stooping Club")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                NavigationLink(destination: DonationsView()) {
                    Text("Donations")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: 250)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
