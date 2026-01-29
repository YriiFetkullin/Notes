//
//  NoteInteractor.swift
//  Notes
//
//  Created by NarkoDiller on 09.06.2022.
//

import Foundation

class NoteInteractor: NoteBusinessLogic, NoteDataStore {
    var presenter: NotePresentationLogic?

    var noteIndex: Int?
    var note: NotesModel

    init(noteIndex: Int?, note: NotesModel) {
        self.noteIndex = noteIndex
        self.note = note
    }

    func fetchData(_ request: NoteModels.Init.Request) {
        let response = NoteModels.Init.Response(noteModel: note)
        presenter?.presentData(response)
    }

    func updateData(_ request: NoteModels.Update.Request) {
        let model = NotesModel(
            header: request.header,
            text: request.text,
            date: Date(),
            userShareIcon: note.userShareIcon
        )
        if !model.isEmpty {
            note = model
            let response = NoteModels.Update.Response(noteModel: note)
            presenter?.presentUpdatedData(response)
        } else {
            presenter?.presentError()
        }
    }
}
