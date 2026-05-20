import SwiftUI

struct BeerGlassView: View {
    let fillFraction: CGFloat   // 0.0 – 1.0

    @State private var animated: CGFloat = 0
    @State private var foamOffset: CGFloat = 0

    private var isGood: Bool { fillFraction > 0.6 }
    private var liquidColor: Color { isGood ? Theme.beerLiquid : Color(red: 0.70, green: 0.72, blue: 0.76) }
    private var outlineColor: Color { isGood ? Theme.beerAmber : Theme.textSecondary }

    var body: some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height
            let bW = w * 0.70, bH = h * 0.85
            let bX = w * 0.04, bY = h * 0.06
            let r: CGFloat = 12

            let glass = glassPath(x: bX, y: bY, w: bW, h: bH, r: r)

            ctx.drawLayer { inner in
                inner.clip(to: glass)
                if animated > 0 {
                    let fillH = bH * animated
                    inner.fill(
                        Path(CGRect(x: bX, y: bY + bH - fillH, width: bW, height: fillH)),
                        with: .color(liquidColor)
                    )
                }
                if animated > 0.68 {
                    drawFoam(in: inner, bX: bX, bY: bY, bW: bW, bH: bH, offset: foamOffset)
                }
            }

            ctx.stroke(glass, with: .color(outlineColor), lineWidth: 2.5)
            ctx.stroke(handlePath(bX: bX, bY: bY, bW: bW, bH: bH, w: w),
                       with: .color(outlineColor),
                       style: StrokeStyle(lineWidth: 10, lineCap: .round))
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.72).delay(0.3)) { animated = fillFraction }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) { foamOffset = -4 }
        }
        .onChange(of: fillFraction) { _, new in
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) { animated = new }
        }
    }

    private func glassPath(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, r: CGFloat) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: x + r, y: y + h))
        p.addLine(to: CGPoint(x: x + w - r, y: y + h))
        p.addArc(center: .init(x: x + w - r, y: y + h - r), radius: r,
                 startAngle: .degrees(90), endAngle: .degrees(0), clockwise: true)
        p.addLine(to: CGPoint(x: x + w, y: y + r))
        p.addArc(center: .init(x: x + w - r, y: y + r), radius: r,
                 startAngle: .degrees(0), endAngle: .degrees(270), clockwise: true)
        p.addLine(to: CGPoint(x: x + r, y: y))
        p.addArc(center: .init(x: x + r, y: y + r), radius: r,
                 startAngle: .degrees(270), endAngle: .degrees(180), clockwise: true)
        p.addLine(to: CGPoint(x: x, y: y + h - r))
        p.addArc(center: .init(x: x + r, y: y + h - r), radius: r,
                 startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
        p.closeSubpath()
        return p
    }

    private func handlePath(bX: CGFloat, bY: CGFloat, bW: CGFloat, bH: CGFloat, w: CGFloat) -> Path {
        var p = Path()
        let hx = bX + bW - 1
        p.move(to: CGPoint(x: hx, y: bY + bH * 0.18))
        p.addCurve(
            to: CGPoint(x: hx, y: bY + bH * 0.62),
            control1: CGPoint(x: hx + w * 0.26, y: bY + bH * 0.18),
            control2: CGPoint(x: hx + w * 0.26, y: bY + bH * 0.62)
        )
        return p
    }

    private func drawFoam(in ctx: GraphicsContext, bX: CGFloat, bY: CGFloat,
                          bW: CGFloat, bH: CGFloat, offset: CGFloat) {
        let foamY = bY + bH - bH * animated + offset
        let bubbles: [(CGFloat, CGFloat)] = [
            (0.10, 10), (0.27, 12), (0.46, 11), (0.65, 13), (0.83, 10)
        ]
        for (xFrac, r) in bubbles {
            let cx = bX + bW * xFrac
            ctx.fill(
                Path(ellipseIn: CGRect(x: cx - r, y: foamY - r, width: r * 2, height: r * 2)),
                with: .color(.white.opacity(0.92))
            )
        }
    }
}

#Preview {
    HStack(spacing: 32) {
        BeerGlassView(fillFraction: 0.15).frame(width: 140, height: 220)
        BeerGlassView(fillFraction: 0.55).frame(width: 140, height: 220)
        BeerGlassView(fillFraction: 0.88).frame(width: 140, height: 220)
    }
    .padding()
    .background(Theme.warmBg)
}
