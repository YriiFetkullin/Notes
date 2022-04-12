//
//  NotesModel.swift
//  Notes
//
//  Created by NarkoDiller on 06.04.2022.
//

import Foundation
import UIKit

struct NotesModel: Codable {
    var title: String?
    var notes: String?
    var date: String?
    var isEmpty: Bool {
        guard let title = title,
              let notes = notes,
              let date = date else {
            return false
        }
        return notes.isEmpty && title.isEmpty && date.isEmpty
    }
}
