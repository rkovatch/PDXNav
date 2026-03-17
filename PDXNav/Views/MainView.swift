import SwiftUI
import MapKit
import Observation

@Observable
class TransitData {
    var routeList: [TransitRoute] = []
    var vehicleList: [Vehicle] = []
    var refreshInterval: Int = 5
    var isFirstLoad: Bool = true
}

struct MainView: View {
    @Environment(TrimetClient.self) var client
    
    @State private var data = TransitData()
    @State private var showBottomSheet = true
    @State private var currentDetent: PresentationDetent = .medium
    
    var body: some View {
        Map {
            ForEach(data.vehicleList) { vehicle in
                Annotation(
                    vehicle.signMessage,
                    coordinate: CLLocationCoordinate2D(
                        latitude: vehicle.latitude,
                        longitude: vehicle.longitude
                    )
                ) {
                    if let vehicleBearing = vehicle.bearing {
                        Image(systemName: "arrowshape.up.circle.fill")
                            .foregroundStyle(Color(hex: vehicle.routeColor))
                            .rotationEffect(Angle(degrees: Double(vehicleBearing)))
                            .frame(width: 10, height: 10)
                    } else {
                        Image(systemName: "smallcircle.filled.circle.fill")
                            .foregroundStyle(Color(hex: vehicle.routeColor))
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
#if os(iOS)
        .sheet(isPresented: $showBottomSheet) {
            BottomSheetView()
                .presentationDetents([.fraction(0.3), .medium, .large], selection: $currentDetent)
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
                .environment(client)
                .environment(data)
        }
#endif
        .task {
            while true {
                async let routes = client.fetchRouteList()
                async let vehicles = client.fetchVehicleList()
                
                data.routeList = (try? await routes) ?? []
                data.vehicleList = (try? await vehicles) ?? []
                data.isFirstLoad = false
                
                try? await Task.sleep(for: .seconds(data.refreshInterval))
            }
        }
    }
}
