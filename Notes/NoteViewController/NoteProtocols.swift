//
//  NoteProtocols.swift
//  Notes
//
//  Created by NarkoDiller on 09.06.2022.
//

import Foundation

protocol NoteDataPassing {
    var dataStore: NoteDataStore? { get }
}

protocol NoteDataStore {
    var noteIndex: Int? { get }
    var note: NotesModel { get }
}

protocol NoteBusinessLogic {
    func fetchData(_ request: NoteModels.Init.Request)
    func updateData(_ request: NoteModels.Update.Request)
}

protocol NotePresentationLogic {
    func presentData(_ response: NoteModels.Init.Response)
    func presentUpdatedData(_ response: NoteModels.Update.Response)
    func presentError()
}

protocol NoteDisplayLogic: AnyObject {
    func displayData(_ viewModel: NoteModels.Init.ViewModel)
    func displayUpdatedData(_ viewModel: NoteModels.Update.ViewModel)
    func displayError()
}

protocol NoteRoutingLogic {
    func showAlert()
}
