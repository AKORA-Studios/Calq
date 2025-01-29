//
//  OverviewScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct OverviewScreen: View {
    @ObservedObject var vm: OverViewViewModel
    
    var body: some View {
        if #available(iOS 15.0, *) {
            GeometryReader { bounds in
                NavigationView {
                    ScrollView(showsIndicators: false) {
                        scrollViewBody(bounds)
                    }
                    .padding(.horizontal)
                    .navigationTitle("OverViewTitle")
                    .onAppear(perform: vm.updateViews)
                }.navigationViewStyle(StackNavigationViewStyle())
                    .refreshable {
                        vm.updateViews()
                    }
            }
            
        } else {
            GeometryReader { bounds in
                NavigationView {
                    ScrollView(showsIndicators: false) {
                        scrollViewBody(bounds)
                    }
                    .padding(.horizontal)
                    .navigationTitle("OverViewTitle")
                    .onAppear(perform: vm.updateViews)
                }.navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
    
    func scrollViewBody(_ bounds: GeometryProxy) -> some View {
        VStack {
            CardContainer {
                BarChart(values: $vm.subjectValues, heigth: 200, average: vm.generalAverage, round: true)
            }.frame(width: bounds.size.width - defaultPadding)
            
            CardContainer {
                LineChartView()
            }.frame(width: bounds.size.width - defaultPadding)
            
            CardContainer {
                VStack(alignment: .leading, spacing: 5) {
                    Text("OverViewHalfyearChartTitle")
                    BarChart(values: $vm.halfyears, heigth: 150)
                }
            }.frame(width: bounds.size.width - defaultPadding)
            
            CardContainer {
                CircleViews(bounds)
            }.frame(width: bounds.size.width - defaultPadding)
        }
    }
    
    // MARK: Subviews
    func CircleViews(_ bounds: GeometryProxy) -> some View {
        let x = (bounds.size.width)/2 - 2*defaultPadding
        return VStack {
            HStack(alignment: .center) {
                Text("OverviewPieChartSubjects")
                Spacer()
                Text("OverviewPieChartSum")
            }
            HStack(alignment: .center, spacing: 5) {
                CircleChart(percent: $vm.averagePercent, textDescription: "OverviewPieChartSubjectsDesc", upperText: $vm.averageText, lowerText: $vm.gradeText)
                    .frame(height: 150).frame(width: x)
                CircleChart(percent: $vm.blockPercent, textDescription: "OverviewPieChartSumDesc", upperText: $vm.blockCircleText, lowerText: Binding.constant("Ø"))
                    .frame(height: 150).frame(width: x)
            }
        }.frame(width: bounds.size.width - 3 * defaultPadding)
    }
    
    func LineChartView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("OverviewTimeChartTitle")
                Spacer()
                Image(systemName: "gearshape").onTapGesture {vm.showGraphEdit.toggle()}
                    .disabled(vm.subjects.count == 0)
                    .foregroundColor(vm.subjects.count == 0 ? .gray : Color(UIColor.label))
            }
            
            LineChart(data: $vm.lineChartEntries)
            
            if vm.showGraphEdit {
                GraphEditOptions()
            }
        }
    }
    
    func GraphEditOptions() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(vm.subjects) { sub in
                    let color = sub.showInLineGraph ? getSubjectColor(sub) : .gray
                    ZStack {
                        Text(sub.name)
                            .padding(5)
                            .font(.footnote)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(color, lineWidth: 3)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(color.opacity(0.4))
                                    )
                            )
                            .onTapGesture {
                                sub.showInLineGraph.toggle()
                                saveCoreData()
                                vm.updateViews()
                            }
                    }.padding(3)
                }
            }
        }
    }
}
