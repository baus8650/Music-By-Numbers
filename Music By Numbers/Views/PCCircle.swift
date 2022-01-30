//
//  PCCircle.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/25/22.
//

import UIKit

//@IBDesignable
class PCCircle: UIView {
    
    @IBInspectable var setShape = [0,1,4] {
        didSet{
            
            self.setNeedsDisplay()
            
        }
    }
    
    @IBInspectable var axisPoints = [[Int]]() {
        didSet {
            
            self.setNeedsDisplay()
            
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        
        let PCCircleFrame = CGRect(
            x: 63.0 / 2,
            y: 63.0 / 2,
            width: bounds.width - 63.0,
            height: bounds.height - 63.0)
        
        let path = UIBezierPath(ovalIn: PCCircleFrame)
        
        
        
        path.lineWidth = 3.0
        
        let points = getCirclePoints(centerPoint: CGPoint(x: PCCircleFrame.width / 2, y: PCCircleFrame.height / 2), radius: PCCircleFrame.width / 2, n: 12)
        
        path.stroke()
        //        let set = UIBezierPath()
        drawAxis(points: points, axis: self.axisPoints)
        
        drawSetShape(points: points, set: self.setShape)
        
        for i in 0..<points.count {
            var point = CGPoint(x: points[i].x, y: points[i].y)
            point.x += 27
            point.y += 27
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize( width: 10.0, height: 10.0)))
            circle.lineWidth = 2
            circle.fill()
        }
        
        
        
        //        let angleInRadians: CGFloat = 180 * .pi / 180
        //        let length: CGFloat = 500
        //        let axis = UIBezierPath()
        //        axis.move(to: CGPoint(x: PCCircleFrame.width / 2, y: PCCircleFrame.height / 2))
        //        axis.addLine(to: CGPoint(x: -sin(angleInRadians) * length, y: cos(angleInRadians) * length))
        //        axis.stroke()
    }
    
    func drawAxis(points: [CGPoint], axis: [[Int]]) {
        let axisLine = UIBezierPath()
        
        if axis.count > 1 {
            
        }
        
        if axis.count == 1 {
            if axis == [[]] {
                
            } else {
            axisLine.move(to: CGPoint(x: points[axis[0][0]].x + 32, y: points[axis[0][0]].y + 32))
            axisLine.addLine(to: CGPoint(x: points[axis[0][1]].x + 32, y: points[axis[0][1]].y + 32))
            UIColor.red.setStroke()
            axisLine.stroke()
            }
        } else if axis.count == 2 {
            
            let firstAvX = ((points[axis[0][0]].x + points[axis[0][1]].x) / 2) + 32
            let secondAvX = ((points[axis[0][0]].y + points[axis[0][1]].y) / 2) + 32
            
            let firstAvY = ((points[axis[1][0]].x + points[axis[1][1]].x) / 2) + 32
            let secondAvY = ((points[axis[1][0]].y + points[axis[1][1]].y) / 2) + 32
            
            axisLine.move(to: CGPoint(x: firstAvX , y: secondAvX))
            axisLine.addLine(to: CGPoint(x: firstAvY, y: secondAvY))
            
            UIColor.red.setStroke()
            axisLine.stroke()
            
        }
        
        
    }
    
    func drawSetShape(points: [CGPoint], set: [Int]) {
        let setShape = UIBezierPath()
        
        if set != [Int]() {
            setShape.move(to: CGPoint(x: points[set[0]].x + 32, y: points[set[0]].y + 32))
            for i in 1..<set.count {
                setShape.addLine(to: CGPoint(x: points[set[i]].x + 32, y: points[set[i]].y + 32))
            }
            setShape.addLine(to: CGPoint(x: points[set[0]].x + 32, y: points[set[0]].y + 32))
            UIColor.blue.setStroke()
            setShape.stroke()
        } else {
            setShape.move(to: CGPoint(x: points[0].x + 32, y: points[0].y + 32))
        }
    }
    
    func getCirclePoints(centerPoint point: CGPoint, radius: CGFloat, n: Int)->[CGPoint] {
        
        let result: [CGPoint] = stride(from: 270.0, to: 630.0, by: Double(360 / n)).map {
            
            let bearing = CGFloat($0) * .pi / 180
            let x = point.x + radius * cos(bearing)
            let y = point.y + radius * sin(bearing)
            return CGPoint(x: x, y: y)
        }
        return result
    }
    
    
    
}
