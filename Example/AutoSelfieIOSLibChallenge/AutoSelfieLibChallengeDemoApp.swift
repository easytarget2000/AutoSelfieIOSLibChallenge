import SwiftUI

@main
struct AutoSelfieLibChallengeDemoApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: ContentViewModel(),
                wrapperView: AutoSelfieWrapperView()
            )
        }
    }
    
}
