//
//  NoteRouter.swift
//  Notes
//
//  Created by NarkoDiller on 09.06.2022.
//

import Foundation
import UIKit

class NoteRouter: NoteRoutingLogic, NoteDataPassing {
    var dataStore: NoteDataStore?
    weak var viewController: UIViewController?

    func showAlert() {
        let alert = UIAlertController(
            title: "Внимание",
            message: "Ваша заметка пуста,хотите продолжить?",
            preferredStyle: .actionSheet
        )
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)

        viewController?.present(alert, animated: true, completion: nil)
    }
}
