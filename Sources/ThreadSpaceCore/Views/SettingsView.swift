import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsService = UserSettingService.shared

    var body: some View {
        Form {
            Section(header: Text("Companion Personality")) {
                TextField("Companion Name", text: binding(\.companionName))
                Picker("Tone", selection: binding(\.defaultTone)) {
                    ForEach(CompanionTone.allCases, id: \.self) { tone in
                        Text(tone.rawValue.capitalized).tag(tone)
                    }
                }
                Picker("Emotion", selection: binding(\.defaultEmotion)) {
                    ForEach(CompanionEmotion.allCases, id: \.self) { emotion in
                        Text(emotion.rawValue.capitalized).tag(emotion)
                    }
                }
            }

            Section {
                Button("Reset to Defaults") {
                    settingsService.resetToDefaults()
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("ThreadSpace Settings")
    }

    private func binding<Value>(_ keyPath: WritableKeyPath<UserSettings, Value>) -> Binding<Value> {
        Binding(
            get: { settingsService.currentSettings[keyPath: keyPath] },
            set: { newValue in
                settingsService.update { $0[keyPath: keyPath] = newValue }
            }
        )
    }
}