//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPDiskCache.swift
//
// Created by    Noah Shan on 2018/3/14
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
import UIKit

/*
 event collector : collect all AOP events
 analyze event & progress them if should [data presistence]
 analyze event & progress them if should [upload to remote server]
 */
class AOP2LvlMemCache: NSObject {
    
    var postCount = 10
    
    var postSecs = 30
    
    private static var shareInstance :AOP2LvlMemCache!
    
    var dics: [String : [GodfatherEvent]] = [:]
    
    let diskCacheThread: IISlinkManager = IISlinkManager(linkname: NSUUID().uuidString)
    
    var timer: Timer!
    
    let eventJoinedStr = "-"
    
    private override init() {
        super.init()
        //self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.postSecs), target: self, selector: #selector(AOP2LvlMemCache.each30SecsPostEventsFromDic), userInfo: nil, repeats: true)
    }
    
    public static func getInstance()->AOP2LvlMemCache {
        if shareInstance == nil {
            shareInstance = AOP2LvlMemCache()
        }
        return shareInstance
    }
    
    /// add data from memcache
    func addItemsFromMemCache(dicData items : [String: [GodfatherEvent]]) {
        let addTask = IITaskModel(taskinfo: { () -> Bool in
            for eachKey in items.keys {
                self.dics[eachKey] = items[eachKey]
            }
            self.each30SecsPostEventsFromDic()
            DEBUGPrintLog("-disk had received data-")
            
            return true
        }, taskname: NSUUID().uuidString)
        self.diskCacheThread.addTask(task: addTask)
        
    }

    /// when time gose 30s & arr count added to 10 progress the function
    @objc func each30SecsPostEventsFromDic() {
        let getTask = IITaskModel(taskinfo: { () -> Bool in
            self.postDataToDisk()
            return true
        }, taskname: NSUUID().uuidString)
        self.diskCacheThread.addTask(task: getTask)
    }
    
    //MARK: setvalue to disk---------
    
    /// add data to disk
    private func postDataToDisk() {
        if self.dics.count == 0 { return }else {}
        AOPDiskIOProgress.getInstance().writeEventsToDisk(with: self.dics)
        self.dics.removeAll()
        DEBUGPrintLog("-saved to disk-")
    }
}
