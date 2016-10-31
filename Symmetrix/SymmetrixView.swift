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
    let lineWidth: CGFloat = 2.0
    
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
    
    func drawLine(startPoint: CGPoint, endPoint: CGPoint) {
        createAndInitialiseContext()
        CGContextMoveToPoint(ctx, startPoint.x, startPoint.y)
        CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y)
        CGContextStrokePath(ctx)
        
        let origin = CGPoint(x: min(startPoint.x, endPoint.x), y: min(startPoint.y, endPoint.y))
        let size = CGSize(width:abs(startPoint.x - endPoint.x), height:abs(startPoint.y - endPoint.y))
        let inset = ceil(lineWidth * 0.5)
        let dirtyRect = CGRect(origin:origin, size:size).insetBy(dx: -inset, dy: -inset)
        setNeedsDisplayInRect(dirtyRect)
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
            CGContextSetBlendMode(viewCtx, CGBlendMode.Copy)
            CGContextSetInterpolationQuality(viewCtx, CGInterpolationQuality.None)
            guard let image = CGBitmapContextCreateImage(ctx) else { return }
            CGContextDrawImage(viewCtx, self.bounds, image)
        }
    }
}
