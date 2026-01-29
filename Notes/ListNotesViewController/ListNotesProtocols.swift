//
//  ListNotesProtocols.swift
//  Notes
//
//  Created by NarkoDiller on 05.06.2022.
//

import Foundation

protocol ListNotesDataPassing {
    var dataStore: ListNotesDataStore? { get }
}

protocol ListNotesDataStore {
    var notes: [NotesModel]? { get }
}

protocol ListNotesBusinessLogic {
    func requestNotes(_ request: ListNotesModels.Init.Request)
    func appendNote(_ request: ListNotesModels.Append.Request)
    func updateNote(_ request: ListNotesModels.Update.Request)
    func deleteNotes(_ request: ListNotesModels.Delete.Request)
}

protocol ListNotesWorkerLogic {
    func getNotes(completion: @escaping (Result<[NotesModel], Error>) -> Void)
}

protocol ListNotesPresentationLogic {
    func presentNotes(_ response: ListNotesModels.Init.Response)
    func presentAppendedNote(_ response: ListNotesModels.Append.Response)
    func presentUpdatedNote(_ response: ListNotesModels.Update.Response)
    func presentDeleteNotes(_ response: ListNotesModels.Delete.Response)
}

protocol ListNotesDisplayLogic: AnyObject {
    func displayNotes(_ viewModel: ListNotesModels.Init.ViewModel)
    func displayAppendedNote(_ viewModel: ListNotesModels.Append.ViewModel)
    func displayUpdatedNote(_ viewModel: ListNotesModels.Update.ViewModel)
    func displayDeleteNotes(_ viewModel: ListNotesModels.Delete.ViewModel)
}

protocol ListNotesRoutingLogic {
    func routeToNote(index: Int?, note: NotesModel, delegate: NoteViewControllerDelegate)
}
