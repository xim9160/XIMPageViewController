//
//  CireView.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/25.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation
import UIKit

class Cireview: UIView{
    
    let animation = { () -> CABasicAnimation in
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        
        rotation.repeatCount = MAXFLOAT
        rotation.duration = 0.5
        rotation.isRemovedOnCompletion = false
        
        return rotation
    }()
    
    var value: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var maxableVlaue:CGFloat = 0
    
    var maximumValue: CGFloat = 0 {
        didSet { self.setNeedsDisplay() }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    func animation(start:Bool) -> Void {
        if start {
            self.layer.add(animation, forKey: nil)
        } else {
            self.layer.removeAllAnimations()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //创建一个画布
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        if self.value > self.maxableVlaue {
            self.value = self.maxableVlaue
        }
        
        let startAngle = CGFloat(((self.value / self.maximumValue) * 360 - 90)) * CGFloat(Double.pi) / 180
        let endAngle = CGFloat(-90) * CGFloat(Double.pi) / 180
        
        //创建一个矩形，它的所有边都内缩3
        let drawingRect = self.bounds.insetBy(dx: 1, dy: 1)
         
        //创建并设置路径
        let path = CGMutablePath()
         
        //圆弧半径
        let radius = min(drawingRect.width, drawingRect.height)/2
        //圆弧中点
        let center = CGPoint(x:drawingRect.midX, y:drawingRect.midY)
        //绘制圆弧
        
        path.addArc(center: center, radius: radius, startAngle: startAngle,
                    endAngle: endAngle, clockwise: true)
         
        //添加路径到图形上下文
        context.addPath(path)
        
        //设置端点样式
        context.setLineCap(.round)
         
        //设置笔触颜色
        context.setStrokeColor(UIColor.init("ff4848")?.cgColor ?? UIColor.red.cgColor)
        //设置笔触宽度
        context.setLineWidth(1.5)
         
        //绘制路径
        context.strokePath()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
