import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            ChecksView()
                .tabItem {
                    Label("Checks", systemImage: "checkmark.circle.fill")
                }
                .tag(1)
            
            JailbreakCompatibilityView()
                .tabItem {
                    Label("Jailbreak", systemImage: "lock.open.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
