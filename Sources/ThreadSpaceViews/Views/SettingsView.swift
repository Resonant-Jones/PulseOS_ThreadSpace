//
//  SettingsView.swift
//  ThreadSpace
//
//  Created by Christopher Castillo on 7/26/25.
//



import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @AppStorage("trackSteps") private var trackSteps = true
    @AppStorage("trackWater") private var trackWater = true
    @AppStorage("trackSleep") private var trackSleep = true

    var body: some View {
        VStack(spacing: 20) {
            Text("⚙️ Settings")
                .font(.largeTitle)
                .fontWeight(.semibold)

            Text("Configure your preferences, privacy options, and companion settings here.")
                .multilineTextAlignment(.center)
                .padding()

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                Text("📊 HealthKit Summary")
                    .font(.headline)

                Text(healthKitManager.isAuthorized ? "✅ HealthKit Authorized" : "❌ HealthKit Not Authorized")

                if let steps = healthKitManager.stepCountToday {
                    Text("👣 Steps Today: \(steps)")
                }

                if let water = healthKitManager.waterIntakeToday {
                    Text("💧 Water Intake: \(String(format: "%.1f", water)) L")
                }

                if let sleep = healthKitManager.sleepHoursToday {
                    Text("🛌 Sleep: \(String(format: "%.1f", sleep)) hrs")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                Text("⚙️ Tracking Preferences")
                    .font(.headline)

                Toggle("Track Steps", isOn: $trackSteps)
                Toggle("Track Water Intake", isOn: $trackWater)
                Toggle("Track Sleep", isOn: $trackSleep)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Settings")
    }
}
