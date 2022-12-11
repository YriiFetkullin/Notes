//
//  NoteViewController.swift
//  Notes
//
//  Created by NarkoDiller on 25.03.2022.
//

import UIKit
protocol NoteViewControllerDelegate: AnyObject {
    func updateNote(index: Int, noteModel: NotesModel)
    func appendNote(noteModel: NotesModel)
}

class NoteViewController: UIViewController {
    private let textView = UITextView().prepateForAutoLayout()
    private let titleField = UITextField().prepateForAutoLayout()
    private let dateLabel = UILabel().prepateForAutoLayout()
    private let barButton = UIBarButtonItem(
        title: "Готово",
        style: .done,
        target: nil,
        action: #selector(barButtonTapped)
    )
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy EEEE HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    private var model: NotesModel?
    weak var delegate: NoteViewControllerDelegate?
    var noteIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupStyles()

        textView.delegate = self
        titleField.delegate = self

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

        view.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: titleField.topAnchor, constant: -12).isActive = true
        dateLabel.textAlignment = .center
    }

    private func setupStyles() {
        titleField.font = .systemFont(ofSize: 24, weight: .medium)
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.backgroundColor = .systemGray6
        dateLabel.font = .systemFont(ofSize: 14, weight: .medium)
        dateLabel.textColor = .systemGray3
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let model = model else { return }
        if let index = noteIndex {
            delegate?.updateNote(index: index, noteModel: model)
        } else {
            delegate?.appendNote(noteModel: model)
        }
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
            header: titleField.text,
            text: textView.text,
            date: Date()
        )
        if !model.isEmpty {
            self.model = model
            if let date = model.date {
                dateLabel.text = formatter.string(from: date)
            }
            textView.resignFirstResponder()
            titleField.resignFirstResponder()
        } else {
            showAlert()
        }
    }
    func configureElements(model: NotesModel) {
        self.model = model
        titleField.text = model.header
        textView.text = model.text
        if let date = model.date {
            dateLabel.text = formatter.string(from: date)
        }
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "Внимание",
            message: "Ваша заметка пуста,хотите продолжить?",
            preferredStyle: .actionSheet
        )
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)

        present(alert, animated: true, completion: nil)
    }
}

extension NoteViewController: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = barButton
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = nil
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem = barButton
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem = nil
    }
}
