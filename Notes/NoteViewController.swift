//
//  NoteViewController.swift
//  Notes
//
//  Created by NarkoDiller on 25.03.2022.
//

import UIKit

class NoteViewController: UIViewController {
    let defaults = UserDefaults.standard

    private let textView = UITextView().prepateForAutoLayout()
    private let titleField = UITextField().prepateForAutoLayout()
    private let dateField = UILabel().prepateForAutoLayout()
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6

        let barButton = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: nil,
            action: #selector(barButtonTapped)
        )

        if textView.canBecomeFirstResponder {
            textView.becomeFirstResponder()
        }
        textView.alwaysBounceVertical = true
        view.addSubview(textView)
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true

        titleField.placeholder = "Введите название"
        titleField.borderStyle = .none

        view.addSubview(titleField)
        titleField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        titleField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        titleField.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -16).isActive = true

        view.addSubview(dateField)
        dateField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        dateField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        dateField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        dateField.bottomAnchor.constraint(equalTo: titleField.topAnchor, constant: -12).isActive = true
        dateField.textAlignment = .center

        navigationItem.rightBarButtonItem = barButton
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
        let keyboardFrameSize = infoKey.cgRectValue
        textView.contentInset.bottom = keyboardFrameSize.height
    }

    @objc func keyboardWillHide() {
        textView.contentInset.bottom = CGFloat.zero
    }

    @objc func barButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        let model = NotesModel(
            title: titleField.text,
            text: textView.text,
            date: dateField.text
        )
        if !model.isEmpty, let encoded = try? JSONEncoder().encode(model) {
            defaults.set(encoded, forKey: "notesModel")
            textView.resignFirstResponder()
            titleField.resignFirstResponder()
            dateField.resignFirstResponder()
        } else {
            showAlert()
        }
    }
    func configureElements(model: NotesModel) {
        titleField.text = model.title
        textView.text = model.text
        dateField.text = model.date
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "Внимание",
            message: "Ваша заметка пуста,хотите продолжить?",
            preferredStyle: .alert
        )
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)

        present(alert, animated: true, completion: nil)
    }
}
