//
//  ListNotesPresenter.swift
//  Notes
//
//  Created by NarkoDiller on 05.06.2022.
//

import Foundation

class ListNotesPresenter: ListNotesPresentationLogic {
    weak var viewController: ListNotesDisplayLogic?

    func presentNotes(_ response: ListNotesModels.Init.Response) {
        viewController?.displayNotes(ListNotesModels.Init.ViewModel())
    }

    func presentAppendedNote(_ response: ListNotesModels.Append.Response) {
        let viewModel = ListNotesModels.Append.ViewModel(index: response.index)
        viewController?.displayAppendedNote(viewModel)
    }

    func presentUpdatedNote(_ response: ListNotesModels.Update.Response) {
        let viewModel = ListNotesModels.Update.ViewModel(index: response.index)
        viewController?.displayUpdatedNote(viewModel)
    }

    func presentDeleteNotes(_ response: ListNotesModels.Delete.Response) {
        let viewModel = ListNotesModels.Delete.ViewModel(indicies: response.indicies)
        viewController?.displayDeleteNotes(viewModel)
    }
}
