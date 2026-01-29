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

class NoteViewController: UIViewController, NoteDisplayLogic {
    var router: (NoteRoutingLogic & NoteDataPassing)?
    var interactor: NoteBusinessLogic?

    private let textView = UITextView().prepateForAutoLayout()
    private let titleField = UITextField().prepateForAutoLayout()
    private let dateLabel = UILabel().prepateForAutoLayout()
    private let barButton = UIBarButtonItem(
        title: "Готово",
        style: .done,
        target: nil,
        action: #selector(barButtonTapped)
    )

    //  чтобы не было цикла сильных ссылок
    weak var delegate: NoteViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
        print("init NoteViewController")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("deinit NoteViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupUI()
        setupStyles()

        textView.delegate = self
        titleField.delegate = self

        if textView.canBecomeFirstResponder {
            textView.becomeFirstResponder()
        }
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let model = router?.dataStore?.note else { return }
        if let index = router?.dataStore?.noteIndex {
            delegate?.updateNote(index: index, noteModel: model)
        } else {
            delegate?.appendNote(noteModel: model)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotification()
    }

    private func setupUI() {
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

    private func fetchData() {
        let request = NoteModels.Init.Request()
        interactor?.fetchData(request)
    }

    private func registerForKeyboardNotifications() {
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

    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard let infoKey = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrameSize = infoKey.cgRectValue
        textView.contentInset.bottom = keyboardFrameSize.height
    }

    @objc private func keyboardWillHide() {
        textView.contentInset.bottom = CGFloat.zero
    }

    @objc private func barButtonTapped(_ sender: UIBarButtonItem) {
        let request = NoteModels.Update.Request(header: titleField.text, text: textView.text)
        interactor?.updateData(request)
    }

    func displayData(_ viewModel: NoteModels.Init.ViewModel) {
        titleField.text = viewModel.header
        textView.text = viewModel.text
        dateLabel.text = viewModel.date
    }

    func displayUpdatedData(_ viewModel: NoteModels.Update.ViewModel) {
        titleField.text = viewModel.header
        textView.text = viewModel.text
        dateLabel.text = viewModel.date
        view.endEditing(true)
    }

    func displayError() {
        router?.showAlert()
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
