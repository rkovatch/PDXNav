enum RouteType: String, Codable {
    case bus = "B"
    case rail = "R"
}

enum RouteSubtype: String, Codable {
    case aerialTram = "Aerial Tram"
    case BRT = "BRT"
    case bus = "Bus"
    case commuterRail = "Commuter Rail"
    case lightRail = "Light Rail"
    case streetcar = "Streetcar"
}

struct Route: Codable, Identifiable {
    var id: Int
    var desc: String
    var detour: Bool?
    var frequentService: Bool
    var route: Int
    var routeColor: String
    var routeSortOrder: Int
    var routeSubType: RouteSubtype
    var type: RouteType
    var activeVehicles: Array<Vehicle>?
}

struct RouteConfigResultSet: Codable {
    var route: Array<Route>
}

struct RouteConfigResponseModel: Codable {
    var resultSet: RouteConfigResultSet
}
