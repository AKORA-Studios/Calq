import CoreData
import SwiftUI
import WidgetKit

private struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let midnight = Calendar.current.startOfDay(for: Date())
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        let entries = [SimpleEntry(date: midnight)]
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
}

private struct CalqWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        
        switch family {
        case .systemSmall: ZStack { return AverageView()}
        case .systemMedium: ZStack { return OverviewView()}
        default: ZStack { return AverageView()}
        }
    }
}



struct CalqWidget: Widget {
    let kind: String = "AverageWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalqWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Durchschnitt Widget")
        .description("Gesamtdurchschnitt aller Fächer (ohne Prüfungen)")
        .supportedFamilies([.systemSmall])
    }
}


//MARK: Medium BarChart Widget
struct BarChartWidget: Widget {
    let kind: String = "BarChartWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalqWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("BarChart Widget")
        .description("Aktueller Durchschnitt aller Fächer")
        .supportedFamilies([.systemMedium])
    }
}


//MARK: Bundle
@main
struct CalqWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget{
        CalqWidget()
        BarChartWidget()
    }
}
