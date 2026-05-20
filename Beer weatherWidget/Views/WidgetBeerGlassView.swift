import SwiftUI

// Simplified static version of BeerGlassView for use inside WidgetKit.
// No animation state — widgets render discrete snapshots.
struct WidgetBeerGlassView: View {
    let fillFraction: CGFloat   // 0.0 – 1.0

    private var isGood: Bool { fillFraction > 0.6 }
    private var liquid: Color { isGood ? Color(red: 0.82, green: 0.52, blue: 0.08) : Color(red: 0.70, green: 0.72, blue: 0.76) }
    private var outline: Color { isGood ? Color(red: 0.91, green: 0.63, blue: 0.13) : Color(red: 0.56, green: 0.60, blue: 0.67) }

    var body: some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height
            let bW = w * 0.70, bH = h * 0.85
            let bX = w * 0.04, bY = h * 0.06
            let r: CGFloat = max(5, h * 0.06)

            var glass = Path()
            glass.move(to: .init(x: bX + r, y: bY + bH))
            glass.addLine(to: .init(x: bX + bW - r, y: bY + bH))
            glass.addArc(center: .init(x: bX + bW - r, y: bY + bH - r), radius: r,
                         startAngle: .degrees(90), endAngle: .degrees(0), clockwise: true)
            glass.addLine(to: .init(x: bX + bW, y: bY + r))
            glass.addArc(center: .init(x: bX + bW - r, y: bY + r), radius: r,
                         startAngle: .degrees(0), endAngle: .degrees(270), clockwise: true)
            glass.addLine(to: .init(x: bX + r, y: bY))
            glass.addArc(center: .init(x: bX + r, y: bY + r), radius: r,
                         startAngle: .degrees(270), endAngle: .degrees(180), clockwise: true)
            glass.addLine(to: .init(x: bX, y: bY + bH - r))
            glass.addArc(center: .init(x: bX + r, y: bY + bH - r), radius: r,
                         startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
            glass.closeSubpath()

            ctx.drawLayer { inner in
                inner.clip(to: glass)
                if fillFraction > 0 {
                    let fh = bH * fillFraction
                    inner.fill(Path(CGRect(x: bX, y: bY + bH - fh, width: bW, height: fh)), with: .color(liquid))
                }
                if fillFraction > 0.68 {
                    let foamY = bY + bH - bH * fillFraction
                    for (xF, rad) in [(0.12, 9.0), (0.30, 11.0), (0.50, 10.0), (0.70, 11.0), (0.88, 9.0)] {
                        let cx = bX + bW * xF
                        inner.fill(Path(ellipseIn: CGRect(x: cx - rad, y: foamY - rad, width: rad * 2, height: rad * 2)),
                                   with: .color(.white.opacity(0.9)))
                    }
                }
            }

            ctx.stroke(glass, with: .color(outline), lineWidth: 2)

            var handle = Path()
            handle.move(to: .init(x: bX + bW - 1, y: bY + bH * 0.20))
            handle.addCurve(to: .init(x: bX + bW - 1, y: bY + bH * 0.62),
                            control1: .init(x: bX + bW + w * 0.24, y: bY + bH * 0.20),
                            control2: .init(x: bX + bW + w * 0.24, y: bY + bH * 0.62))
            ctx.stroke(handle, with: .color(outline), style: StrokeStyle(lineWidth: 8, lineCap: .round))
        }
    }
}
