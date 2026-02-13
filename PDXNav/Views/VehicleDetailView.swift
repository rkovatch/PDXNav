import SwiftUI

struct VehicleDetailView: View {
    var vehicle: Vehicle
    
    var body: some View {
        Text(vehicle.signMessage)
            .font(.largeTitle.bold())
            .padding(.top, 25)
        Text("\(String(describing: vehicle.loadPercentage ?? -1))% full")
        vehicle.inCongestion ?? false ? Text("Vehicle is in congestion") : Text("Vehicle is not in congestion")
        vehicle.offRoute ? Text("Vehicle is off route") : Text("Vehicle is on route")
    }
}
