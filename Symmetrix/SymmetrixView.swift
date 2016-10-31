//
//  SymmetrixView.swift
//  Symmetrix
//
//  Created by Nigel Barber on 31/10/2016.
//  Copyright © 2016 @mindbrix. All rights reserved.
//

import UIKit
import CoreGraphics

class SymmetrixView: UIView {

    var ctx: CGContext? = nil
    var lastPoint = CGPointZero
    let lineWidth: CGFloat = 1.0
    let turns = 120
    
    func createAndInitialiseContext() {
        if ctx == nil {
            guard let _ctx = createBitmapContext() else { return }
            ctx = _ctx
            CGContextSetLineWidth(ctx, lineWidth)
            CGContextSetLineCap(ctx, CGLineCap.Round)
            CGContextSetLineJoin(ctx, CGLineJoin.Round)
            CGContextScaleCTM(ctx, self.contentScaleFactor, self.contentScaleFactor)
            CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor)
            CGContextFillRect(ctx, self.bounds)
            CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
        }
    }
    
    func createBitmapContext() -> CGContext? {
        let width = Int(ceil(self.bounds.size.width * self.contentScaleFactor))
        let height = Int(ceil(self.bounds.size.height * self.contentScaleFactor))
        let RGB = CGColorSpaceCreateDeviceRGB()
        let BGRA = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue)
        return CGBitmapContextCreate(nil, width, height, 8, width * 4, RGB, BGRA.rawValue)
    }
    
    func clear() {
        createAndInitialiseContext()
        CGContextFillRect(ctx, self.bounds)
        setNeedsDisplay()
    }
    
    func getImage() -> UIImage? {
        if ctx != nil {
            if let image = CGBitmapContextCreateImage(ctx) {
                return UIImage(CGImage: image, scale: 1.0, orientation: .Down)
            }
        }
        return nil
    }
    func drawLine(startPoint: CGPoint, endPoint: CGPoint) {
        createAndInitialiseContext()
        let inset = ceil(lineWidth * 0.5)
        let centre = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        for t in 0 ... turns {
            let angle = CGFloat(t) * CGFloat(M_PI * 2.0) / CGFloat(turns)
            let rotation = CGAffineTransformMakeRotation(angle)
            
            var m = CGAffineTransformMakeTranslation(centre.x, centre.y)
            m = CGAffineTransformConcat(rotation, m)
            m = CGAffineTransformTranslate(m, -centre.x, -centre.y)
            
            let start = CGPointApplyAffineTransform(startPoint, m)
            let end = CGPointApplyAffineTransform(endPoint, m)
            
            CGContextMoveToPoint(ctx, start.x, start.y)
            CGContextAddLineToPoint(ctx, end.x, end.y)
            CGContextStrokePath(ctx)
            
            let origin = CGPoint(x: min(start.x, end.x), y: min(start.y, end.y))
            let size = CGSize(width:abs(start.x - end.x), height:abs(start.y - end.y))
            
            let dirtyRect = CGRect(origin:origin, size:size).insetBy(dx: -inset, dy: -inset)
            setNeedsDisplayInRect(dirtyRect)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastPoint = touches.first!.locationInView(self)
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first!.locationInView(self)
        drawLine(lastPoint, endPoint: point)
        lastPoint = point
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first!.locationInView(self)
        drawLine(lastPoint, endPoint: point)
    }
    
    override func drawRect(rect: CGRect) {
        if ctx != nil {
            let viewCtx = UIGraphicsGetCurrentContext()
            CGContextSetBlendMode(viewCtx, .Copy)
            CGContextSetInterpolationQuality(viewCtx, .None)
            guard let image = CGBitmapContextCreateImage(ctx) else { return }
            CGContextDrawImage(viewCtx, self.bounds, image)
        }
    }
}
