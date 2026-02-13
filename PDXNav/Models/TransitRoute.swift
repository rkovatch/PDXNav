enum TransitRouteType: String, Codable {
    case bus = "B"
    case rail = "R"
}

enum TransitRouteSubtype: String, Codable {
    case aerialTram = "Aerial Tram"
    case BRT = "BRT"
    case bus = "Bus"
    case commuterRail = "Commuter Rail"
    case lightRail = "Light Rail"
    case streetcar = "Streetcar"
}

struct TransitRoute: Codable, Identifiable {
    var id: Int
    var desc: String
    var detour: Bool?
    var frequentService: Bool
    var route: Int
    var routeColor: String
    var routeSortOrder: Int
    var routeSubType: TransitRouteSubtype
    var type: TransitRouteType
    var activeVehicles: Array<Vehicle>?
}

struct TransitRouteConfigResultSet: Codable {
    var route: Array<TransitRoute>
}

struct TransitRouteConfigResponseModel: Codable {
    var resultSet: TransitRouteConfigResultSet
}
