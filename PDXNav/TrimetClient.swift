import Foundation
import Observation

@Observable
class TrimetClient {
    private let app_id: String
    
    init(app_id: String) throws {
        if app_id.count == 25 && app_id.allSatisfy(\.isHexDigit) {
            self.app_id = app_id
        } else {
            throw NetworkingError("app_id was of an invalid format.")
        }
    }
    
    @Sendable private func fetchTransitData<T: Codable>(endpoint: String, model: T.Type) async throws -> T? {
        print("Fetching \(endpoint)...")
        guard let url = URL(string: "https://developer.trimet.org/ws/\(endpoint)?appID=\(app_id)&json=true") else {
            throw NetworkingError("Invalid URL: https://developer.trimet.org/ws/\(endpoint)")
        }
        
        let decodedObj = try await URLSession.shared.decode(model, from: url)
        return decodedObj
    }
    
    @Sendable func fetchVehicleList() async throws -> [Vehicle] {
        let response = try await fetchTransitData(
            endpoint: "v2/vehicles",
            model: VehiclesResponseModel.self
        )
        return response?.resultSet.vehicle ?? []
    }
    
    @Sendable func fetchRouteList() async throws -> [Route] {
        let response = try await fetchTransitData(
            endpoint: "v1/routeConfig",
            model: RouteConfigResponseModel.self
        )
        return response?.resultSet.route ?? []
    }
    
}
