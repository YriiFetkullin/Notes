//
//  NoteModel.swift
//  Notes
//
//  Created by NarkoDiller on 09.06.2022.
//

import Foundation

enum NoteModels {
    enum Init {
        struct Request {}
        struct Response {
            let noteModel: NotesModel
        }
        struct ViewModel {
            var header: String?
            var text: String?
            var date: String?
        }
    }

    enum Update {
        struct Request {
            var header: String?
            var text: String?
        }
        struct Response {
            let noteModel: NotesModel
        }
        struct ViewModel {
            var header: String?
            var text: String?
            var date: String?
        }
    }
}
