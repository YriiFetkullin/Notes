//
//  ListNotesRouter.swift
//  Notes
//
//  Created by NarkoDiller on 05.06.2022.
//

import UIKit

class ListNotesRouter: ListNotesRoutingLogic, ListNotesDataPassing {
    var dataStore: ListNotesDataStore?
    weak var viewController: UIViewController?

    func routeToNote(index: Int?, note: NotesModel, delegate: NoteViewControllerDelegate) {
        let noteViewController = NoteAssembler.assembly(noteIndex: index, note: note, delegate: delegate)
        viewController?.navigationController?.pushViewController(noteViewController, animated: true)
    }
}
