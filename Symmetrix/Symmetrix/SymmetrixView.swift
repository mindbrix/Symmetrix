//
//  SymmetrixView.swift
//  Symmetrix
//
//  Created by Nigel Barber on 27/01/2020.
//  Copyright © 2020 Mindbrix. All rights reserved.
//

import UIKit
import CoreGraphics

class SymmetrixView: UIView {
    
    var bitmapCtx: CGContext? = nil
    var lastPoint = CGPoint.zero
    var lineWidth: CGFloat = 8.0
    let turns = 20
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let width = Int(ceil(self.bounds.size.width * self.contentScaleFactor))
        let height = Int(ceil(self.bounds.size.height * self.contentScaleFactor))
        let RGB = CGColorSpaceCreateDeviceRGB()
        let BGRA = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        guard let ctx = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: RGB, bitmapInfo: BGRA.rawValue) else { return }
        ctx.setLineCap(CGLineCap.round)
        ctx.setLineJoin(CGLineJoin.round)
        ctx.scaleBy(x: self.contentScaleFactor, y: self.contentScaleFactor)
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fill(self.bounds)
        ctx.setStrokeColor(UIColor.black.cgColor)
        bitmapCtx = ctx
    }
    
    func clear() {
        guard let ctx = bitmapCtx else { return }
        ctx.fill(self.bounds)
        setNeedsDisplay()
    }
    
    func getImage() -> UIImage? {
        guard let ctx = bitmapCtx, let image = ctx.makeImage() else { return nil }
        return UIImage(cgImage: image)
    }
    func drawLine(startPoint: CGPoint, endPoint: CGPoint) {
        guard let ctx = bitmapCtx else { return }
        
        ctx.setLineWidth(lineWidth)
        let inset = ceil(lineWidth * 0.5)
        let centre = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        for t in 0 ..< turns {
            let angle = CGFloat(t) / CGFloat(turns) * CGFloat(.pi * 2.0)
            let rotation = CGAffineTransform(rotationAngle: angle)
            
            var m = CGAffineTransform(translationX: centre.x, y: centre.y)
            m = rotation.concatenating(m)
            m = m.translatedBy(x: -centre.x, y: -centre.y)
            
            let start = startPoint.applying(m)
            let end = endPoint.applying(m)
            
            ctx.move(to: start)
            ctx.addLine(to: end)
            ctx.strokePath()
            
            let origin = CGPoint(x: min(start.x, end.x), y: min(start.y, end.y))
            let size = CGSize(width:abs(start.x - end.x), height:abs(start.y - end.y))
            
            let dirtyRect = CGRect(origin:origin, size:size).insetBy(dx: -inset, dy: -inset)
            setNeedsDisplay(dirtyRect)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = touches.first!.location(in: self)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        drawLine(startPoint: lastPoint, endPoint: point)
        lastPoint = point
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        drawLine(startPoint: lastPoint, endPoint: point)
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = bitmapCtx, let image = ctx.makeImage(), let viewCtx = UIGraphicsGetCurrentContext() else { return }
        viewCtx.setBlendMode(.copy)
        viewCtx.interpolationQuality = .none
        viewCtx.draw(image, in: rect, byTiling: false)
    }
}
