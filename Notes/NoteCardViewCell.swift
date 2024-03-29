//
//  NoteCardViewCell.swift
//  Notes
//
//  Created by NarkoDiller on 13.04.2022.
//

import Foundation
import UIKit

class NoteCardViewCell: UITableViewCell {
    private let cardContentView = UIView().prepateForAutoLayout()
    private let titleview = UILabel().prepateForAutoLayout()
    private let subtitleView = UILabel().prepateForAutoLayout()
    private let dateView = UILabel().prepateForAutoLayout()
    private let shareIconView = UIImageView().prepateForAutoLayout()
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    private let imageLoader = ImageLoader()

    var callback: ((NotesModel) -> Void)?

    var model: NotesModel? {
        didSet {
            guard let model = model else { return }
            titleview.text = model.header
            subtitleView.text = model.text
            if let date = model.date {
                dateView.text = formatter.string(from: date)
            }
            loadImage(link: model.userShareIcon)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleview.text = nil
        subtitleView.text = nil
        dateView.text = nil
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyles()
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        contentView.addSubview(cardContentView)
        cardContentView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cardContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cardContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        cardContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        let stackView = UIStackView().prepateForAutoLayout()
        cardContentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 4

        stackView.topAnchor.constraint(equalTo: cardContentView.topAnchor, constant: 10).isActive = true
        stackView.leftAnchor.constraint(equalTo: cardContentView.leftAnchor, constant: 16).isActive = true
        stackView.rightAnchor.constraint(equalTo: cardContentView.rightAnchor, constant: -16).isActive = true

        stackView.addArrangedSubview(titleview)
        stackView.addArrangedSubview(subtitleView)

        cardContentView.addSubview(dateView)
        dateView.leftAnchor.constraint(equalTo: cardContentView.leftAnchor, constant: 16).isActive = true
        dateView.rightAnchor.constraint(equalTo: cardContentView.rightAnchor, constant: -16).isActive = true
        dateView.bottomAnchor.constraint(equalTo: cardContentView.bottomAnchor, constant: -10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: dateView.topAnchor, constant: -24).isActive = true

        cardContentView.addSubview(shareIconView)
        shareIconView.rightAnchor.constraint(equalTo: cardContentView.rightAnchor, constant: -10).isActive = true
        shareIconView.bottomAnchor.constraint(equalTo: cardContentView.bottomAnchor, constant: -10).isActive = true
        shareIconView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        shareIconView.heightAnchor.constraint(equalTo: shareIconView.widthAnchor).isActive = true
        shareIconView.contentMode = .scaleAspectFit
    }

    private func setupStyles() {
        titleview.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleView.font = .systemFont(ofSize: 10, weight: .medium)
        subtitleView.textColor = .systemGray3
        dateView.font = .systemFont(ofSize: 10, weight: .medium)
        backgroundColor = .systemBackground
        let selectedView = UIView()
        selectedView.backgroundColor = .clear
        selectedBackgroundView = selectedView
        layer.cornerRadius = 14
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray6.cgColor
        layer.masksToBounds = true
    }

    private func loadImage(link: String?) {
        imageLoader.loadImage(link: link) { [weak self] result in
            //  чтобы не было цикла сильных ссылок
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.shareIconView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
