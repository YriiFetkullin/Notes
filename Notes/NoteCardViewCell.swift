//
//  NoteCardViewCell.swift
//  Notes
//
//  Created by NarkoDiller on 13.04.2022.
//

import Foundation
import UIKit

class NoteCardViewCell: UITableViewCell {
    private let cardView = UIView().prepateForAutoLayout()
    private let titleview = UILabel().prepateForAutoLayout()
    private let subtitleView = UILabel().prepateForAutoLayout()
    private var dateView = UILabel().prepateForAutoLayout()
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    var callback: ((NotesModel) -> Void)?

    var model: NotesModel? {
        didSet {
            guard let model = model else { return }
            titleview.text = model.title
            subtitleView.text = model.text
            dateView.text = formatter.string(from: model.date)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
        setupStyles()
        addRecognizer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        addSubview(cardView)
        cardView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cardView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        cardView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 14

        let stackView = UIStackView().prepateForAutoLayout()
        cardView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 4

        stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10).isActive = true
        stackView.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 16).isActive = true
        stackView.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -16).isActive = true

        stackView.addArrangedSubview(titleview)
        stackView.addArrangedSubview(subtitleView)

        cardView.addSubview(dateView)
        dateView.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 16).isActive = true
        dateView.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -16).isActive = true
        dateView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: dateView.topAnchor, constant: -24).isActive = true
    }

    private func setupStyles() {
        titleview.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleView.font = .systemFont(ofSize: 10, weight: .medium)
        subtitleView.textColor = .systemGray3
        dateView.font = .systemFont(ofSize: 10, weight: .medium)
        backgroundColor = .clear
        selectionStyle = .none
    }

    private func addRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        cardView.addGestureRecognizer(tapGesture)
    }

    @objc
    private func cardTapped() {
        guard let model = model else {
            return
        }
        callback?(model)
    }
}
