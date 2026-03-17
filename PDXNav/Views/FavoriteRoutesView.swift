import SwiftUI

struct FavoriteRoutesView: View {
    @Environment(TransitData.self) var data
    
    var body: some View {
        Text("Favorite Lines")
            .font(.largeTitle.bold())
            .padding(.top, 25)
        
        List(Array(data.favoriteRoutes), id: \.self) { routeId in
            if let route = data.routeList.first(where: { $0.id == routeId }) {
                DisclosureGroup {
                    ForEach(data.vehicleList.filter {$0.routeNumber == routeId}) { vehicle in
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
}
