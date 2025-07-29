import Foundation

/// A singleton service to load, save, and update user settings.
/// This allows the companion and app to dynamically adjust based on preferences.
final class UserSettingService: ObservableObject {
    static let shared = UserSettingService()

    @Published private(set) var currentSettings: UserSettings

    private let settingsKey = "ThreadSpace_UserSettings"

    private init() {
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(UserSettings.self, from: data) {
            self.currentSettings = decoded
        } else {
            self.currentSettings = UserSettings()
        }
    }

    // MARK: - Update Settings

    func update(_ updateBlock: (inout UserSettings) -> Void) {
        var updated = currentSettings
        updateBlock(&updated)
        updated.lastUpdated = Date()
        currentSettings = updated
        save()
    }

    // MARK: - Save

    private func save() {
        if let encoded = try? JSONEncoder().encode(currentSettings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }

    // MARK: - Reset to Defaults

    func resetToDefaults() {
        currentSettings = UserSettings()
        save()
    }
}