import SwiftUI

struct BottomSheetView: View {
    @Environment(TransitData.self) var data
    
    var body: some View {
        if data.isFirstLoad {
            ProgressView {
                Text("Loading transit data...")
            }
            .progressViewStyle(.circular)
            .padding()
        } else {
            TabView {
                Tab("Lines", systemImage: "train.side.front.car") {
                    NavigationStack {
                        LinesTabView()
                    }
                }
                
                Tab("Favorites", systemImage: "star") {
                    EmptyView()
                }
                
                Tab("Settings", systemImage: "gear") {
                    SettingsTabView()
                }
            }
        }
    }
}
