import SwiftUI

private let delayFormatter: DateComponentsFormatter = {
    let f = DateComponentsFormatter()
    f.allowedUnits = [.hour, .minute, .second]
    f.unitsStyle = .full
    f.zeroFormattingBehavior = [.dropAll]
    return f
}()


struct RectangularBadge: View {
    var text: String
    var color: Color
    
    var body: some View {
        Text(text.uppercased())
            .padding()
            .background(Capsule().foregroundStyle(color))
    }
}

struct VehicleDetailView: View {
    @Environment(TransitData.self) var data
    var vehicleId: Int
    
    var body: some View {
        if let vehicle = data.vehicleList.first(where: { $0.id == vehicleId }) {
            HStack {
                ZStack {
                    Group {
                        if let lineNumber = vehicle.signMessageLong.split(separator: " ").first {
                            Text(lineNumber)
                        } else {
                            Text(vehicle.type.rawValue.uppercased())
                        }
                    }
                    .padding()
                    .background(
                        Circle().foregroundStyle(Color(hex: vehicle.routeColor))
                    )
                }
                
                VStack {
                    Text(vehicle.signMessage)
                        .font(.largeTitle.bold())
                        .padding(.top, 25)
                    if let fromGarage = vehicle.garage {
                        Text(
                            "\(vehicle.routeSubType.rawValue) hailing from \(fromGarage.rawValue.capitalized(with: .current)) garage"
                        )
                    } else {
                        Text(vehicle.routeSubType.rawValue)
                    }
                    
                    if let bearing = vehicle.bearing {
                        if 315 < bearing && bearing <= 45 {
                            Text("Heading northbound")
                        } else if 45 < bearing && bearing <= 135 {
                            Text("Heading eastbound")
                        } else if 135 < bearing && bearing <= 225 {
                            Text("Heading southbound")
                        } else if 225 < bearing && bearing <= 315 {
                            Text("Heading westbound")
                        }
                    }
                    
                    if vehicle.delay != 0 {
                        let delay = TimeInterval(abs(vehicle.delay))
                        let delayStr = delayFormatter.string(from: delay) ?? "\(abs(vehicle.delay)) seconds"
                        let direction = vehicle.delay < 0 ? "ahead" : "behind"  // a negative delay indicates running AHEAD of time
                        Text("Running \(delayStr) \(direction)")
                    } else {
                        Text("Running on time")
                    }
                }
            }
            
            if let loadPercentage = vehicle.loadPercentage, loadPercentage > 0 {
                ProgressView(value: Float(loadPercentage) * 0.01) {
                    Text("\(loadPercentage)% full")
                }
                .padding()
            } else {
                ProgressView(value: 0.0) {
                    Text("No capacity information available")
                        .foregroundStyle(.gray)
                }
                .padding()
            }
            
            HStack {
                if let inCongestion = vehicle.inCongestion {
                    if inCongestion {
                        RectangularBadge(text: "In Congestion", color: .red)
                    } else {
                        RectangularBadge(text: "No Congestion", color: .green)
                    }
                }
                
                if vehicle.offRoute {
                    RectangularBadge(text: "Off Route", color: .red)
                } else {
                    RectangularBadge(text: "On Route", color: .green)
                }
            }
            
        } else {
            Text("Vehicle information not available for ID \(vehicleId)")
        }
    }
}
