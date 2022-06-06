//
//  ListNotesViewController.swift
//  Notes
//
//  Created by NarkoDiller on 13.04.2022.
//

import Foundation
import UIKit

class ListNotesViewController: UIViewController {
    private let networkWorker: NetworkWorkerProtocol
    private let tableView = UITableView().prepateForAutoLayout()
    private let addNoteButton = UIButton(type: .custom).prepateForAutoLayout()
    private var notes: [NotesModel] = []
    private let chooseNote = UIBarButtonItem(
        title: "Выбрать",
        style: .done,
        target: nil,
        action: #selector(chooseNoteButtonTapped)
    )
    private var addNoteBottomConstraint: NSLayoutConstraint?

    private let noteCellIdentifier = "NoteCellIdentifier"

    init(networkWorker: NetworkWorkerProtocol) {
        self.networkWorker = networkWorker
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    private func fetchNotes() {
        let activityIndicator = UIActivityIndicatorView().prepateForAutoLayout()
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        networkWorker.getNotes { [weak self] result in
            // чтобы не было цикла сильных ссылок
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.notes = model
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func setupUI() {
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
            deleteAction()
        } else {
            addAction()
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

    private func addAction() {
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

    private func deleteAction() {
        guard let selectedRows = tableView.indexPathsForSelectedRows else {
            chooseAlert()
            return
        }

        notes = notes.enumerated().compactMap({ index, note in
            guard !selectedRows.contains(where: { $0.row == index }) else { return nil }
                return note
        })

        tableView.performBatchUpdates {
            tableView.deleteRows(at: selectedRows, with: .automatic)
        } completion: { [weak self] _ in
            //  чтобы не было цикла сильных ссылок
            self?.setEditing(false, animated: true)
        }
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
        notes.insert(noteModel, at: 0)
        tableView.reloadData()
    }

    func updateNote(index: Int, noteModel: NotesModel) {
        notes[index] = noteModel
        tableView.reloadData()
    }
}

extension ListNotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: noteCellIdentifier,
            for: indexPath
        ) as? NoteCardViewCell else { return UITableViewCell() }

        cell.model = notes[indexPath.row]
        return cell
    }
}

extension ListNotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !isEditing else {
            return
        }

        let noteViewController = NoteViewController()
        noteViewController.delegate = self
        noteViewController.noteIndex = indexPath.row
        let model = notes[indexPath.row]
        noteViewController.configureElements(model: model)
        navigationController?.pushViewController(noteViewController, animated: true)
    }
}
