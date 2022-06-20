//
//  NetworkMokeWorker.swift
//  NotesTests
//
//  Created by NarkoDiller on 18.06.2022.
//

import Foundation
@testable import Notes

class NetworkMockWorker: ListNotesWorkerLogic {
    var isSuccess: Bool
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    func getNotes(completion: @escaping (Result<[NotesModel], Error>) -> Void) {
        if isSuccess {
            completion(.success(NotesModel.makeMockModels()))
        } else {
            completion(.failure("Ошибка"))
        }
    }
}
