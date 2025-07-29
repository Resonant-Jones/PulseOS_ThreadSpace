// ObservableObject managing navigation state
class Router: ObservableObject {
 @Published var path: [Destination] = []

 func navigate(to destination: Destination) {
 path.append(destination)
 }

 func back() {
 path.popLast()
 }
}
