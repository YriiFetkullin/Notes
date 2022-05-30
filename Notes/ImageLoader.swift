//
//  ImageLoader.swift
//  Notes
//
//  Created by NarkoDiller on 26.05.2022.
//

import Foundation
import UIKit

class ImageLoader {
    func loadImage(link: String?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let link = link, let url = URL(string: link) else {
            completion(.failure("Неверный URL"))
            return
        }
//        DispatchQueue.global().async {
//            do {
//                let data = try Data(contentsOf: url)
//                guard let image = UIImage(data: data) else {
//                    completion(.failure("Нет данных"))
//                    return
//                }
//                completion(.success(image))
//            } catch {
//                completion(.failure(error.localizedDescription))
//            }
//        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure("Нет данных"))
                return
            }
            completion(.success(image))
        }

        task.resume()
    }
}
