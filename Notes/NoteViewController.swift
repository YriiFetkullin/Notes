//
//  NoteViewController.swift
//  Notes
//
//  Created by NarkoDiller on 25.03.2022.
//

import UIKit

class NoteViewController: UIViewController {
    let defaults = UserDefaults.standard

    private let barButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Готово"
        return barButton
    }()

    private let textView: UITextView = {
        let textNotes = UITextView()
        textNotes.translatesAutoresizingMaskIntoConstraints = false
        return textNotes
    }()

    private let titleView: UITextField = {
        let notes = UITextField()
        notes.translatesAutoresizingMaskIntoConstraints = false
        return notes
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        textView.text = defaults.string(forKey: "notes")
        if textView.canBecomeFirstResponder {
            textView.becomeFirstResponder()
        }
        textView.alwaysBounceVertical = true
        view.addSubview(textView)
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        titleView.placeholder = "Введите заголовок"
        titleView.text = defaults.string(forKey: "title")
        view.addSubview(titleView)
        titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        titleView.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -16).isActive = true

        navigationItem.rightBarButtonItem = barButton
        barButton.target = nil
        barButton.action = #selector(barButtonTapped(_:))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotification()
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard let infoKey = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let kbFrameSize = infoKey.cgRectValue
        textView.contentInset.bottom = kbFrameSize.height
    }

    @objc func keyboardWillHide() {
        textView.contentInset.bottom = CGFloat.zero
    }

    @objc func barButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        let notes = textView.text!
        let title = titleView.text!

        if !notes.isEmpty && !title.isEmpty {
            defaults.set(notes, forKey: "notes")
            defaults.set(title, forKey: "title")

            textView.resignFirstResponder()
        }
    }
}
