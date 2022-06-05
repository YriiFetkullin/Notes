//
//  ListNotesViewController.swift
//  Notes
//
//  Created by NarkoDiller on 13.04.2022.
//

import Foundation
import UIKit

class ListNotesViewController: UIViewController, ListNotesDisplayLogic {
    var interactor: ListNotesBusinessLogic?
    var router: (ListNotesRoutingLogic & ListNotesDataPassing)?

    private let activityIndicator = UIActivityIndicatorView().prepateForAutoLayout()
    private let tableView = UITableView().prepateForAutoLayout()
    private let addNoteButton = UIButton(type: .custom).prepateForAutoLayout()
    private let chooseNote = UIBarButtonItem(
        title: "Выбрать",
        style: .done,
        target: nil,
        action: #selector(chooseNoteButtonTapped)
    )
    private var addNoteBottomConstraint: NSLayoutConstraint?

    private let noteCellIdentifier = "NoteCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoteCardViewCell.self, forCellReuseIdentifier: noteCellIdentifier)

        chooseNote.target = self
        addNoteButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        setupButton(isEditing)
        setupUI()
        fetchNotes()
    }

    func displayNotes(_ viewModel: ListNotesModels.Init.ViewModel) {
        tableView.reloadData()
        activityIndicator.stopAnimating()
    }

    func displayAppendedNote(_ viewModel: ListNotesModels.Append.ViewModel) {
        let indexPath = IndexPath(row: viewModel.index, section: 0)
        tableView.performBatchUpdates {
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }

    func displayUpdatedNote(_ viewModel: ListNotesModels.Update.ViewModel) {
        let indexPath = IndexPath(row: viewModel.index, section: 0)
        tableView.performBatchUpdates {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    func displayDeleteNotes(_ viewModel: ListNotesModels.Delete.ViewModel) {
        tableView.performBatchUpdates {
            tableView.deleteRows(at: viewModel.indicies, with: .automatic)
        } completion: { [weak self] _ in
            //  чтобы не было цикла сильных ссылок
            self?.setEditing(false, animated: true)
        }
    }

    private func fetchNotes() {
        activityIndicator.startAnimating()
        interactor?.requestNotes(ListNotesModels.Init.Request())
    }

    private func setupUI() {
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        navigationItem.title = "Заметки"
        navigationItem.rightBarButtonItem = chooseNote

        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.showsVerticalScrollIndicator = false

        view.addSubview(addNoteButton)
        addNoteButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addNoteButton.heightAnchor.constraint(equalTo: addNoteButton.widthAnchor).isActive = true
        addNoteBottomConstraint = addNoteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60)
        addNoteBottomConstraint?.isActive = true
        addNoteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }

    private func setupButton(_ isEditing: Bool) {
        if isEditing {
            let imageButton = UIImage(named: "deleteButton")
            addNoteButton.setImage(imageButton, for: .normal)
        } else {
            let imageButton = UIImage(named: "addButton")
            addNoteButton.setImage(imageButton, for: .normal)
        }
    }

    @objc private func actionButtonTapped() {
        if isEditing {
            deleteButtonAction()
        } else {
            addButtonAction()
        }
    }

    @objc private func chooseNoteButtonTapped() {
        setEditing(!isEditing, animated: true)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.setEditing(editing, animated: true)
        setupButton(editing)
        if editing {
            chooseNote.title = "Готово"
        } else {
            chooseNote.title = "Выбрать"
        }
        super.setEditing(editing, animated: animated)
    }

    private func addButtonAction() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseIn]
        ) {
            // блоки анимации выполняются всегда
            self.addNoteBottomConstraint?.constant = -75
            self.view.layoutIfNeeded()
        } completion: { _ in
            // блоки анимации выполняются всегда
            UIView.animate(
                withDuration: 0.4,
                delay: 0.1,
                options: [.curveEaseOut]
            ) {
                // блоки анимации выполняются всегда
                self.addNoteBottomConstraint?.constant = 60
                self.view.layoutIfNeeded()
            } completion: { _ in
                // блоки анимации выполняются всегда
                let noteViewController = NoteViewController()
                noteViewController.delegate = self
                let model = NotesModel(header: "", text: "", date: Date())
                noteViewController.configureElements(model: model)
                self.navigationController?.pushViewController(noteViewController, animated: true)
            }
        }
    }

    private func deleteButtonAction() {
        guard let selectedRows = tableView.indexPathsForSelectedRows else {
            chooseAlert()
            return
        }
        let request = ListNotesModels.Delete.Request(indicies: selectedRows)
        interactor?.deleteNotes(request)
    }

    private func chooseAlert() {
        let alert = UIAlertController(
            title: "Внимание",
            message: "Вы не выбрали ни одной заметки",
            preferredStyle: .alert
        )
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)

        present(alert, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addNoteBottomConstraint?.constant = -60
        UIView.animate(
            withDuration: 1,
            delay: 1,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.1,
            options: [.curveEaseOut]
        ) {
            // блоки анимации выполняются всегда
            self.view?.layoutIfNeeded()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        addNoteBottomConstraint?.constant = 60
        UIView.animate(withDuration: 1) {
            // блоки анимации выполняются всегда
            self.view?.layoutIfNeeded()
        }
    }
}

extension ListNotesViewController: NoteViewControllerDelegate {
    func appendNote(noteModel: NotesModel) {
        let request = ListNotesModels.Append.Request(noteModel: noteModel)
        interactor?.appendNote(request)
        tableView.reloadData()
    }

    func updateNote(index: Int, noteModel: NotesModel) {
        let request = ListNotesModels.Update.Request(index: index, noteModel: noteModel)
        interactor?.updateNote(request)
        tableView.reloadData()
    }
}

extension ListNotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let notes = router?.dataStore?.notes else { return 0 }
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: noteCellIdentifier,
                for: indexPath
              ) as? NoteCardViewCell
        else { return UITableViewCell() }

        cell.model = router?.dataStore?.notes?[indexPath.row]
        return cell
    }
}

extension ListNotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let model = router?.dataStore?.notes?[indexPath.row],
            !isEditing
        else {
            return
        }

        let noteViewController = NoteViewController()
        noteViewController.delegate = self
        noteViewController.noteIndex = indexPath.row
        noteViewController.configureElements(model: model)
        navigationController?.pushViewController(noteViewController, animated: true)
    }
}
