//
//  ListNotesInteractor.swift
//  Notes
//
//  Created by NarkoDiller on 05.06.2022.
//

import Foundation

class ListNotesInteractor: ListNotesBusinessLogic, ListNotesDataStore {
    var presenter: ListNotesPresentationLogic?
    private let networkWorker: ListNotesWorkerLogic
    var notes: [NotesModel]?

    init(networkWorker: ListNotesWorkerLogic) {
        self.networkWorker = networkWorker
    }

    func requestNotes(_ request: ListNotesModels.Init.Request) {
        networkWorker.getNotes { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.notes = model
                self.presenter?.presentNotes(ListNotesModels.Init.Response())
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func appendNote(_ request: ListNotesModels.Append.Request) {
        let insertionIndex = 0
        notes?.insert(request.noteModel, at: insertionIndex)
        let response = ListNotesModels.Append.Response(index: insertionIndex)
        presenter?.presentAppendedNote(response)
    }

    func updateNote(_ request: ListNotesModels.Update.Request) {
        notes?[request.index] = request.noteModel
        let response = ListNotesModels.Update.Response(index: request.index)
        presenter?.presentUpdatedNote(response)
    }

    func deleteNotes(_ request: ListNotesModels.Delete.Request) {
        notes = notes?.enumerated().compactMap({ index, note in
            guard !request.indicies.contains(where: { $0.row == index }) else { return nil }
            return note
        })
        let response = ListNotesModels.Delete.Response(indicies: request.indicies)
        presenter?.presentDeleteNotes(response)
    }
}
