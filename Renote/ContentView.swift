//
//  ContentView.swift
//  Renote
//
//  Created by Raheel Sayeed on 16/02/21.
//  Copyright © 2021 Medical Gear. All rights reserved.
//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

@available(iOS 14.0, *)
struct ContentView: View {
    @State private var dates = [Date]()
	@AppStorage(Note.currentNoteKey, store: UserDefaults(suiteName: "group.com.smartddx.renote.usmle")) var currentNoteFilename: String = "Anatomy.md"
	@State var note = Note(filename: "ANATOMY.md", date: Date(), text: nil, tags: nil, viewCount: nil)


    var body: some View {
		var n = Note(filename: currentNoteFilename, date: Date(), text: nil, tags: nil, viewCount: nil)
        NavigationView {
			WebView(urlString: n.websiteURL.absoluteString)
                .navigationBarTitle(Text("Force USMLE"))
                .navigationBarItems(
					leading: Text("Viewed: \(n.viewCount)")
                )
		}
		.navigationViewStyle(DoubleColumnNavigationViewStyle())
		.onAppear(perform: {
			n.addCount()
		})
	}
	
	
	
}

struct MasterView: View {
    @Binding var dates: [Date]

    var body: some View {
        List {
            ForEach(dates, id: \.self) { date in
                NavigationLink(
                    destination: DetailView(selectedDate: date)
                ) {
                    Text("\(date, formatter: dateFormatter)")
                }
            }.onDelete { indices in
                indices.forEach { self.dates.remove(at: $0) }
            }
        }
    }
}

struct DetailView: View {
    var selectedDate: Date?

    var body: some View {
        Group {
            if selectedDate != nil {
                Text("\(selectedDate!, formatter: dateFormatter)")
            } else {
                Text("Detail view content goes here")
            }
        }.navigationBarTitle(Text("Detail"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
