//
//  Note.swift
//  Renote
//
//  Created by Raheel Sayeed on 18/02/21.
//  Copyright © 2021 Medical Gear. All rights reserved.
//

import Foundation
import SwiftUI


struct Note {
	
	static let IndexURL = URL(string: "https://raw.githubusercontent.com/raheelsayeed/vimatics/master/_usmle/appnotes.txt")!
	static let noteDefaults = UserDefaults(suiteName: "group.com.smartddx.renote.usmle")
	static let viewCountKey = "view_count"
	static let currentNoteKey = "current_note"
	static var noteDict = Self.noteDefaults?.dictionary(forKey: Note.viewCountKey) as? [String: Int] ?? [String: Int]()

	let filename: String
	let date: Date?
	let text: String?
	let tags: [String]?
	
	var websiteURL: URL {
		URL(string: "https://vimatics.com/usmle/" + filename.dropLast(3))!
	}
	
	lazy var viewCount: Int = {
		print(Self.noteDict)
		return Self.noteDict[filename] ?? 0
	}()
	
	
	mutating func addCount() {
		Self.noteDict[filename] = viewCount+1
		Note.noteDefaults?.setValue(Self.noteDict, forKey: Note.viewCountKey)
		print(Self.noteDict)
	}
	
	func setCurrent() {
		Note.noteDefaults?.setValue(filename, forKey: Note.currentNoteKey)
	}
	
	static func FromDefaults() -> Note? {
		if let filename = Note.noteDefaults?.string(forKey: Note.currentNoteKey) {
			return Note(filename: filename, date: Date(), text: nil, tags: nil, viewCount: nil)
		}
		return nil
	}
}


struct NoteLoader {
	
	static func fetch(completion: @escaping (Result<Note, Error>) -> Void) {
		
		let session = URLSession.shared
		session.dataTask(with: Note.IndexURL) { (data, _ , error ) in
			guard let data = data else {
				completion(.failure(error!))
				return
			}
			
			let filenames = String(data: data, encoding: .utf8)!.components(separatedBy: "\n")
			let fn = filenames.randomElement()!
			let rawTextURL = URL(string: "https://raw.githubusercontent.com/raheelsayeed/vimatics/master/_usmle/" + fn)!

			
			session.dataTask(with: rawTextURL) { (noteData, _ , errorz) in
				guard let noteData = noteData else {
					completion(.failure(errorz!))
					return
				}
				
				let clean = cleanText(fromData: noteData)
				let note = Note(filename: fn, date: Date(), text: clean, tags: nil)
				note.setCurrent()
				completion(.success(note))
			}.resume()
		}.resume()

	}
	static func cleanText(fromData data: Foundation.Data) -> String {
		
		var text = String(data: data, encoding: .utf8)!
		let range = text.range(of: "\n---\n")!
		let nrange = text.startIndex..<range.upperBound
		text.removeSubrange(nrange)
		return text
	}
}
