import SwiftUI

struct DonationsView: View {
    var body: some View {
        ScrollView {

            VStack(alignment: .leading, spacing: 18) {

                Text("Donate")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("""
Thank you for considering donating to Stooping Club. Please only donate items you would feel comfortable giving to your friends or family.
""")

                Group {
                    Text("Quality of Donations")
                        .font(.headline)

                    Text("""
We accept items that are new or gently used. We do not accept items that are broken, incomplete, heavily worn, unsafe, and/or inappropriate.
""")
                }

                Group {
                    Text("What We Accept")
                        .font(.headline)

                    Text("""
• Household & home goods
• Kitchenware & small appliances
• Clothing, shoes & accessories
• Bedding, linens & towels (new only)
• Books, textbooks & media
• Electronics (working condition)
• Storage & organization items
• Office & school supplies
• Toys, games & recreational items
• Garden, party & holiday supplies
• Musical instruments
• Health, fitness, baby & self-care items (new only)
""")
                }

                Group {
                    Text("How to Donate")
                        .font(.headline)

                    Text("""
Please submit the form below with photos and brief descriptions. We'll follow up with drop-off details.
""")
                }

                // BUTTON
                Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSeKuDH4IhHSY8S5IufX0X5kv8_6F2Qkeyv8L-UhoFwRkDfLZg/viewform")!) {
                    Text("Donations Form")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.primaryGreen)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 10)

            }
            .padding()
        }
        .navigationTitle("Donations")
    }
}
