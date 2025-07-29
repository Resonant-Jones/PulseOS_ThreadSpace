
import SwiftUI

struct LoggerView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager

    var body: some View {
        VStack(spacing: 20) {
            Text("📝 Logger View")
                .font(.largeTitle)
                .fontWeight(.semibold)

            Text("This is where you'll track your mood, thoughts, and health data.")
                .multilineTextAlignment(.center)
                .padding()

            Divider()

            Button(action: {
                healthKitManager.logWaterIntake(amountInLiters: 0.25)
            }) {
                Label("Log 250ml Water", systemImage: "drop.fill")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            if let water = healthKitManager.waterIntakeToday {
                Text("💧 Today's Water: \(String(format: "%.2f", water)) L")
                    .padding(.top, 10)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Logger")
    }
}

