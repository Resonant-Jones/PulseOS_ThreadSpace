// Custom button triggering navigation via router
struct NavButton: View {
 let destination: Destination
 let label: String

 var body: some View {
 Button(action: {
 Router.shared.navigate(to: destination)
 }) {
 Text(label)
 }
 }
}
