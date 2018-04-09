//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPEventsUploadCenter.swift
//
// Created by    Noah Shan on 2018/3/16
// InspurEmail   shanwzh@inspur.com
// GithubAddress https://github.com/hatjs880328s
//
// Copyright © 2018年 Inspur. All rights reserved.
//
// For the full copyright and license information, plz view the LICENSE(open source)
// File that was distributed with this source code.
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
//

import Foundation

class AOPEventUploadCenter: NSObject {
    
    private static var shareInstance: AOPEventUploadCenter!
    
    var timer: Timer!
    
    private override init() {
        super.init()
    }
    
    public static func getInstance()->AOPEventUploadCenter {
        if shareInstance == nil {
            shareInstance = AOPEventUploadCenter()
        }
        return shareInstance
    }
    
    /// AOP-NBP-uploadCenter service start
    func startService() {
        DispatchQueue.once {
            timer = Timer.scheduledTimer(timeInterval: 40, target: self, selector: #selector(AOPEventUploadCenter.uploadEvents), userInfo: nil, repeats: true)
        }
    }
    
    @objc func uploadEvents() {
        GCDUtils.asyncProgress(dispatchLevel: 3, asyncDispathchFunc: {
            let allFilepath = AOPDiskIOProgress.getInstance().getAllSavedFilepath()
            for eachItem in allFilepath {
                let result = AOPDiskIOProgress.getInstance().getOneFileDataWithFilePath(with: eachItem)
                if result != nil {
                    //print(result!)
                }
            }
            
        }) {}
    }
}
