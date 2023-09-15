//
//  CalqWidget.swift
//  CalqWidgetExtension
//
//  Created by Kiara on 09.03.23.
//

import SwiftUI
import WidgetKit

let previewSubejcts = JSON.createWidgetPreviewData()

private struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), barChartData: BarChartEntry.example, halfyearbarChartData: BarChartEntry.exampleHalfyear, lineChartData: LineChartEntry.example, circleChartData: CircleChartData.example)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let timeline = Timeline(entries: [SimpleEntry(date: Date(), barChartData: BarChartEntry.getData(), halfyearbarChartData: BarChartEntry.getDataHalfyear(), lineChartData: LineChartEntry.getData(), circleChartData: circleChartData())], policy: .atEnd)
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    var barChartData: [BarChartEntry] = []
    var halfyearbarChartData: [BarChartEntry] = []
    var lineChartData: [[LineChartEntry]] = []
    var circleChartData: CircleChartData = CircleChartData(percent: 0, upperText: "?", lowerText: "?")
}

private struct CalqWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: SimpleEntry
    
    var body: some View {
        switch family {
        case .systemSmall: CircleChartWidgetView(data: entry.circleChartData)
        case .systemMedium: BarChartWidgetView(values: entry.barChartData)
        default: CircleChartWidgetView(data: entry.circleChartData)
        }
    }
}

private struct CalqWidgetEntryView2: View {
    var entry: SimpleEntry
    
    var body: some View {
        GeometryReader { geo in
            LineChart(data: Binding.constant(entry.lineChartData), heigth: geo.size.height - 50)
                .padding()
        }
    }
}

private struct CalqWidgetEntryView3: View {
    var entry: SimpleEntry
    
    var body: some View {
        HalfyearBarChartWidgetView(values: entry.halfyearbarChartData)
    }
}

struct CalqWidget: Widget {
    let kind: String = "AverageWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalqWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Kreisdiagramm")
        .description("Gesamtdurchschnitt aller Fächer (ohne Prüfungen)")
        .supportedFamilies([.systemSmall])
    }
}

struct LineChartWidget: Widget {
    let kind: String = "LineChartWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalqWidgetEntryView2(entry: entry)
        }
        .configurationDisplayName("Liniendiagramm")
        .description("Notenverlauf aller Fächer")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: Medium BarChart Widget
struct BarChartWidget: Widget {
    let kind: String = "BarChartWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalqWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Balkendiagramm")
        .description("Aktueller Durchschnitt aller Fächer")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: Medium HalfyearBarChart Widget
struct HalfyearBarChartWidget: Widget {
    let kind: String = "HalfyearBarChartWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalqWidgetEntryView3(entry: entry)
        }
        .configurationDisplayName("Halbjahresdiagramm")
        .description("Durchshcnitt aller Halbjahre")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: Bundle
@main
struct CalqWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        CalqWidget()
        BarChartWidget()
        LineChartWidget()
        HalfyearBarChartWidget()
    }
}

// MARK: Preview
struct Widgets_Previews: PreviewProvider {
    
    static var previews: some View {
        CalqWidgetEntryView(entry: SimpleEntry(date: Date(), barChartData: BarChartEntry.example))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("BarChart")
        
        CalqWidgetEntryView3(entry: SimpleEntry(date: Date(), halfyearbarChartData: BarChartEntry.exampleHalfyear))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("HalfyearBarChart")
        
        CalqWidgetEntryView(entry: SimpleEntry(date: Date(), circleChartData: CircleChartData.example))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("CircleChart")
        
        CalqWidgetEntryView2(entry: SimpleEntry(date: Date(), lineChartData: LineChartEntry.example))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("LineChart")
    }
}
