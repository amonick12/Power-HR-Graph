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
    
    //y-axis labels
    var topLabel = UILabel(frame: CGRectZero)
    var topMidLabel = UILabel(frame: CGRectZero)
    var midLabel = UILabel(frame: CGRectZero)
    var bottomMidLabel = UILabel(frame: CGRectZero)
    var bottomLabel = UILabel(frame: CGRectZero)
    
    var xLabels: [UILabel] = []
    
    override func drawRect(rect: CGRect) {

        let width = rect.width
        let height = rect.height
        
        //draw gradient
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
        let startPoint = CGPoint.zeroPoint
        let endPoint = CGPoint(x: 0, y: self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.DrawsAfterEndLocation)
        
        //calculate x point
        let margin: CGFloat = 35.0
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
        
        //horizontal lines
        let linePath = UIBezierPath()
        let lightColor = UIColor(white: 1.0, alpha: 0.5)
        lightColor.setStroke()
        //top line
        linePath.moveToPoint(CGPoint(x: margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: topBorder))
        topLabel.text = String(maxValue)
        topLabel.frame = CGRectMake(width - margin, topBorder - 15, 40, 30)
        topLabel.textColor = lightColor
        bottomLabel.textAlignment = .Center
        addSubview(topLabel)
        //top-half center line
        linePath.moveToPoint(CGPoint(x: margin, y: graphHeight/4 + topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: graphHeight/4 + topBorder))
        topMidLabel.text = String(maxValue/4 * 3)
        topMidLabel.frame = CGRectMake(width - margin, graphHeight/4 + topBorder - 15, 40, 30)
        topMidLabel.textColor = lightColor
        bottomLabel.textAlignment = .Center
        addSubview(topMidLabel)
        //center line
        linePath.moveToPoint(CGPoint(x: margin, y: graphHeight/2 + topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
        midLabel.text = String(maxValue/2)
        midLabel.frame = CGRectMake(width - margin, graphHeight/2 + topBorder - 15, 40, 30)
        midLabel.textColor = lightColor
        bottomLabel.textAlignment = .Center
        addSubview(midLabel)
        //bottom-half center line
        linePath.moveToPoint(CGPoint(x: margin, y: graphHeight/4 * 3 + topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: graphHeight/4 * 3 + topBorder))
        bottomMidLabel.text = String(maxValue/4)
        bottomMidLabel.frame = CGRectMake(width - margin, graphHeight/4 * 3 + topBorder - 15, 40, 30)
        bottomMidLabel.textColor = lightColor
        bottomLabel.textAlignment = .Center
        addSubview(bottomMidLabel)
        //bottom line
        linePath.moveToPoint(CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: height - bottomBorder))
        bottomLabel.text = "0"
        bottomLabel.frame = CGRectMake(width - margin, graphHeight + topBorder - 15, 30, 30)
        bottomLabel.textColor = lightColor
        bottomLabel.textAlignment = .Center
        addSubview(bottomLabel)
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
        let xInterval = powerGraphPoints.count / 10
//        if xLabels.isEmpty {
//            for i in 0...9 {
//                xLabels.append(UILabel(frame: CGRectZero))
//            }
//        }
        //vertical labels
//        xLabels.removeAll()
//        setNeedsDisplay()
        for i in 0..<10 {
            xLabels.append(UILabel(frame: CGRectZero))
            xLabels[i].text = String(xInterval * i / 60)
            xLabels[i].textColor = UIColor(white: 1.0, alpha: 0.5)
            //print(String(xInterval * i / 60))
            let ratio = Double(i)/10
            var xValue = Double(width) * ratio
            if i == 0 {
                xValue += 15
            }
            xLabels[i].frame = CGRectMake(margin + CGFloat(xValue) - 15, graphHeight + topBorder + 5, 30, 30)
            addSubview(xLabels[i])
        }
    }
    

}
