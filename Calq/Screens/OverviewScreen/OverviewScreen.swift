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
            NavigationView {
                ScrollView(showsIndicators: false) {
                    scrollViewBody()
                }
                .padding(.horizontal)
                .navigationTitle("OverViewTitle")
                .onAppear(perform: vm.updateViews)
            }.navigationViewStyle(StackNavigationViewStyle())
            .refreshable {
                vm.updateViews()
            }
            
        } else {
            NavigationView {
                ScrollView(showsIndicators: false) {
                    scrollViewBody()
                }
                .padding(.horizontal)
                .navigationTitle("OverViewTitle")
                .onAppear(perform: vm.updateViews)
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    func scrollViewBody() -> some View {
        VStack {
            CardContainer {
                BarChart(values: $vm.subjectValues, heigth: 200, average: vm.generalAverage, round: true)
            }
            
            CardContainer {
                LineChartView()
            }
            
            CardContainer {
                VStack(alignment: .leading, spacing: 5) {
                    Text("OverViewHalfyearChartTitle")
                    BarChart(values: $vm.halfyears, heigth: 150)
                }
            }
            
            CardContainer {
                CircleViews()
            }
        }
    }
    
    // MARK: Subviews
    func CircleViews() -> some View {
        VStack {
            GeometryReader { geo in
                HStack(alignment: .center) {
                    Text("OverviewPieChartSubjects").frame(width: geo.size.width/2)
                    Spacer()
                    Text("OverviewPieChartSum") .frame(width: geo.size.width/2)
                }
            }
            HStack(alignment: .center, spacing: 5) {
                CircleChart(percent: $vm.averagePercent, textDescription: "OverviewPieChartSubjectsDesc", upperText: $vm.averageText, lowerText: $vm.gradeText).frame(height: 150)
                CircleChart(percent: $vm.blockPercent, textDescription: "OverviewPieChartSumDesc", upperText: $vm.blockCircleText, lowerText: Binding.constant("Ø")).frame(height: 150)
            }
        }
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
