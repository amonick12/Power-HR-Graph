//
//  GraphView.swift
//  Stryd iOS Task - Aaron Monick
//
//  Created by Aaron Monick on 8/14/15.
//  Copyright © 2015 aaronmonick. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {

    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()
    @IBInspectable var powerColor: UIColor = UIColor.whiteColor()
    @IBInspectable var hrColor: UIColor = UIColor.grayColor()
    
    var powerGraphPoints:[Int] = [0]
    var hrGraphPoints:[Int] = [0]

    var showPoints = false
    
    var xLabels: [UILabel] = []
    var yLabels: [UILabel] = []
    
    override func drawRect(rect: CGRect) {

        let width = rect.width
        let height = rect.height
        
        //draw gradient
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [1.0, 0.0]
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
        let startPoint = CGPoint.zeroPoint
        let endPoint = CGPoint(x: 0, y: self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.DrawsAfterEndLocation)
        
        //calculate x point
        let margin: CGFloat = 40.0
        let columnXPoint = { (column:Int) -> CGFloat in
            let spacer = (width - margin * 2 - 4) / CGFloat((self.powerGraphPoints.count - 1))
            var x: CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        //calculate y point
        let topBorder: CGFloat = 60
        let bottomBorder: CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = max(powerGraphPoints.maxElement()!, hrGraphPoints.maxElement()!)
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            var y: CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            y = graphHeight + topBorder - y
            return y
        }
        
        //power path
        powerColor.setFill()
        powerColor.setStroke()

        let powerGraphPath = UIBezierPath()
        powerGraphPath.moveToPoint(CGPoint(x: columnXPoint(0), y: columnYPoint(powerGraphPoints[0])))
        
        for i in 1..<powerGraphPoints.count {
            var nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(powerGraphPoints[i]))
            powerGraphPath.addLineToPoint(nextPoint)
            
            if showPoints {
                nextPoint.x -= 5.0/2
                nextPoint.y -= 5.0/2
                let circle = UIBezierPath(ovalInRect: CGRect(origin: nextPoint, size: CGSize(width: 5.0, height: 5.0)))
                circle.fill()
            }
        }
        
        powerGraphPath.stroke()
        
        //hr path
        hrColor.setFill()
        hrColor.setStroke()
        
        let hrGraphPath = UIBezierPath()
        hrGraphPath.moveToPoint(CGPoint(x: columnXPoint(0), y: columnYPoint(hrGraphPoints[0])))
        
        for i in 1..<hrGraphPoints.count {
            var nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(hrGraphPoints[i]))
            hrGraphPath.addLineToPoint(nextPoint)
            
            if showPoints {
                nextPoint.x -= 5.0/2
                nextPoint.y -= 5.0/2
                let circle = UIBezierPath(ovalInRect: CGRect(origin: nextPoint, size: CGSize(width: 5.0, height: 5.0)))
                circle.fill()
            }
        }
        
        hrGraphPath.stroke()
        
        //horizontal lines and labels
        let linePath = UIBezierPath()
        let lineColor = UIColor(white: 1.0, alpha: 0.5)
        let axisColor = UIColor(white: 1.0, alpha: 0.8)
        lineColor.setStroke()
        for i in 0..<5 {
            yLabels.append(UILabel(frame: CGRectZero))
            yLabels[i].textColor = axisColor
            yLabels[i].textAlignment = .Center
            switch i {
            case 0:
                //top line
                linePath.moveToPoint(CGPoint(x: margin, y: topBorder))
                linePath.addLineToPoint(CGPoint(x: width - margin, y: topBorder))
                yLabels[i].text = String(maxValue)
                yLabels[i].frame = CGRectMake(width - margin, topBorder - 15, 40, 30)
                break
            case 1:
                //top-half center line
                linePath.moveToPoint(CGPoint(x: margin, y: graphHeight/4 + topBorder))
                linePath.addLineToPoint(CGPoint(x: width - margin, y: graphHeight/4 + topBorder))
                yLabels[i].text = String(maxValue/4 * 3)
                yLabels[i].frame = CGRectMake(width - margin, graphHeight/4 + topBorder - 15, 40, 30)
                break
            case 2:
                //center line
                linePath.moveToPoint(CGPoint(x: margin, y: graphHeight/2 + topBorder))
                linePath.addLineToPoint(CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
                yLabels[i].text = String(maxValue/2)
                yLabels[i].frame = CGRectMake(width - margin, graphHeight/2 + topBorder - 15, 40, 30)
                break
            case 3:
                //bottom-half center line
                linePath.moveToPoint(CGPoint(x: margin, y: graphHeight/4 * 3 + topBorder))
                linePath.addLineToPoint(CGPoint(x: width - margin, y: graphHeight/4 * 3 + topBorder))
                yLabels[i].text = String(maxValue/4)
                yLabels[i].frame = CGRectMake(width - margin, graphHeight/4 * 3 + topBorder - 15, 40, 30)
                break
            case 4:
                //bottom line
                linePath.moveToPoint(CGPoint(x: margin, y: height - bottomBorder))
                linePath.addLineToPoint(CGPoint(x: width - margin, y: height - bottomBorder))
                yLabels[i].text = "0"
                yLabels[i].frame = CGRectMake(width - margin, graphHeight + topBorder - 15, 30, 30)
                break
            default:
                break
            }
            addSubview(yLabels[i])
        }
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
        //vertical labels
        let xInterval = powerGraphPoints.count / 10
        for i in 0..<10 {
            xLabels.append(UILabel(frame: CGRectZero))
            xLabels[i].text = String(xInterval * i / 60)
            xLabels[i].textColor = UIColor(white: 1.0, alpha: 0.8)
            let ratio = Double(i)/10
            var xValue = Double(width - 2 * margin) * ratio

            if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft || UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight {
                xValue = Double(width - margin) * ratio
            } else {
                xValue = Double(width - 2 * margin) * ratio
            }
            xLabels[i].frame = CGRectMake(CGFloat(xValue) + margin, graphHeight + topBorder + 5, 30, 30)
            addSubview(xLabels[i])
        }
    }
    

}
