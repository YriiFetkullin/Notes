//
//  NoteAssembler.swift
//  Notes
//
//  Created by NarkoDiller on 09.06.2022.
//

import Foundation
import UIKit

class NoteAssembler {
    static func assembly(
        noteIndex: Int?,
        note: NotesModel,
        delegate: NoteViewControllerDelegate
    ) -> UIViewController {
        let viewController = NoteViewController()
        let interactor = NoteInteractor(noteIndex: noteIndex, note: note)
        let presenter = NotePresenter()
        let router = NoteRouter()
        viewController.interactor = interactor
        viewController.router = router
        viewController.delegate = delegate
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

        return viewController
    }
}
