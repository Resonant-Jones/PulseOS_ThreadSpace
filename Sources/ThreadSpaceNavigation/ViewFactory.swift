// Maps each Destination enum case to its corresponding SwiftUI view
struct ViewFactory {
 static func view(for destination: Destination) -> some View {
 switch destination {
 case .home:
 return HomeView()
 case .profile:
 return ProfileView()
 case .settings:
 return SettingsView()
 }
 }
}
