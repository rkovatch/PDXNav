import SwiftUI
import Metal

enum VehicleType: String, Codable {
    case bus = "bus"
    case rail = "rail"
}

enum VehicleSource: String, Codable {
    case aim = "aim"
    case vm = "vm"
    case tab = "tab"
}

enum Garage: String, Codable {
    case powell = "POWELL"
    case merlo = "MERLO"
    case center = "CENTER"
    case ruby = "RUBY"
    case elmo = "ELMO"
}

struct Vehicle: Codable, Identifiable {
    var bearing: Int?
    var blockID: Int
    var delay: Int
    var direction: Int
    var expires: MTLTimestamp
    var extraBlockID: Int?
    var garage: Garage?
    var inCongestion: Bool?
    var lastLocID: Int?
    var lastStopSeq: Int?
    var latitude: Float64
    var loadPercentage: Int?
    var locationInScheduleDay: Int
    var longitude: Float64
    var messageCode: Int
    var newTrip: Bool
    var nextLocID: Int
    var nextStopSeq: Int?
    var offRoute: Bool
    var routeColor: String
    var routeNumber: Int
    var routeSubType: RouteSubtype
    var serviceDate: MTLTimestamp
    var signMessage: String
    var signMessageLong: String
    var source: VehicleSource
    var time: MTLTimestamp
    var tripID: String
    var type: VehicleType
    var vehicleID: Int
    var id: Int {
        vehicleID
    }
}

struct VehiclesResultSet: Codable {
    var queryTime: Int64
    var vehicle: Array<Vehicle>
}

struct VehiclesResponseModel: Codable {
    var resultSet: VehiclesResultSet
}
