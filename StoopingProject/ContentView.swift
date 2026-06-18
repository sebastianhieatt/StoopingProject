import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            DonationsView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Donate")
                }

            WorkInProgressView(title: "Checkout")
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Checkout")
                }
        }
        
    }
}
