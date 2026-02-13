import SwiftUI

struct SettingsTabView: View {
    @Environment(TrimetClient.self) var client
    @Environment(TransitData.self) var data
    
    var body: some View {
        Button {
            Task {
                if let vehicles = try? await client.fetchVehicleList() {
                    data.vehicleList = vehicles
                }
            }
        } label: {
            Text("Refresh Vehicle Positions")
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .buttonRepeatBehavior(.disabled)
    }
}
