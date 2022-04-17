//
//  NotesModel.swift
//  Notes
//
//  Created by NarkoDiller on 06.04.2022.
//

import Foundation
import UIKit

struct NotesModel: Codable {
    var id: Int
    var title: String?
    var text: String?
    var date: Date
    var isEmpty: Bool {
        guard
            let title = title,
            let notes = text
        else {
            return false
        }
        return notes.isEmpty && title.isEmpty
    }

    static func makeMockModels() -> [NotesModel] {
        return [
            NotesModel(
                id: 1,
                title: "Вопросы для интервью",
                text: "Как давно ты стал программистом?(спросить как вообще заинтересовался программирование?)",
                date: Date()
            ),
            NotesModel(
                id: 2,
                title: "Диплом",
                text: "Тема диплома: проэкт помещения для шиномонтажа с расстановкой оборудования",
                date: Date()
            ),
            NotesModel(
                id: 3,
                title: "Покупки",
                text: "1.Хлеб, 2.Овощи, 3.Фрукты, 4.Сыр, 5.Молоко, 6.Имбирь",
                date: Date()
            ),
            NotesModel(
                id: 4,
                title: "Затраты в месяц",
                text: "Аренда - 14к, мобильная связь,интернет,ТВ - 800р",
                date: Date()
            ),
            NotesModel(
                id: 5,
                title: "Заметка",
                text: "17,18 апреля",
                date: Date()
            ),
            NotesModel(
                id: 6,
                title: "Позвонить",
                text: "Стоматология allDent",
                date: Date()
            ),
            NotesModel(
                id: 7,
                title: "Гибдд",
                text: "проверить регистрацию",
                date: Date()
            ),
            NotesModel(
                id: 8,
                title: "Счетчики",
                text: "Отправить показания",
                date: Date()
            )
        ]
    }
}
