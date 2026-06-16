import SwiftUI

struct HomeView: View {

    @State private var showMenu = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                Text("Stooping Club")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Button(action: {
                    showMenu.toggle()
                }) {
                    HStack {
                        Text("Menu")
                        Spacer()
                        Image(systemName: showMenu ? "chevron.up" : "chevron.down")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(12)
                }

                if showMenu {
                    VStack(spacing: 12) {

                        NavIconButton(title: "Shop Now", icon: "bag.fill")
                        NavIconButton(title: "Impact at a Glance", icon: "chart.bar.fill")
                        NavIconButton(title: "Rules and Guidelines", icon: "list.bullet")
                        NavIconButton(title: "About Us", icon: "person.3.fill")
                        NavIconButton(title: "Checkout", icon: "cart.fill")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 5)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}

// ✅ THIS IS WHAT WAS MISSING
struct NavIconButton: View {
    let title: String
    let icon: String

    var body: some View {
        NavigationLink(destination: WorkInProgressView(title: title)) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 25)

                Text(title)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.green.opacity(0.15))
            .cornerRadius(12)
        }
    }
}
