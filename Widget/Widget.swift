//
//  Widget.swift
//  Widget
//
//  Created by Kiara on 09.03.23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), subjects: createData(), value: 12.0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), subjects: createData(), value: 11.0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date(), subjects: Util.getAllSubjects(), value: Util.generalAverage())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let subjects: [UserSubject]
    let value: Double
}

struct WidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall: AverageView(value: entry.value)
        case .systemMedium: OverviewView(subjects: entry.subjects)
        default: AverageView(value: entry.value)
        }
    }
}


struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: SimpleEntry(date: Date(), subjects: createData(), value: 12.0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

//MARK: Small circlechart Widget
struct SmallCircleWidget: Widget {
    let kind: String = "SmallCircleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AverageView(value: entry.value)
        }
        .configurationDisplayName("Durchschnitt Widget")
        .description("Gesamtdurchschnitt aller Fächer (ohne Prüfungen)")
        .supportedFamilies([.systemSmall])
        
        
    }
}


//MARK: Medium BarChart Widget
struct MediumBarWidget: Widget {
    let kind: String = "MediumBarWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            OverviewView(subjects: entry.subjects)
        }
        .configurationDisplayName("BarChart Widget")
        .description("Aktueller Durchschnitt aller Fächer")
        .supportedFamilies([.systemMedium])
    }
}
