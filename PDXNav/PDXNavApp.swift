import SwiftUI
import SwiftData

@main
struct PDXNavApp: App {
    
    @State private var client: TrimetClient
    
    init() {
        guard let api_key = Bundle.main.object(forInfoDictionaryKey: "TRIMET_API_KEY") as? String else {
            fatalError("Missing TRIMET_API_KEY from Info.plist")
        }
        
        do {
            let initialized_client = try TrimetClient(app_id: api_key)
            _client = State(initialValue: initialized_client)
        } catch {
            fatalError("Failed to initialize TrimetClient: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TransitMapView()
        }
        .environment(client)
    }
}
