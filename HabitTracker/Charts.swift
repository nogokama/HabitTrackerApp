import Foundation
import SwiftUI

class ChartData: ObservableObject {
    @Published var xLabels: [String]
    @Published var yValues: [Double]

    init(xLabels: [String], yValues: [Double]) {
        self.xLabels = xLabels
        self.yValues = yValues
    }

    public func addPoint(xLabel: String, yValue: Double) {
        self.xLabels.append(xLabel)
        self.yValues.append(yValue)
    }

    public func pointsCount() -> Int {
        xLabels.count
    }
}

struct Line: View {
    var dataPoints: [Double]
    var forceMinValue: Double? = nil
    var forceMaxValue: Double? = nil

    var highestPoint: Double {
        if forceMaxValue != nil {
            return forceMaxValue!
        }
        let max = dataPoints.max() ?? 1.0
        if max == 0 {
            return 1.0
        }
        return max
    }

    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width

            Path { path in
                path.move(to: CGPoint(x: 0, y: height * self.ratio(for: 0)))

                for index in 1..<dataPoints.count {
                    path.addLine(
                        to: CGPoint(
                            x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                            y: height * self.ratio(for: index)))
                }
            }
            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
        }
    }

    private func ratio(for index: Int) -> Double {
        (highestPoint - dataPoints[index]) / highestPoint
    }
}

struct LineChartCircleView: View {
    var dataPoints: [Double]
    var radius: CGFloat
    var forceMinValue: Double? = nil
    var forceMaxValue: Double? = nil

    var highestPoint: Double {
        if forceMaxValue != nil {
            return forceMaxValue!
        }

        let max = dataPoints.max() ?? 1.0
        if max == 0 {
            return 1.0
        }
        return max
    }

    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width

            Path { path in
                path.move(to: CGPoint(x: 0, y: (height * self.ratio(for: 0)) - radius))

                path.addArc(
                    center: CGPoint(x: 0, y: height * self.ratio(for: 0)),
                    radius: radius, startAngle: .zero,
                    endAngle: .degrees(360.0), clockwise: false)

                for index in 1..<dataPoints.count {
                    path.move(
                        to: CGPoint(
                            x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                            y: height * self.ratio(for: index)))

                    path.addArc(
                        center: CGPoint(
                            x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                            y: height * self.ratio(for: index)),
                        radius: radius, startAngle: .zero,
                        endAngle: .degrees(360.0), clockwise: false)
                }
            }
            .stroke(Color.accentColor, lineWidth: 2)
        }
    }

    private func ratio(for index: Int) -> Double {
        (highestPoint - dataPoints[index]) / highestPoint
    }
}

struct WholeLineGraphView: View {
    @ObservedObject var chartData: ChartData
    var forceMinValue: Double? = nil
    var forceMaxValue: Double? = nil
    @Binding var colorStyleNumber: Int

    var body: some View {
        ZStack {
            Line(
                dataPoints: chartData.yValues, forceMinValue: forceMinValue,
                forceMaxValue: forceMaxValue
            )
            .accentColor(ColorStyles.allStyles[colorStyleNumber].mainColor)

            LineChartCircleView(
                dataPoints: chartData.yValues, radius: 4.0, forceMinValue: forceMinValue,
                forceMaxValue: forceMaxValue
            )
            .accentColor(ColorStyles.allStyles[colorStyleNumber].mainColor)

            LineChartCircleView(
                dataPoints: chartData.yValues, radius: 2.0, forceMinValue: forceMinValue,
                forceMaxValue: forceMaxValue
            )
            .accentColor(.white)
        }
    }
}

struct LineChartView: View {
    @ObservedObject var chartData: ChartData
    var forceMinValue: Double? = nil
    var forceMaxValue: Double? = nil
    var innerCircleColor: Color = .white
    @State private var opacity: Double = 0
    @Binding var colorStyleNumber: Int

    static let kChartHeight: CGFloat = 240
    static let kYLegendIndent: CGFloat = 40

    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    GeometryReader { reader in
                        Rectangle()
                            .foregroundColor(.white)
                        Legend(
                            chartData: chartData,
                            frame: .constant(
                                CGRect(
                                    x: 0, y: 0, width: reader.frame(in: .local).width,
                                    height: reader.frame(in: .local).height)),
                            dataAreaWidth: reader.frame(in: .local).width
                                - LineChartView.kYLegendIndent,
                            forceMinValue: forceMinValue, forceMaxValue: forceMaxValue
                        )

                        WholeLineGraphView(
                            chartData: chartData, forceMinValue: forceMinValue,
                            forceMaxValue: forceMaxValue, colorStyleNumber: $colorStyleNumber
                        )
                        .frame(
                            width: reader.frame(in: .local).width - LineChartView.kYLegendIndent,
                            height: reader.frame(in: .local).height
                        )
                        .offset(x: LineChartView.kYLegendIndent, y: 0)
                    }
                    .frame(
                        width: geometry.frame(in: .local).size.width,
                        height: LineChartView.kChartHeight)
                }
                .frame(
                    width: geometry.frame(in: .local).size.width, height: LineChartView.kChartHeight
                )
            }
        }
    }
}

struct CircleProgressBarView: View {
    let title: String
    let progress: Int
    @Binding var colorStyleNumber: Int

    var body: some View {
        VStack {
            Text(title)
            ZStack {
                Circle()
                    .stroke(lineWidth: 10.0)
                    .opacity(0.3)
                    .foregroundColor(ColorStyles.allStyles[colorStyleNumber].mainColor)
                    .scaledToFit()
                Circle()
                    .trim(
                        from: 0.0,
                        to: min(CGFloat(self.progress) / 100.0, 1.0)
                    )
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 10.0,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundColor(ColorStyles.allStyles[colorStyleNumber].mainColor)
                    .rotationEffect(Angle(degrees: 270.0))
                    .scaledToFit()
                Text("\(self.progress) %")
                    .font(.title3)
                    .bold()
            }
        }
    }
}
