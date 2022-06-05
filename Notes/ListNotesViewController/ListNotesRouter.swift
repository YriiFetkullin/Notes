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
}
