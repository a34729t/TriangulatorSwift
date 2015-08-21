//
//  GridView.swift
//  SwiftTri
//
//  Created by Nicolas Flacco on 6/18/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//
//  More or less converted from Objective-C code.
//  From http://stackoverflow.com/questions/18226496/how-to-draw-grid-lines-when-camera-is-open-avcapturemanager
//

import UIKit

class GridView: UIView {
    let gridWidth: CGFloat = 0.5
    var columns: Int

    init(frame: CGRect, columns: Int) {
        // Set size of grid
        self.columns = columns - 1
        super.init(frame: frame)
        
        // Set view to be transparent
        self.opaque = false;
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.0);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        let context: CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, gridWidth)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)

        // Calculate basic dimensions
        let columnWidth: CGFloat = self.frame.size.width / (CGFloat(self.columns) + 1.0)
        let rowHeight: CGFloat = columnWidth;
        let numberOfRows: Int = Int(self.frame.size.height)/Int(rowHeight);

        // ---------------------------
        // Drawing column lines
        // ---------------------------
        for i in 1...self.columns {
            var startPoint: CGPoint = CGPoint(x: columnWidth * CGFloat(i), y: 0.0)
            var endPoint: CGPoint = CGPoint(x: startPoint.x, y: self.frame.size.height)

            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
            CGContextStrokePath(context);
        }

        // ---------------------------
        // Drawing row lines
        // ---------------------------
        for j in 1...numberOfRows {
            var startPoint: CGPoint = CGPoint(x: 0.0, y: rowHeight * CGFloat(j))
            var endPoint: CGPoint = CGPoint(x: self.frame.size.width, y: startPoint.y)

            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
            CGContextStrokePath(context);
        }
    }
}
