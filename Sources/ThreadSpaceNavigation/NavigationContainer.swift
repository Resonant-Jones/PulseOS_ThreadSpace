// Root wrapper presenting destinations based on router state
struct NavigationContainer: View {
 @StateObject var router = Router()

 var body: some View {
 NavigationStack(path: $router.path) {
 // Present destinations here
 }
 .environmentObject(router)
}
