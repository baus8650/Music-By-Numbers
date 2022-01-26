//
//  PCCircle.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/25/22.
//

import UIKit

class PCCircle: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        let PCCircleFrame = CGRect(
            x: 13.0 / 2,
            y: 13.0 / 2,
            width: bounds.width - 13.0,
            height: bounds.height - 13.0)

//        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
//        let radius = max(bounds.width - 40 / 2, bounds.height - 40 / 2)
//        let smallRect = CGRect(x: 0.0, y: 0.0, width: bounds.width - 40, height: bounds.height - 40)
        let path = UIBezierPath(ovalIn: PCCircleFrame)



        path.lineWidth = 3.0
        
        let points = getCirclePoints(centerPoint: CGPoint(x: PCCircleFrame.width / 2, y: PCCircleFrame.height / 2), radius: PCCircleFrame.width / 2, n: 12)
        
        path.stroke()
        
        for i in 0..<points.count {
            var point = CGPoint(x: points[i].x, y: points[i].y)
            point.x += 2
            point.y += 2
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize( width: 10.0, height: 10.0)))
            circle.lineWidth = 2
//            circle.stroke()
//            UIColor.white.setFill()
            circle.fill()
        }
        
        let set = UIBezierPath()
        
        set.move(to: CGPoint(x: points[9].x + 5, y: points[9].y + 5))
        set.addLine(to: CGPoint(x: points[10].x + 5, y: points[10].y + 5))
        set.addLine(to: CGPoint(x: points[1].x + 5, y: points[1].y + 5))
        set.addLine(to: CGPoint(x: points[9].x + 5, y: points[9].y + 5))
        
        set.stroke()
        
        
    }
    
    func getCirclePoints(centerPoint point: CGPoint, radius: CGFloat, n: Int)->[CGPoint] {
        
        let result: [CGPoint] = stride(from: 0.0, to: 360.0, by: Double(360 / n)).map {
            
            let bearing = CGFloat($0) * .pi / 180
            let x = point.x + radius * cos(bearing)
            let y = point.y + radius * sin(bearing)
            return CGPoint(x: x, y: y)
        }
        return result
    }
    
    
}
