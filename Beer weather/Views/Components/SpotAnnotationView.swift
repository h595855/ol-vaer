import SwiftUI

struct SpotAnnotationView: View {
    let spot: BeerSpot
    let score: Int?

    private var isGood: Bool { (score ?? 0) > 60 }
    private var tint: Color { isGood ? Theme.beerAmber : Theme.textSecondary }

    var body: some View {
        VStack(spacing: 3) {
            ZStack {
                Circle()
                    .fill(tint)
                    .frame(width: 36, height: 36)
                    .shadow(color: tint.opacity(0.4), radius: 4, y: 2)
                Image(systemName: "mug.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
            }
            // Pin tip
            Triangle()
                .fill(tint)
                .frame(width: 10, height: 6)
        }
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.closeSubpath()
        return p
    }
}
