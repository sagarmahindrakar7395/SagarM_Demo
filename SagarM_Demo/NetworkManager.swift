//
//  NetworkManager.swift
//  SagarM_Demo
//
//  Created by APPLE on 12/19/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed
    case requestFailed(Error)
}

protocol NetworkManaging {
    func request<T: Decodable>(
        urlString: String,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

final class NetworkManager: NetworkManaging {

    static let shared = NetworkManager()
    private init() {}

    func request<T: Decodable>(
        urlString: String,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingFailed))
            }

        }.resume()
    }
}
