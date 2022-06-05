//
//  ListNotesAssembler.swift
//  Notes
//
//  Created by NarkoDiller on 05.06.2022.
//

import UIKit

class ListNotesAssembler {
    static func assembly() -> UIViewController {
        let viewController = ListNotesViewController()
        let interactor = ListNotesInteractor(
            networkWorker: ListNotesNetworkWorker()
        )
        let presenter = ListNotesPresenter()
        let router = ListNotesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.dataStore = interactor

        return viewController
    }
}
