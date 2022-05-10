import Foundation
//
//  Legend.swift
//  LineChart
//
//  Created by András Samu on 2019. 09. 02..
//  Copyright © 2019. András Samu. All rights reserved.
//
//
//  IndicatorPoint.swift
//  LineChart
//
//  Created by András Samu on 2019. 09. 03..
//  Copyright © 2019. András Samu. All rights reserved.
//
//
//  MagnifierRect.swift
//
//
//  Created by Samu András on 2020. 03. 04..
//
import SwiftUI

struct Legend: View {
    var data: [Double]
    var xData: [String]
    @Binding var frame: CGRect
    var hideHorizontalLines: Bool = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var specifier: String = "%.0f"
    let padding: CGFloat = 3
    var forceMinValue: Double? = nil
    var forceMaxValue: Double? = nil

    var stepWidth: CGFloat {
        if data.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data.count - 1)
    }

    var stepHeight: CGFloat {
        let points = self.data
        var max: Double
        var min: Double
        if forceMaxValue != nil {
            max = forceMaxValue!
        } else {
            max = points.max()!
        }
        if forceMinValue != nil {
            min = forceMinValue!
        } else {
            min = points.min()!
        }
        if min != max {
            if min < 0 {
                return (frame.size.height - padding) / CGFloat(max - min)
            } else {
                return (frame.size.height - padding) / CGFloat(max - min)
            }
        }
        return 0
    }

    var min: CGFloat {
        let points = self.data
        if forceMinValue != nil {
            return CGFloat(forceMinValue!)
        }
        return CGFloat(points.min() ?? 0)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach((0...4), id: \.self) { height in
                HStack(alignment: .center) {
                    Text("\(self.getYLegendSafe(height: height), specifier: specifier)").offset(
                        x: 0, y: self.getYposition(height: height)
                    )
                    .foregroundColor(Colors.LegendText)
                    .font(.caption)
                    self.line(
                        atHeight: self.getYLegendSafe(height: height), width: self.frame.width
                    )
                    .stroke(
                        self.colorScheme == .dark ? Colors.LegendDarkColor : Colors.LegendColor,
                        style: StrokeStyle(
                            lineWidth: 1.5, lineCap: .round, dash: [5, height == 0 ? 0 : 10])
                    )
                    .opacity((self.hideHorizontalLines && height != 0) ? 0 : 1)
                    .rotationEffect(.degrees(180), anchor: .center)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .clipped()
                }

            }
            ForEach((0..<self.xData.count), id: \.self) { number in
                if number % 2 == 0 {
                    Text("\(xData[number])")
                        .offset(
                            x: getXPosition(pointNumber: number), y: self.frame.height + 3 * padding
                        )
                        .foregroundColor(Colors.LegendText)
                        .font(.caption)
                }
            }
        }
    }

    func getYLegendSafe(height: Int) -> CGFloat {
        if let legend = getYLegend() {
            return CGFloat(legend[height])
        }
        return 0
    }

    func getXPosition(pointNumber: Int) -> CGFloat {
        CGFloat(pointNumber) * stepWidth + 25
    }

    func getYposition(height: Int) -> CGFloat {
        if let legend = getYLegend() {
            return (self.frame.height - ((CGFloat(legend[height]) - min) * self.stepHeight))
                - (self.frame.height / 2)
        }
        return 0

    }

    func line(atHeight: CGFloat, width: CGFloat) -> Path {
        var hLine = Path()
        hLine.move(to: CGPoint(x: 5, y: (atHeight - min) * stepHeight))
        hLine.addLine(to: CGPoint(x: width, y: (atHeight - min) * stepHeight))
        return hLine
    }

    func getYLegend() -> [Double]? {
        let points = self.data
        guard var max = points.max() else { return nil }
        guard var min = points.min() else { return nil }
        if forceMinValue != nil {
            min = forceMinValue!
        }
        if forceMaxValue != nil {
            max = forceMaxValue!
        }
        let step = Double(max - min) / 4
        return [min + step * 0, min + step * 1, min + step * 2, min + step * 3, min + step * 4]
    }
}

public struct Colors {
    public static let color1: Color = Color(hexString: "#E2FAE7")
    public static let color1Accent: Color = Color(hexString: "#72BF82")
    public static let color2: Color = Color(hexString: "#EEF1FF")
    public static let color2Accent: Color = Color(hexString: "#4266E8")
    public static let color3: Color = Color(hexString: "#FCECEA")
    public static let color3Accent: Color = Color(hexString: "#E1614C")
    public static let OrangeEnd: Color = Color(hexString: "#FF782C")
    public static let OrangeStart: Color = Color(hexString: "#EC2301")
    public static let LegendText: Color = Color(hexString: "#A7A6A8")
    public static let LegendColor: Color = Color(hexString: "#E8E7EA")
    public static let LegendDarkColor: Color = Color(hexString: "#545454")
    public static let IndicatorKnob: Color = Color(hexString: "#FF57A6")
    public static let GradientUpperBlue: Color = Color(hexString: "#C2E8FF")
    public static let GradinetUpperBlue1: Color = Color(hexString: "#A8E1FF")
    public static let GradientPurple: Color = Color(hexString: "#7B75FF")
    public static let GradientNeonBlue: Color = Color(hexString: "#6FEAFF")
    public static let GradientLowerBlue: Color = Color(hexString: "#F1F9FF")
    public static let DarkPurple: Color = Color(hexString: "#1B205E")
    public static let BorderBlue: Color = Color(hexString: "#4EBCFF")
}

public struct GradientColor {
    public let start: Color
    public let end: Color

    public init(start: Color, end: Color) {
        self.start = start
        self.end = end
    }

    public func getGradient() -> Gradient {
        return Gradient(colors: [start, end])
    }
}

public struct GradientColors {
    public static let orange = GradientColor(start: Colors.OrangeStart, end: Colors.OrangeEnd)
    public static let blue = GradientColor(
        start: Colors.GradientPurple, end: Colors.GradientNeonBlue)
    public static let green = GradientColor(
        start: Color(hexString: "0BCDF7"), end: Color(hexString: "A2FEAE"))
    public static let blu = GradientColor(
        start: Color(hexString: "0591FF"), end: Color(hexString: "29D9FE"))
    public static let bluPurpl = GradientColor(
        start: Color(hexString: "4ABBFB"), end: Color(hexString: "8C00FF"))
    public static let purple = GradientColor(
        start: Color(hexString: "741DF4"), end: Color(hexString: "C501B0"))
    public static let prplPink = GradientColor(
        start: Color(hexString: "BC05AF"), end: Color(hexString: "FF1378"))
    public static let prplNeon = GradientColor(
        start: Color(hexString: "FE019A"), end: Color(hexString: "FE0BF4"))
    public static let orngPink = GradientColor(
        start: Color(hexString: "FF8E2D"), end: Color(hexString: "FF4E7A"))
}

extension Color {
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3:  // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}

public struct MagnifierRect: View {
    @Binding var currentNumber: Double
    var valueSpecifier: String
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    public var body: some View {
        ZStack {
            Text("\(self.currentNumber, specifier: valueSpecifier)")
                .font(.system(size: 18, weight: .bold))
                .offset(x: 0, y: -110)
                .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
            if self.colorScheme == .dark {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white, lineWidth: self.colorScheme == .dark ? 2 : 0)
                    .frame(width: 60, height: 260)
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 60, height: 280)
                    .foregroundColor(Color.white)
                    .shadow(color: Colors.LegendText, radius: 12, x: 0, y: 6)
                    .blendMode(.multiply)
            }
        }
        .offset(x: 0, y: -15)
    }
}
