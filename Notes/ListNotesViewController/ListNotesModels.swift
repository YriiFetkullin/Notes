//
//  ListNotesModels.swift
//  Notes
//
//  Created by NarkoDiller on 05.06.2022.
//

import Foundation

enum ListNotesModels {
    enum Init {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }

    enum Append {
        struct Request {
            let noteModel: NotesModel
        }
        struct Response {
            let index: Int
        }
        struct ViewModel {
            let index: Int
        }
    }

    enum Update {
        struct Request {
            let index: Int
            let noteModel: NotesModel
        }
        struct Response {
            let index: Int
        }
        struct ViewModel {
            let index: Int
        }
    }

    enum Delete {
        struct Request {
            let indicies: [IndexPath]
        }
        struct Response {
            let indicies: [IndexPath]
        }
        struct ViewModel {
            let indicies: [IndexPath]
        }
    }
}
