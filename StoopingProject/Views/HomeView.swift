import SwiftUI

struct HomeView: View {
    @EnvironmentObject var shopify: ShopifyService

    @State private var showMenu = false

    var body: some View {

        NavigationView {

            ZStack(alignment: .leading) {

                // MAIN CONTENT
                ScrollView {

                    VStack(spacing: 20) {

                        Image("HomeBackground")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(20)
                            .padding(.top)

                        // IMPACT SECTION
                        VStack(spacing: 12) {

                            Text("Our Impact at a Glance")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 10)

                            ImpactCard(
                                title: "Unique Items Diverted From Landfill",
                                value: "2120+",
                                color: .green
                            )

                            ImpactCard(
                                title: "Customers Served",
                                value: "368",
                                color: .blue
                            )

                            ImpactCard(
                                title: "CO₂e Emissions Prevented (lbs)",
                                value: "15,000+",
                                color: .orange
                            )

                            ImpactCard(
                                title: "Money Saved by Customers",
                                value: "$70000+",
                                color: .purple
                            )
                        }

                        Spacer(minLength: 30)
                    }
                    .padding()
                }
                .disabled(showMenu)

                // DARK OVERLAY
                if showMenu {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showMenu = false
                            }
                        }
                }

                // SIDEBAR MENU
                HStack {

                    VStack(alignment: .leading, spacing: 24) {

                        Text("Stooping Club")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 50)


                        NavIconButton(
                            title: "How it Works",
                            icon: "list.bullet"
                        )

                        NavIconButton(
                            title: "About Us",
                            icon: "person.3.fill"
                        )

                        NavIconButton(
                            title: "FAQ",
                            icon: "questionmark.circle.fill"
                        )

                        NavIconButton(
                            title: "Checkout",
                            icon: "cart.fill"
                        )

                        Spacer()
                    }
                    .padding()
                    .frame(width: 270)
                    .background(Color.green)

                    Spacer()
                }
                .offset(x: showMenu ? 0 : -300)
                .animation(.easeInOut(duration: 0.25), value: showMenu)
            }
            .navigationTitle("Home")
            .toolbar {

                ToolbarItem(placement: .navigationBarLeading) {

                    Button {

                        withAnimation {
                            showMenu.toggle()
                        }

                    } label: {

                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                    }
                }
            }
            .onAppear {
                shopify.fetchNextPage()
                shopify.fetchCollections()
            }
        }
    }
}

#Preview {
    HomeView()
}

// MARK: - NAV BUTTON

struct NavIconButton: View {

    let title: String
    let icon: String

    var body: some View {

        NavigationLink(destination: destinationView()) {

            HStack {

                Image(systemName: icon)
                    .frame(width: 25)

                Text(title)

                Spacer()

                Image(systemName: "chevron.right")
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.white.opacity(0.15))
            .cornerRadius(12)
        }
    }

    @ViewBuilder
    private func destinationView() -> some View {

        switch title {

        case "FAQ":
            FAQView()

        case "How it Works":
            WorkInProgressView(title: "How it Works")

        case "About Us":
            AboutUsView()

        case "Shop Now":
            StoreListView()

        case "Checkout":
            CheckoutPageView()

        default:
            WorkInProgressView(title: title)
        }
    }
}

// MARK: - IMPACT CARD

struct ImpactCard: View {

    let title: String
    let value: String
    let color: Color

    var body: some View {

        VStack(spacing: 10) {

            AnimatedCountText(
                value: extractNumber(from: value),
                suffix: extractSuffix(from: value),
                duration: 1.5
            )
            .foregroundColor(color)

            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.12))
        .cornerRadius(16)
    }

    private func extractNumber(from text: String) -> Int {

        let cleaned = text
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "$", with: "")

        return Int(cleaned) ?? 0
    }

    private func extractSuffix(from text: String) -> String {

        var suffix = ""

        if text.contains("$") {
            suffix += "$"
        }

        if text.contains("+") {
            suffix += "+"
        }

        return suffix
    }
}

// MARK: - ANIMATED NUMBER

struct AnimatedCountText: View {

    let value: Int
    let suffix: String
    let duration: Double

    @State private var displayedValue: Int = 0

    var body: some View {

        Text("\(displayedValue)\(suffix)")
            .font(.system(size: 34, weight: .bold))
            .onAppear {
                animate()
            }
    }

    private func animate() {

        displayedValue = 0

        let steps = min(value, 60)

        guard steps > 0 else {
            displayedValue = value
            return
        }

        let stepTime = duration / Double(steps)

        for i in 1...steps {

            DispatchQueue.main.asyncAfter(
                deadline: .now() + stepTime * Double(i)
            ) {

                displayedValue = Int(
                    Double(value) * (Double(i) / Double(steps))
                )
            }
        }
    }
}
