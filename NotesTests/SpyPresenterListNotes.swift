//
//  SpyPresenterListNotes.swift
//  NotesTests
//
//  Created by NarkoDiller on 18.06.2022.
//

import Foundation
@testable import Notes

class SpyPresenterListNotes: ListNotesPresentationLogic {
    var presentNotesWasCalled = false
    var presentAppendedNoteWasCalled = false
    


    func presentNotes(_ response: ListNotesModels.Init.Response) {
        <#code#>
    }

    func presentAppendedNote(_ response: ListNotesModels.Append.Response) {
        <#code#>
    }

    func presentUpdatedNote(_ response: ListNotesModels.Update.Response) {
        <#code#>
    }

    func presentDeleteNotes(_ response: ListNotesModels.Delete.Response) {
        <#code#>
    }


}
