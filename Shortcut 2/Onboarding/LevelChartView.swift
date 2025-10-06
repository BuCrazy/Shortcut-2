//
//  LevelChartView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 8/12/25.
//

import SwiftUI
import Charts

struct LevelChartView: View {
    let levelType: LevelType
    @Binding var levelSelectorData: [LevelSelectorData]
    let opacity: Double
    
    var body: some View {
        Chart {
            ForEach(levelSelectorData) { item in
                AreaMark(
                    x: .value("frequency", item.hour),
                    y: .value("data", item.animate ? item.almostLearnedWords : 0)
                )
                .foregroundStyle(chartGradientArea)
                .interpolationMethod(.catmullRom)
                
                LineMark(
                    x: .value("frequency", item.hour),
                    y: .value("data", item.animate ? item.almostLearnedWords : 0)
                )
                .foregroundStyle(chartGradientLine)
                .interpolationMethod(.catmullRom)
                .shadow(radius: 2, x: 0, y: 2)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 153)
        .frame(width: 338)
        .opacity(opacity)
        
        // MARK: - Gradient Configurations
          var chartGradientArea: LinearGradient {
            switch levelType {
            case .elementary:
                return ChartGradients.chartGradientAreaElementary
            case .beginner:
                return ChartGradients.chartGradientAreaBeginner
            case .intermediate:
                return ChartGradients.chartGradientAreaIntermediate
            case .advanced:
                return ChartGradients.chartGradientAreaAdvanced
            case .nativelike:
                return ChartGradients.chartGradientAreaNativelike
            case .shakespeare:
                return ChartGradients.chartGradientAreaShakespeare
            }
        }
        
        var chartGradientLine: LinearGradient {
            switch levelType {
            case .elementary:
                return ChartGradients.chartGradientLineElementary
            case .beginner:
                return ChartGradients.chartGradientLineBeginner
            case .intermediate:
                return ChartGradients.chartGradientLineIntermediate
            case .advanced:
                return ChartGradients.chartGradientLineAdvanced
            case .nativelike:
                return ChartGradients.chartGradientLineNativelike
            case .shakespeare:
                return ChartGradients.chartGradientLineShakespeare
            }
        }
    }
}

#Preview {
    //LevelChartView()
    @Previewable @State var sampleData: [LevelSelectorData] = [
            LevelSelectorData(hour: 0, almostLearnedWords: 100, animate: true),
            LevelSelectorData(hour: 1, almostLearnedWords: 50, animate: true),
            LevelSelectorData(hour: 4, almostLearnedWords: 20, animate: true),
            LevelSelectorData(hour: 10, almostLearnedWords: 10, animate: true),
            LevelSelectorData(hour: 17, almostLearnedWords: 5, animate: true),
            LevelSelectorData(hour: 25, almostLearnedWords: 2, animate: true),
            LevelSelectorData(hour: 40, almostLearnedWords: 1, animate: true)
        ]
        
        return LevelChartView(
            levelType: .intermediate,
            levelSelectorData: $sampleData,
            opacity: 1.0
        )

}

enum LevelType: Int, CaseIterable {
    case elementary = 1
    case beginner = 2
    case intermediate = 3
    case advanced = 4
    case nativelike = 5
    case shakespeare = 6
}

// MARK: - Chart Gradients
struct ChartGradients {
    // Elementary
    static let chartGradientAreaElementary = LinearGradient( //area
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.00),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.24), location: 0.35),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.7),
        ],
        startPoint: /*.top,*/UnitPoint(x: 0.01, y: 0.55),
        endPoint: /*.bottom*/UnitPoint(x: 0.01, y: 0.0)
    )
    
    static let chartGradientLineElementary = LinearGradient( //line
        stops: [
            Gradient.Stop(color: Color(red: 0.157, green: 0.098, blue: 0.016).opacity(1), location: 0.000),
            Gradient.Stop(color: Color(red: 1, green: 0.569, blue: 0).opacity(1), location: 0.0125),
            Gradient.Stop(color: Color(red: 0.161, green: 0.125, blue: 0.075).opacity(1), location: 0.0250),
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // Beginner
    static let chartGradientAreaBeginner = LinearGradient( //area
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.35),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.24), location: 0.55),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.9),
        ],
        startPoint: /*.top*/UnitPoint(x: 0.01, y: 1.0),
        endPoint: /*.bottom*/ UnitPoint(x: -0.01, y: 0.45)
    )
    
    static let chartGradientLineBeginner = LinearGradient( //line
        stops: [
            Gradient.Stop(color: Color(red: 0.157, green: 0.098, blue: 0.016).opacity(1), location: 0.0250),
            Gradient.Stop(color: Color(red: 1, green: 0.569, blue: 0).opacity(1), location: 0.0625),
            Gradient.Stop(color: Color(red: 0.161, green: 0.125, blue: 0.075).opacity(1), location: 0.0999),
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // Intermediate
    static let chartGradientAreaIntermediate = LinearGradient( //area
        stops: [
        Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0), location: 0.10),
        Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.07), location: 0.19),
        Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.13), location: 0.28),
        Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.15), location: 0.54),
        Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.08), location: 0.64),
        Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0), location: 0.74),
        ],
        startPoint: UnitPoint(x: 0.30, y: 0.82),
        endPoint: UnitPoint(x: -0.01, y: 0.77)
        )
    
    static let chartGradientLineIntermediate = LinearGradient( //line
        stops: [
            Gradient.Stop(color: Color(red: 0.157, green: 0.098, blue: 0.016).opacity(1), location: 0.1000),
            Gradient.Stop(color: Color(red: 1, green: 0.569, blue: 0).opacity(1), location: 0.1750),
            Gradient.Stop(color: Color(red: 0.161, green: 0.125, blue: 0.075).opacity(1), location: 0.2500),
        ],
        startPoint: /*.leading*/UnitPoint(x: 0.35, y: 0.82),
        endPoint: /*.trailing*/ UnitPoint(x: -0.7, y: 0.77)
    )
    
    // Advanced
    static let chartGradientAreaAdvanced = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.2500),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.24), location: 0.3450),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.4250),
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let chartGradientLineAdvanced = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.157, green: 0.098, blue: 0.016).opacity(1), location: 0.2500),
            Gradient.Stop(color: Color(red: 1, green: 0.569, blue: 0).opacity(1), location: 0.3450),
            Gradient.Stop(color: Color(red: 0.161, green: 0.125, blue: 0.075).opacity(1), location: 0.4250),
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // Native-like
    static let chartGradientAreaNativelike = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.4250),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.24), location: 0.5250),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.6250),
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let chartGradientLineNativelike = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.157, green: 0.098, blue: 0.016).opacity(1), location: 0.4250),
            Gradient.Stop(color: Color(red: 1, green: 0.569, blue: 0).opacity(1), location: 0.5250),
            Gradient.Stop(color: Color(red: 0.161, green: 0.125, blue: 0.075).opacity(1), location: 0.6250),
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // Shakespeare
    static let chartGradientAreaShakespeare = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.1),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.6250),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.24), location: 0.8215)
           
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let chartGradientLineShakespeare = LinearGradient(
        stops: [
           
            Gradient.Stop(color: Color(red: 0.161, green: 0.125, blue: 0.075).opacity(1), location: 0.1),
            Gradient.Stop(color: Color(red: 0.157, green: 0.098, blue: 0.016).opacity(1), location: 0.6250),
            Gradient.Stop(color: Color(red: 1, green: 0.569, blue: 0).opacity(1), location: 0.8125),
            
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
}
