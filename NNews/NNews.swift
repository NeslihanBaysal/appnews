
import SwiftUI

@main
    struct NNews: App {
    
    @StateObject var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(articleBookmarkVM)
        }
    }
}
