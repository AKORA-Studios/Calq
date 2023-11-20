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
        let entry = SimpleEntry(date: Date(), barChartData: BarChartEntry.example, halfyearbarChartData: BarChartEntry.exampleHalfyear, lineChartData: LineChartEntry.example, circleChartData: CircleChartData.example, examChartData: WidgetExamEntrys.example)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let timeline = Timeline(entries: [SimpleEntry(date: Date(), barChartData: BarChartEntry.getData(), halfyearbarChartData: BarChartEntry.getDataHalfyear(), lineChartData: LineChartEntry.getData(), circleChartData: circleChartData(), examChartData: WidgetExamEntrys.createWidgetEntrys())], policy: .atEnd)
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    var barChartData: [BarChartEntry] = []
    var halfyearbarChartData: [BarChartEntry] = []
    var lineChartData: [[LineChartEntry]] = []
    var circleChartData: CircleChartData = CircleChartData(percent: 0, upperText: "?", lowerText: "?")
    var examChartData: WidgetExamEntrys = WidgetExamEntrys(entrycount: 5, blockpoints2: 0, blockpoints1: 12, entries: [])
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
        LincechartWidget(lineChartData: entry.lineChartData)
    }
}

private struct CalqWidgetEntryView3: View {
    var entry: SimpleEntry
    
    var body: some View {
        HalfyearBarChartWidgetView(values: entry.halfyearbarChartData)
    }
}

private struct CalqWidgetEntryView4: View {
    var entry: SimpleEntry
    
    var body: some View {
        ExamWidget(value: entry.examChartData)
    }
}

struct CalqWidget: Widget {
    let kind: String = "AverageWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalqWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("AverageWidget_DisplayName")
        .description("AverageWidget_Description")
        .supportedFamilies([.systemSmall])
    }
}

struct LineChartWidget: Widget {
    let kind: String = "LineChartWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalqWidgetEntryView2(entry: entry)
        }
        .configurationDisplayName("LineChartWidget_DisplayName")
        .description("LineChartWidget_Description")
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
        .configurationDisplayName("BarChartWidget_DisplayName")
        .description("BarChartWidget_Description")
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
        .configurationDisplayName("HalfyearBarChartWidget_DisplayName")
        .description("HalfyearBarChartWidget_Description")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: Medium HalfyearBarChart Widget
struct ExamChartWidget: Widget {
    let kind: String = "ExamChartWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalqWidgetEntryView4(entry: entry)
        }
        .configurationDisplayName("ExamChartWidget_DisplayName")
        .description("ExamChartWidget_Description")
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
        ExamChartWidget()
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
        
        CalqWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("NoData")
        
        CalqWidgetEntryView4(entry: SimpleEntry(date: Date(), examChartData: WidgetExamEntrys.example))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("ExamChart")
    }
}
