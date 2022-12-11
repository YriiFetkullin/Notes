//
//  ListNotesViewController.swift
//  Notes
//
//  Created by NarkoDiller on 13.04.2022.
//

import Foundation
import UIKit

class ListNotesViewController: UIViewController {
    private let tableView = UITableView().prepateForAutoLayout()
    private let addNoteButton = UIButton(type: .custom).prepateForAutoLayout()
    private var notes: [NotesModel]

    private let noteCellIdentifier = "NoteCellIdentifier"

    init(notes: [NotesModel]) {
        self.notes = notes
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

        setupButton()
        setupUI()
    }

    private func setupUI() {
        navigationItem.title = "Заметки"

        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        view.addSubview(addNoteButton)
        addNoteButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addNoteButton.heightAnchor.constraint(equalTo: addNoteButton.widthAnchor).isActive = true
        addNoteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        addNoteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }

    private func setupButton() {
        let imageButton = UIImage(named: "button")
        addNoteButton.setImage(imageButton, for: .normal)
        addNoteButton.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
    }

    @objc
    private func cardTapped() {
        let noteViewController = NoteViewController()
        noteViewController.delegate = self
        let model = NotesModel(title: "", text: "", date: Date())
        noteViewController.configureElements(model: model)
        navigationController?.pushViewController(noteViewController, animated: true)
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
        let noteViewController = NoteViewController()
        noteViewController.delegate = self
        noteViewController.noteIndex = indexPath.row
        let model = notes[indexPath.row]
        noteViewController.configureElements(model: model)
        navigationController?.pushViewController(noteViewController, animated: true)
    }
}
