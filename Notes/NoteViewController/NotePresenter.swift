//
//  NotePresenter.swift
//  Notes
//
//  Created by NarkoDiller on 09.06.2022.
//

import Foundation

class NotePresenter: NotePresentationLogic {
    weak var viewController: NoteDisplayLogic?

    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy EEEE HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    func presentData(_ response: NoteModels.Init.Response) {
        let viewModel = NoteModels.Init.ViewModel(
            header: response.noteModel.header,
            text: response.noteModel.text,
            date: formatter.string(from: response.noteModel.date ?? Date())
        )
        viewController?.displayData(viewModel)
    }

    func presentUpdatedData(_ response: NoteModels.Update.Response) {
        let viewModel = NoteModels.Update.ViewModel(
            header: response.noteModel.header,
            text: response.noteModel.text,
            date: formatter.string(from: response.noteModel.date ?? Date())
        )
        viewController?.displayUpdatedData(viewModel)
    }

    func presentError() {
        viewController?.displayError()
    }
}
