//
//  NetworkLayer.swift
//  Calorico
//
//  Created by Dane Jensen on 4/3/23.
//
/*
import Foundation

enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

enum HTTPScheme: String {
    case http
    case https
}

/// The API protocol allows us to separate the task of constructing a URL,
/// its parameters, and HTTP method from the act of executing the URL request
/// and parsing the response.
protocol API {
    /// .http  or .https
    var scheme: HTTPScheme { get }

    // Example: "maps.googleapis.com"
    var baseURL: String { get }

    // "/maps/api/place/nearbysearch/"
    var path: String { get }

    // [URLQueryItem(name: "api_key", value: API_KEY)]
    var parameters: [URLQueryItem] { get }

    // "GET"
    var method: HTTPMethod { get }
}

// This particular API will not work without an API KEY
enum GooglePlacesAPI: API {
    case getNearbyPlaces(searchText: String?, latitude: Double,
                         longitude: Double)

    var scheme: HTTPScheme {
        switch self {
        case .getNearbyPlaces:
            return .https
        }
    }

    var baseURL: String {
        switch self {
        case .getNearbyPlaces:
            return "maps.googleapis.com"
        }
    }

    var path: String {
        switch self {
        case .getNearbyPlaces:
            return "/maps/api/place/nearbysearch/json"
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .getNearbyPlaces(let query, let latitude, let longitude):
            var params = [
                URLQueryItem(name: "key", value: GooglePlacesAPI.key),
                URLQueryItem(name: "language",
                             value: Locale.current.languageCode),
                URLQueryItem(name: "type", value: "restaurant"),
                URLQueryItem(name: "radius", value: "6500"),
                URLQueryItem(name: "location",
                             value: "\(latitude),\(longitude)")
            ]

            if let query = query {
                params.append(URLQueryItem(name: "keyword", value: query))
            }
            return params
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getNearbyPlaces:
            return .get
        }
    }
}

// Network Layer Implementation
final class NetworkManager {
    /// Builds the relevant URL components from the values specified
    /// in the API.
    private class func buildURL(endpoint: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        return components
    }

    /// Executes the HTTP request and will attempt to decode the JSON
    /// response into a Codable object.
    /// - Parameters:
    ///   - endpoint: the endpoint to make the HTTP request to
    ///   - completion: the JSON response converted to the provided Codable
    /// object when successful or a failure otherwise
    class func request<T: Decodable>(endpoint: API, completion: @escaping (Result<T, Error>) -> Void) {
        let components = buildURL(endpoint: endpoint)
        guard let url = components.url else {
            Log.error("URL creation error")
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue

        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                Log.error("Unknown error", error)
                return
            }

            guard response != nil, let data = data else {
                return
            }

            if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(responseObject))
            } else {
                let error = NSError(domain: "com.AryamanSharda", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed"])
                completion(.failure(error))
            }
        }

        dataTask.resume()
    }
}
*/
