//
//  NewWordItem.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 8/14/23.
//

import Foundation

struct NewWordItem: Identifiable, Equatable {

    var id: Int
    var position_now: Int
    var pos: String = ""
    var word: String = ""
    var phonetics: String = ""
    var definition: String = ""
    var collocations: String = ""
    var sentence: String = ""
    var video: String = ""
    var movie: String = ""
    var movie_quote: String = ""
    var dateAdded: Date
    var timesReviewed: Int = 1
    var grade: Int = 1
    var ukranian: String = ""
    var russian: String = ""
    var bulgarian: String = ""
    var chinese: String = ""
    var czech: String = ""
    var danish: String = ""
    var dutch: String = ""
    var estonian: String = ""
    var finnish: String = ""
    var french: String = ""
    var german: String = ""
    var greek: String = ""
    var hungarian: String = ""
    var indonesian: String = ""
    var italian: String = ""
    var japanese: String = ""
    var korean: String = ""
    var latvian: String = ""
    var lithuanian: String = ""
    var norwegian: String = ""
    var polish: String = ""
    var portuguese: String = ""
    var romanian: String = ""
    var slovak: String = ""
    var slovenian: String = ""
    var spanish: String = ""
    var swedish: String = ""
    var turkish: String = ""
    
    init(
        id: Int,
        position_now: Int,
        pos: String,
        word: String,
        phonetics: String,
        definition: String,
        collocations: String,
        sentence: String,
        video: String,
        movie: String,
        movie_quote: String,
        dateAdded: Date,
        timesReviewed: Int = 1,
        grade: Int = 1,
        ukranian: String,
        russian: String,
        bulgarian: String,
        chinese: String,
        czech: String,
        danish: String,
        dutch: String,
        estonian: String,
        finnish: String,
        french: String,
        german: String,
        greek: String,
        hungarian: String,
        indonesian: String,
        italian: String,
        japanese: String,
        korean: String,
        latvian: String,
        lithuanian: String,
        norwegian: String,
        polish: String,
        portuguese: String,
        romanian: String,
        slovak: String,
        slovenian: String,
        spanish: String,
        swedish: String,
        turkish: String
    )
    
    {
        self.id = id
        self.position_now = position_now
        self.pos = pos
        self.word = word
        self.phonetics = phonetics
        self.definition = definition
        self.collocations = collocations
        self.sentence = sentence
        self.video = video
        self.movie = movie
        self.movie_quote = movie_quote
        self.dateAdded = dateAdded
        self.timesReviewed = timesReviewed
        self.grade = grade
        self.ukranian = ukranian
        self.russian = russian
        self.bulgarian = bulgarian
        self.chinese = chinese
        self.czech = czech
        self.danish = danish
        self.dutch = dutch
        self.estonian = estonian
        self.finnish = finnish
        self.french = french
        self.german = german
        self.greek = greek
        self.hungarian = hungarian
        self.indonesian = indonesian
        self.italian = italian
        self.japanese = japanese
        self.korean = korean
        self.latvian = latvian
        self.lithuanian = lithuanian
        self.norwegian = norwegian
        self.polish = polish
        self.portuguese = portuguese
        self.romanian = romanian
        self.slovak = slovak
        self.slovenian = slovenian
        self.spanish = spanish
        self.swedish = swedish
        self.turkish = turkish
    }
    
}

