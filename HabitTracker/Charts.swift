import Foundation
import SwiftUI

struct Line: View {
    var dataPoints: [Double]

    var highestPoint: Double {
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
        .padding(.vertical)
    }

    private func ratio(for index: Int) -> Double {
        dataPoints[index] / highestPoint
    }
}

struct LineChartCircleView: View {
    var dataPoints: [Double]
    var radius: CGFloat

    var highestPoint: Double {
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
                            y: height * dataPoints[index] / highestPoint))

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
        .padding(.vertical)
    }

    private func ratio(for index: Int) -> Double {
        dataPoints[index] / highestPoint
    }
}

struct WholeLineGraphView: View {
    var dataPoints: [Double]
    var lineColor = Color.red
    var innerCircleColor = Color.white
    var outerCircleColor = Color.red

    var body: some View {
        ZStack {
            Line(dataPoints: dataPoints)
                .accentColor(lineColor)

            LineChartCircleView(dataPoints: dataPoints, radius: 5.0)
                .accentColor(outerCircleColor)

            LineChartCircleView(dataPoints: dataPoints, radius: 2.0)
                .accentColor(innerCircleColor)
        }
    }
}

struct LineChartView: View {
    var dataPoints: [Double]
    var xDataPoints: [String]
    var lineColor: Color = .red
    var outerCircleColor: Color = .red
    var innerCircleColor: Color = .white
    var title: String = "default"
    var legend: String = "legend"
    @State private var currentDataNumber: Double = 0
    @State private var opacity: Double = 0
    var valueSpecifier: String = "%.1f"

    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 8) {
                Text(self.title)
                ZStack {
                    GeometryReader { reader in
                        Rectangle()
                            .foregroundColor(.white)
                        Legend(
                            data: self.dataPoints,
                            xData: self.xDataPoints,
                            frame: .constant(
                                CGRect(
                                    x: 0, y: 0, width: reader.frame(in: .local).width - 50,
                                    height: reader.frame(in: .local).height))
                        )

                        WholeLineGraphView(dataPoints: dataPoints)
                            .frame(
                                width: reader.frame(in: .local).width - 50,
                                height: reader.frame(in: .local).height
                            )
                            .offset(x: 40, y: -20)
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 240)
                    .offset(x: 0, y: 40)

                }
                .frame(width: geometry.frame(in: .local).size.width, height: 240)
            }
        }
    }
}
