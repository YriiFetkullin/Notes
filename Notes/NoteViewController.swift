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

    private let titleField: UITextField = {
        let notes = UITextField()
        notes.translatesAutoresizingMaskIntoConstraints = false
        return notes
    }()

    private let dateField: UITextField = {
        let noteDate = UITextField()
        noteDate.translatesAutoresizingMaskIntoConstraints = false
        return noteDate
    }()
    private var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.draw(CGRect(x: 0, y: 0, width: 30, height: 40))
        return datePicker
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

        titleField.placeholder = "Введите заголовок"
        titleField.text = defaults.string(forKey: "title")
        view.addSubview(titleField)
        titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        titleField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        view.addSubview(dateField)

        dateField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 16).isActive = true
        dateField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        dateField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        dateField.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -16).isActive = true
        dateField.placeholder = "Текущая дата"
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        dateField.inputView = datePicker
        datePicker.datePickerMode = .date
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)

        navigationItem.rightBarButtonItem = barButton
        barButton.target = nil
        barButton.action = #selector(barButtonTapped(_:))
    }
    func getDateFromPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        dateField.text = formatter.string(from: datePicker.date)
    }
    @objc func dateChanged() {
        getDateFromPicker()
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
        let notes = textView.text!
        let title = titleField.text!
        let date = dateField.text!

        if !notes.isEmpty && !title.isEmpty && !date.isEmpty {
            defaults.set(notes, forKey: "notes")
            defaults.set(title, forKey: "title")
            defaults.set(date, forKey: "date")
            textView.resignFirstResponder()
            titleField.resignFirstResponder()
            dateField.resignFirstResponder()
        }
    }
    func configureElements(model: NotesModel) {
        titleField.text = model.title
        textView.text = model.notes
        dateField.text = model.date
    }
}
