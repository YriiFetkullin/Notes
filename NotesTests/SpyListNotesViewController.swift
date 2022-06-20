//
//  SpyListNotesViewController.swift
//  NotesTests
//
//  Created by NarkoDiller on 18.06.2022.
//

import Foundation
@testable import Notes

class SpyListNotesViewCotroller: ListNotesDisplayLogic {
    var displayNotesWasCalled = false
    var displayAppendedNoteWasCalled = false
    var displayUpdatedNoteWasCalled = false
    var displayDeleteNotesWasCalled = false

    func displayNotes(_ viewModel: ListNotesModels.Init.ViewModel) {
        displayNotesWasCalled = true
    }

    func displayAppendedNote(_ viewModel: ListNotesModels.Append.ViewModel) {
        displayAppendedNoteWasCalled = true
    }

    func displayUpdatedNote(_ viewModel: ListNotesModels.Update.ViewModel) {
        displayUpdatedNoteWasCalled = true
    }

    func displayDeleteNotes(_ viewModel: ListNotesModels.Delete.ViewModel) {
        displayDeleteNotesWasCalled = true
    }
}
