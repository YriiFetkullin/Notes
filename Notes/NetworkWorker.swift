//
//  NetworkWorker.swift
//  Notes
//
//  Created by NarkoDiller on 22.05.2022.
//

import Foundation
import UIKit

protocol NetworkWorkerProtocol {
    func getNotes(completion: @escaping (Result<[NotesModel], Error>) -> Void)
}

class NetworkWorker: NetworkWorkerProtocol {
    let session: URLSession

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func getNotes(completion: @escaping (Result<[NotesModel], Error>) -> Void) {
        guard let url = createURLComponents() else { return }

        let task = session.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(.failure("Неверный URL"))
                return
            }

            do {
                let model = try JSONDecoder().decode([NotesModel].self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
        urlComponents.path = "/v0/b/ios-test-ce687.appspot.com/o/lesson8.json"
        urlComponents.queryItems = [
            URLQueryItem(name: "alt", value: "media"),
            URLQueryItem(name: "token", value: "215055df-172d-4b98-95a0-b353caca1424")
        ]
        return urlComponents.url
    }
}
