import SwiftUI

struct ContentView: View {

    var body: some View {

        TabView {

            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            StoreListView()
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Shop")
                }

            CheckoutPageView()
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Checkout")
                }

            DonationsView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Donate")
                }
        }
        .accentColor(AppTheme.primaryGreen)
    }
}
