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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6

        setupUI()
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

        let model = NotesModel(
            title: "Заметка",
            text: "Какой-то очень длинный текст бла бла бла бла бла бла бла бла",
            date: Date().description
        )
        for _ in 1...6 {
            let card = NoteCardView()
            card.model = model
            card.callback = { [weak self] model in
                let noteViewController = NoteViewController()
                noteViewController.configureElements(model: model)
                self?.navigationController?.pushViewController(noteViewController, animated: true)
            }
            stackView.addArrangedSubview(card)
        }
    }
}
