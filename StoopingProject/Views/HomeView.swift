import SwiftUI

struct HomeView: View {

    @State private var showMenu = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    Text("Stooping Club")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)

                    // MARK: - MENU BUTTON
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

                    // MARK: - MENU ITEMS
                    if showMenu {
                        VStack(spacing: 12) {

                            NavIconButton(title: "Shop Now", icon: "bag.fill")
                            NavIconButton(title: "How it Works", icon: "list.bullet")
                            NavIconButton(title: "About Us", icon: "person.3.fill")
                            NavIconButton(title: "Checkout", icon: "cart.fill")
                            NavIconButton(title: "FAQ", icon: "questionmark.circle.fill")
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 5)
                    }

                    // MARK: - IMPACT SECTION
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
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}

// MARK: - NAV BUTTON (FIXED ROUTING)
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
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.green.opacity(0.15))
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
            WorkInProgressView(title: "About Us")

        case "Shop Now":
            WorkInProgressView(title: "Shop Now")

        case "Checkout":
            WorkInProgressView(title: "Checkout")

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

    // MARK: - Helpers
    private func extractNumber(from text: String) -> Int {
        let cleaned = text
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "$", with: "")

        return Int(cleaned) ?? 0
    }

    private func extractSuffix(from text: String) -> String {
        var suffix = ""
        if text.contains("$") { suffix += "$" }
        if text.contains("+") { suffix += "+" }
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
            DispatchQueue.main.asyncAfter(deadline: .now() + stepTime * Double(i)) {
                displayedValue = Int(Double(value) * (Double(i) / Double(steps)))
            }
        }
    }
}
