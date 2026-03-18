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
                        VehicleDetailView(vehicleId: vehicle.id)
                    }, label: {
                        Text(vehicle.signMessageLong)
                    })
                }
            } label: {
                HStack {
                    Group {
                        Image(
                            systemName: route.type == .rail ? "lightrail.fill" : "bus.fill"
                        )
                        .foregroundStyle(Color(hex: route.routeColor))
                        .frame(width: 10, height: 10)
                        Text(route.desc)
                            .font(.headline)
                        Spacer()
                    }
                    .allowsHitTesting(false)  // prevent the entire label from activating the button
                    
                    Button {
                        if data.favoriteRoutes.contains(route.id) {
                            data.favoriteRoutes.remove(route.id)
                        } else {
                            data.favoriteRoutes.insert(route.id)
                        }
                    } label: {
                        Image(systemName: data.favoriteRoutes.contains(route.id) ? "star.fill" : "star")
                            .foregroundStyle(
                                data.favoriteRoutes.contains(route.id) ? Color.accentColor : Color.secondary
                            )
                            .contentShape(Rectangle())  // to restrict the Button's touch target
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
