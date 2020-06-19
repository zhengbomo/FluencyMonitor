//
//  FPSLabel.swift
//  Demo
//
//  Created by bomo on 2020/6/19.
//  Copyright © 2020 bomo. All rights reserved.
//

import UIKit


public class FPS {
    private class WrapTarget {
        var fpsBlock: ((Int)->Void)?
        private var lastTime: TimeInterval = 0
        private var count: Double = 0
        
        init(_ block: ((Int)->Void)?) {
            self.fpsBlock = block
        }
        
        @objc func tick(_ link: CADisplayLink) {
            if let block = self.fpsBlock {
                // 第一次
                if (lastTime == 0) {
                    lastTime = link.timestamp;
                    count = 0
                    return;
                }
                
                count += 1.0
                let delta = link.timestamp - lastTime;
                
                // 1s触发一次
                if delta < 1 {
                    return
                }
                
                lastTime = link.timestamp;
                let fps = round(count / delta)
                count = 0;
                
                block(Int(fps))
            }
            
        }
    }
    
    private let displayLink: CADisplayLink
    private let target: WrapTarget
    
    public init(_ fpsBlock: ((Int)->Void)? = nil) {
        self.target = WrapTarget(fpsBlock)
        self.displayLink = CADisplayLink(target: self.target, selector: #selector(WrapTarget.tick(_:)))
        self.displayLink.add(to: RunLoop.main, forMode: .common)
    }
    
    public func setFpsBlock(_ fpsBlock: @escaping ((Int)->Void)) {
        self.target.fpsBlock = fpsBlock
    }
    
    deinit {
        self.displayLink.invalidate()
    }
}



