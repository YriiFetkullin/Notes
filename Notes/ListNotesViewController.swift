//
//  ListNotesViewController.swift
//  Notes
//
//  Created by NarkoDiller on 13.04.2022.
//

import Foundation
import UIKit

class ListNotesViewController: UIViewController {
    private let scrollView = UIScrollView().prepateForAutoLayout()
    private let stackView = UIStackView().prepateForAutoLayout()

    private var notes: [NotesModel]

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

        setupUI()
        setupNotes()
    }
    private func setupUI() {
        navigationItem.title = "Заметки"

        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        scrollView.alwaysBounceVertical = true

        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    private func setupNotes() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        notes.forEach { note in
            let card = NoteCardView()
            card.model = note
            card.callback = { [weak self] model in
                let noteViewController = NoteViewController()
                noteViewController.delegate = self
                noteViewController.configureElements(model: model)
                self?.navigationController?.pushViewController(noteViewController, animated: true)
            }
            stackView.addArrangedSubview(card)
        }
    }
}

extension ListNotesViewController: NoteViewControllerDelegate {
    func updateNote(noteModel: NotesModel) {
        guard let index = notes.firstIndex(where: { $0.id == noteModel.id }) else { return }
        notes[index] = noteModel
        setupNotes()
    }
}
