import CoreData
import SwiftUI
import WidgetKit

let previewSubejcts = JSON.createWidgetPreviewData()

private struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let timeline = Timeline(entries: [SimpleEntry(date: Date())], policy: .atEnd)
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
}

private struct CalqWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: SimpleEntry
    
    var body: some View {
        switch family {
        case .systemSmall: AverageView()
        case .systemMedium: BarChartWidgetView()
        default: AverageView()
        }
    }
}

private struct CalqWidgetEntryView2: View {
    var entry: SimpleEntry
    let subjects = Util.getAllSubjects()
    
    var body: some View {
        GeometryReader{geo in
            if(subjects.isEmpty){
                EmptyMediumView()
            } else {
                LineChart(subjects: Binding.constant(subjects), heigth: geo.size.height - 50)
                    .padding()
            }
        }
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

struct lineWidget: Widget {
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

//MARK: Medium BarChart Widget
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


//MARK: Bundle
@main
struct CalqWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget{
        CalqWidget()
        BarChartWidget()
        lineWidget()
    }
}

//MARK: Preview
struct widgets_Previews: PreviewProvider {
    static var previews: some View {
        CalqWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("BarChart")
        
        CalqWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("CircleChart")
        
        CalqWidgetEntryView2(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("LineChart")
    }
}
