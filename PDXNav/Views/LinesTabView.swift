import SwiftUI

struct LinesTabView: View {
    @Environment(TransitData.self) var data
    
    var body: some View {
        Text("Active Lines")
            .font(.largeTitle.bold())
            .padding(.top, 25)
        
        List(data.routeList, id: \.id) { route in
            DisclosureGroup {
                ForEach(data.vehicleList.filter {$0.routeNumber == route.id}) { vehicle in
                    NavigationLink(destination: {
                        VehicleDetailView(vehicle: vehicle)
                    }, label: {
                        Text(vehicle.signMessageLong)
                    })
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
