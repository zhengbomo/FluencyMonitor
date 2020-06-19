//
//  FluencyMonitor.swift
//  Demo
//
//  Created by bomo on 2020/6/18.
//  Copyright © 2020 bomo. All rights reserved.
//

import Foundation


// 卡顿监控
public class FluencyMonitor {
    
    private var timeout = 0
    private var isMonitoring = false
    
    private var currentActivity: CFRunLoopActivity = .entry
    
    private let semphore = DispatchSemaphore.init(value: 0)
    private let eventSemaphore = DispatchSemaphore.init(value: 0)
    
    /// 监听runloop状态为before waiting状态下是否卡顿
    private let eventMonitorQueue = DispatchQueue.init(label: "com.bomo.util.event_monitor_queue")
    
    /// 监听runloop状态在after waiting和before sources之间
    private let fluecyMonitorQueue = DispatchQueue.init(label: "com.bomo.util.fluency_monitor_queue")
    
    // 监听器
    private var observer: CFRunLoopObserver?

    
    private init() {
        RCBacktrace.setup()
    }
    
    public static let shared = FluencyMonitor()
    
    
    public func start() {
        guard !self.isMonitoring else {
            return
        }
    
        self.isMonitoring = true
        
        
        let controllerPoint = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
        var context = CFRunLoopObserverContext(version: 0, info: controllerPoint, retain: nil, release: nil, copyDescription: nil)
        
        // 监听主线程runloop的状态
        self.observer = CFRunLoopObserverCreate(kCFAllocatorDefault,CFRunLoopActivity.allActivities.rawValue,true,0, callBackObserve(), &context)
        CFRunLoopAddObserver(CFRunLoopGetMain(), self.observer, CFRunLoopMode.commonModes);
        
        
        self.eventMonitorQueue.async {
            while self.isMonitoring {
                if self.currentActivity == .beforeWaiting {
                    var timeOut = true
                    DispatchQueue.main.async {
                        timeOut = false
                        self.eventSemaphore.signal()
                    }
                    Thread.sleep(forTimeInterval: 1)
                    if timeOut {
                        RCBacktrace.log(.main)
                    }
                    _ = self.eventSemaphore.wait(timeout: DispatchTime.distantFuture)
                }
            }
        }
        
        
        self.fluecyMonitorQueue.async {
            while self.isMonitoring {
                let waitResult = self.semphore.wait(timeout: DispatchTime.now() + .milliseconds(200))
                switch waitResult {
                case .success:
                    continue
                case .timedOut:
                    // 等待后需要判断是否关闭了监听
                    if self.isMonitoring &&
                        (self.currentActivity == .beforeSources ||
                        self.currentActivity == .afterWaiting) {
                        self.timeout += 1
                        if self.timeout < 5 {
                            continue;
                        }
                        // 5次超时，就log
                        RCBacktrace.log(.main)
                        
                        // 卡顿监控后，延迟5s
                        Thread.sleep(forTimeInterval: 5)
                    }
                }
                self.timeout = 0
            }
        }
    }
    
    public func stop() {
        if self.isMonitoring {
            // 删除监听
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observer, CFRunLoopMode.commonModes)
            
            self.observer = nil
            self.isMonitoring = false
        }
    }
    
    private func callBackObserve() -> CFRunLoopObserverCallBack {
        return { (observer, activity, context) in
            let _ = Unmanaged<AnyObject>.fromOpaque(context!).takeUnretainedValue()
            FluencyMonitor.shared.currentActivity = activity
            FluencyMonitor.shared.semphore.signal()
        }
    }
}



extension RCBacktrace {
    static func log(_ thread: Thread) {
        let symbols = RCBacktrace.callstack(thread)
        for symbol in symbols {
            print(symbol.description)
        }
    }
}
