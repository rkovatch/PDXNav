import SwiftUI

struct SettingsTabView: View {
    @Environment(TrimetClient.self) var client
    @Environment(TransitData.self) var data
    
    var body: some View {
        VStack {
            HStack {
                Label("Vehicle Refresh Interval: ", systemImage: "arrow.clockwise.circle.fill")
                Picker(
                    "Vehicle Refresh Interval",
                    selection: Binding(get: {data.refreshInterval}, set: {data.refreshInterval = $0})
                ) {
                    Text("5 seconds").tag(5)
                    Text("10 seconds").tag(10)
                    Text("15 seconds").tag(15)
                    Text("30 seconds").tag(30)
                    Text("1 minute").tag(60)
                }
            }
            
            Button {
                Task {
                    if let vehicles = try? await client.fetchVehicleList() {
                        data.vehicleList = vehicles
                    }
                }
            } label: {
                Text("Refresh Vehicles Now")
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .buttonRepeatBehavior(.disabled)
        }
    }
}
