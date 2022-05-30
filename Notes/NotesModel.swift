//
//  NotesModel.swift
//  Notes
//
//  Created by NarkoDiller on 06.04.2022.
//

import Foundation
import UIKit

struct NotesModel: Codable {
    var header: String?
    var text: String?
    var date: Date?
    var userShareIcon: String?
    var isEmpty: Bool {
        guard
            let title = header,
            let notes = text
        else {
            return false
        }
        return notes.isEmpty && title.isEmpty
    }

    static func makeMockModels() -> [NotesModel] {
        return [
            NotesModel(
                header: "Вопросы для интервью",
                text: "Как давно ты стал программистом?(спросить как вообще заинтересовался программирование?)",
                date: Date()
            ),
            NotesModel(
                header: "Диплом",
                text: "Тема диплома: проэкт помещения для шиномонтажа с расстановкой оборудования",
                date: Date()
            ),
            NotesModel(
                header: "Покупки",
                text: "1.Хлеб, 2.Овощи, 3.Фрукты, 4.Сыр, 5.Молоко, 6.Имбирь",
                date: Date()
            ),
            NotesModel(
                header: "Затраты в месяц",
                text: "Аренда - 14к, мобильная связь,интернет,ТВ - 800р",
                date: Date()
            ),
            NotesModel(
                header: "Заметка",
                text: "17,18 апреля",
                date: Date()
            ),
            NotesModel(
                header: "Позвонить",
                text: "Стоматология allDent",
                date: Date()
            ),
            NotesModel(
                header: "Гибдд",
                text: "проверить регистрацию",
                date: Date()
            ),
            NotesModel(
                header: "Счетчики",
                text: "Отправить показания",
                date: Date()
            )
        ]
    }
}
