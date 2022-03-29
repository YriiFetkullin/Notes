//
//  NoteViewController.swift
//  Notes
//
//  Created by NarkoDiller on 25.03.2022.
//

import UIKit

class NoteViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleNotes: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = ""
        if textView.canBecomeFirstResponder {
            textView.becomeFirstResponder()
        }
        titleNotes.placeholder = "Введите заголовок"
        titleNotes.text = ""
    }

    @IBAction func itemButton(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
}
