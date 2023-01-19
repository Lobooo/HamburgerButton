//
//  HamburgerToArrow.swift
//  HamburgerToArrow
//
//  Created by Lobo on 2022/9/6.
//

import SwiftUI

struct HamburgerButton_SwiftUI: View {
    @Environment(\.colorScheme) var colorScheme
    var isLight: Bool { colorScheme == .light }
    @Binding var arrow: Bool
    let corner: CGFloat = 0
    let width: CGFloat = 21
    let height: CGFloat = 2
    let intrevalY: CGFloat = 5
    let duration: CGFloat = 0.25
    let intrevalWidth: CGFloat = 16
    let bottomYPosi: CGFloat = 12
    let offsetInRotate: CGFloat = 0.5
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: corner)
                .frame(width: width, height: 12)
                .opacity(0)
            VStack (alignment: .center, spacing: 5){
                //HamburgerTop
                RoundedRectangle(cornerRadius: corner)
                    .fill(isLight ? .black : .white)
                    .frame(width: (arrow ? 0.7*width : width), height: height)
                    .rotationEffect(.degrees(arrow ? 225 : 0))
                    .modifier(MyGeometryEffect(pct: self.arrow ? 1: 0, path: TopInfinityShape.createInfinityPath(in: CGRect(x: 0, y: 0, width: intrevalWidth, height: bottomYPosi-offsetInRotate))))
                
                //HamburgerMiddle
                RoundedRectangle(cornerRadius: corner)
                    .fill(isLight ? .black : .white)
                    .frame(width: (arrow ? 0.85*width : width), height: height)
                    .rotationEffect(.degrees(arrow ? 180 : 0))
                
                //HamburgerBottom
                RoundedRectangle(cornerRadius: corner)
                    .fill(isLight ? .black : .white)
                    .frame(width: (arrow ? 0.7*width : width), height: height)
                    .rotationEffect(.degrees(arrow ? 135 : 0))
                    .modifier(MyGeometryEffect(pct: self.arrow ? 1: 0, path: BottomInfinityShape.createInfinityPath(in: CGRect(x: 0, y: 0, width: intrevalWidth, height: bottomYPosi-offsetInRotate))))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.timingCurve(0.4, 0.0, 0.2, 1.0, duration: duration)) {
                self.arrow.toggle()
            }
        }
    }
}

struct MyGeometryEffect: GeometryEffect {
    var pct: CGFloat = 0
    let path: Path

    var animatableData: CGFloat {
        get { return pct }
        set { pct = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        
        let pt = percentPoint(percent: pct)

            return ProjectionTransform(CGAffineTransform(translationX: pt.x, y: pt.y))
    }

    func percentPoint(percent: CGFloat) -> CGPoint {

        let pct = percent > 1 ? 0 : (percent < 0 ? 1 : percent)

        let f = pct > 0.999 ? CGFloat(1-0.001) : pct
        let t = pct > 0.999 ? CGFloat(1) : pct + 0.001
        let tp = path.trimmedPath(from: f, to: t)

        return CGPoint(x: tp.boundingRect.midX, y: tp.boundingRect.midY)
    }
}
struct TopInfinityShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        return TopInfinityShape.createInfinityPath(in: rect)
    }

    static func createInfinityPath(in rect: CGRect) -> Path {
        
        let h = rect.height
        let w = rect.width
        var path = Path(UIBezierPath().cgPath)

        path.move(to: CGPoint(x:0, y: 0))
        path.addCurve(to: CGPoint(x:-0.3*w, y: h), control1: CGPoint(x:0.5*w, y: 0), control2: CGPoint(x:0.5*w, y: h+3))
        
        return path
    }
}
struct BottomInfinityShape: Shape {
    
    let tb: Bool
    func path(in rect: CGRect) -> Path {
        return BottomInfinityShape.createInfinityPath(in: rect)
    }

    static func createInfinityPath(in rect: CGRect) -> Path {
        
        let h = rect.height
        let w = rect.width
        var path = Path(UIBezierPath().cgPath)
        path.move(to: CGPoint(x:0, y: 0))
        path.addCurve(to: CGPoint(x:-0.3*w, y: -h), control1: CGPoint(x:-0.3*w, y: 0), control2: CGPoint(x:-0.3*w, y: -h))
        
        return path
    }
}
