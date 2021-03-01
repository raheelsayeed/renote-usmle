//
//  RenoteWidget.swift
//  RenoteWidget
//
//  Created by Raheel Sayeed on 16/02/21.
//  Copyright © 2021 Medical Gear. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents


struct NoteEntry: TimelineEntry {
	
	let date: Date = Date()
	var note: Note

	
}

struct Provider: TimelineProvider {
	
	typealias Entry = NoteEntry
	
	func placeholder(in context: Context) -> NoteEntry {
		let placeHolderNote = Note(filename: "FN", date: Date(), text: "This is a snapshot Note", tags: ["usmle"])
		return NoteEntry(note: placeHolderNote)
	}
	
	
	func getSnapshot(in context: Context, completion: @escaping (NoteEntry) -> Void) {
		let placeHolderNote = Note(filename: "FN", date: Date(), text: "This is a snapshot Note", tags: ["usmle"])
		let entry = NoteEntry(note: placeHolderNote)
		completion(entry)
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<NoteEntry>) -> Void) {
		let currentDate = Date()
		let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
		
		NoteLoader.fetch { result in
				let note: Note
				if case .success(let fetchedNote) = result {
					note = fetchedNote
				} else {
					note = Note(filename: "FN", date: Date(), text: "Could not fetch a random USMLE note", tags: nil)
				}
			
			let entry = NoteEntry(note: note)
			let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
			completion(timeline)
		}
	}
	
	

	
	
	
}



struct RenoteWidgetEntryView : View {
    var entry: Provider.Entry
	var body: some View {
		VStack(alignment: .leading, spacing: 1) {
			Text("Daily USMLE")
				.font(.system(.title3))
				.foregroundColor(.black)
				.bold()
			Text(entry.note.text ?? "This is Preview Note")
				.font(.system(.body))
				.foregroundColor(.black)
			Text("Updated at \(Self.format(date:entry.date))")
				.font(.system(.caption2))
				.foregroundColor(.black)
		}.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
			.padding()
			.background(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom))
	}
	static func format(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .medium
		return dateFormatter.string(from: date)
	}
}

@main
struct RenoteWidget: Widget {
    let kind: String = "RenoteWidget"

    var body: some WidgetConfiguration {
		
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			RenoteWidgetEntryView(entry: entry)
		}
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
		.supportedFamilies([.systemLarge])
    }
}

struct RenoteWidget_Previews: PreviewProvider {
    static var previews: some View {
		let placeHolderNote = Note(filename: "FN", date: Date(), text: "This is a Preview Note", tags: nil)
		let entry = NoteEntry(note: placeHolderNote)

        RenoteWidgetEntryView(entry: entry)
			.previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
