//
//  NetworkWorker.swift
//  Notes
//
//  Created by NarkoDiller on 22.05.2022.
//

import Foundation

protocol NetworkWorkerProtocol {
    func getNotes(completion: @escaping (Result<[NotesModel], Error>) -> Void)
}

class NetworkWorker: NetworkWorkerProtocol {
    let session: URLSession

    init(
        session: URLSession = URLSession(configuration: .default)
    ) {
        self.session = session
    }

    func getNotes(completion: @escaping (Result<[NotesModel], Error>) -> Void) {
        guard let url = createURLComponents() else { return }

        let task = session.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            do {
                let model = try JSONDecoder().decode([NotesModel].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    private func createURLComponents() -> URL? {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "firebasestorage.googleapis.com"
        urlComponents.path = "/v0/b/ios-test-ce687.appspot.com/o/Empty.json"
        urlComponents.queryItems = [
            URLQueryItem(name: "alt", value: "media"),
            URLQueryItem(name: "token", value: "d07f7d4a-141e-4ac5-a2d2-cc936d4e6f18")
        ]
        return urlComponents.url
    }
}
