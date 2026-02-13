import SwiftUI
import MapKit
import Observation

@Observable
class TransitData {
    var routeList: [TransitRoute] = []
    var vehicleList: [Vehicle] = []
    var isFirstLoad: Bool = true
}

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

struct LinesTabView: View {
    @Environment(TransitData.self) var data
    
    var body: some View {
        Text("Active Lines")
            .font(.largeTitle.bold())
            .padding(.top, 25)
        
        List(data.routeList, id: \.id) { route in
            DisclosureGroup {
                ForEach(data.vehicleList.filter {$0.routeNumber == route.id}) { vehicle in
                    Text(vehicle.signMessageLong)
                }
            } label: {
                HStack {
                    Image(
                        systemName: route.type == .rail ? "lightrail.fill" : "bus.fill"
                    )
                        .foregroundStyle(Color(hex: route.routeColor))
                        .frame(width: 10, height: 10)
                    Text(route.desc)
                        .font(.headline)
                }
            }
        }
    }
}

struct BottomSheetView: View {
    @Environment(TransitData.self) var data
    
    var body: some View {
        TabView {
            Tab("Lines", systemImage: "train.side.front.car") {
                LinesTabView()
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
            if data.isFirstLoad {
                ProgressView {
                    Text("Loading transit data...")
                }
                .progressViewStyle(.circular)
                .padding()
            } else {
                BottomSheetView()
                    .presentationDetents([.fraction(0.3), .medium, .large], selection: $currentDetent)
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
            }
        }
#endif
        .task {
            async let routes = client.fetchRouteList()
            async let vehicles = client.fetchVehicleList()
            
            data.routeList = (try? await routes) ?? []
            data.vehicleList = (try? await vehicles) ?? []
            data.isFirstLoad = false
        }
        .environment(data)
    }
}

#Preview {
    MainView()
}
