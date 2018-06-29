//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// shanGo.swift
//
// Created by    Noah Shan on 2018/3/13
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

import UIKit
import Foundation
import Aspects

/*
 non-buried point(NBP) SDK : AOP layer
 collect sys event & post notification to NotificationCenter
 */

class GodfatherSwizzingPostnotification: NSObject {
    class func postNotification(notiName: Notification.Name,userInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name: notiName, object: nil, userInfo: userInfo)
    }
}

class GodfatherSwizzing: NSObject {
    
    static let sourceJoinedCharacter: String = "-"
    
    func aopFunction() {}
}

class TABLESwizzing: GodfatherSwizzing {
    /// tb-celldid-deselected
    let tbDidselectedBlock: @convention(block) (_ id: AspectInfo)->Void = {aspectInfo in
        let event = AOPEventFilter.tbFilter(aspectInfo: aspectInfo)
        GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().tbDidSelectedAction, userInfo: [AOPEventType.tbselectedAction:event])
    }
    
    let tbBGBlock: @convention(block) (_ id: AspectInfo)->Void = {aspectInfo in
        
        let tab = (aspectInfo.instance() as! UITableView)
        let boolStr = IIModuleCore.getInstance().invokingSomeFunciton(url: "MineServiceModule/isShowAlertInfo", params: nil, action: nil)
        if boolStr == nil { return }
        if (boolStr as! String) == "true" {
            if tab.numberOfRows(inSection:0) != 0 {
                tab.backgroundView = nil
            }else{
                let resultVw = IIModuleCore.getInstance().invokingSomeFunciton(url: "MineServiceModule/getAlertVwWithParams:", params: ["frame":tab.frame], action: nil)
                tab.backgroundView = resultVw as? UIView
            }
        }else {
            tab.backgroundView = nil
            return
        }
    }
    
    let tbRemoveBGBlock: @convention(block) (_ id : AspectInfo)->Void = {aspectInfo in
        let tab = aspectInfo.instance() as! UITableView
        tab.backgroundView = nil
    }
    
    /// tab-celldeselected
    override func aopFunction() {
        do {
            try UITableView.aspect_hook(#selector(UITableView.deselectRow(at:animated:)),
                                        with: .init(rawValue:0),
                                        usingBlock: tbDidselectedBlock)
            try UITableView.aspect_hook(#selector(UITableView.reloadData),
                                        with: .init(rawValue:0),
                                        usingBlock: tbBGBlock)
        }catch {}
    }
}

class VCSwizzing: GodfatherSwizzing {
    /// vc-viewdidappear
    let viewdidAppearBlock: @convention(block) (_ id : AspectInfo)->Void = { aspectInfo in
        let event = AOPEventFilter.vcFilter(aspectInfo: aspectInfo, isAppear: true)
        GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().vceventAction, userInfo: [AOPEventType.vceventAction:event])
    }
    
    /// vc-viewdiddisappear
    let viewdidDisappearBlock:@convention(block) (_ id: AspectInfo)->Void = {aspectInfo in
        let event = AOPEventFilter.vcFilter(aspectInfo: aspectInfo, isAppear: false)
        GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().vceventAction, userInfo: [AOPEventType.vceventAction:event])
    }
    
    /// vc-viewdidappear & diddisappear
    override func aopFunction() {
        do {
            try UIViewController.aspect_hook(#selector(UIViewController.viewDidAppear(_:)),
                                             with: .init(rawValue: 0),
                                             usingBlock: self.viewdidAppearBlock)
            try UIViewController.aspect_hook(#selector(UIViewController.viewDidDisappear(_:)),
                                             with: .init(rawValue:0),
                                             usingBlock: viewdidDisappearBlock)
        }catch {}
    }
}

class ApplicitonSwizzing: GodfatherSwizzing {
    /// application-sendAction
    let appSendActionBlock:@convention(block) (_ id: AspectInfo)-> Void = { aspectInfo in
        let event = AOPEventFilter.appFilter(aspectInfo: aspectInfo)
        GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().appSendActions, userInfo: [AOPEventType.applicationSendaction:event])
    }
    
    /// navigation-pop(custom btn replace the sys navigationBar-backBtn)
    let navigationPopBlock:@convention(block) (_ id: AspectInfo)-> Void = { aspectInfo in
    }
    
    /// application sendaction
    override func aopFunction() {
        do{
            try UIControl.aspect_hook(#selector(UIControl.sendAction(_:to:for:)),
                                     with: .init(rawValue: 0),
                                     usingBlock: appSendActionBlock)
            try UINavigationController.aspect_hook(#selector(UINavigationController.popViewController(animated:)), with: .init(rawValue: 0), usingBlock: appSendActionBlock)
        }catch {}
    }
}


/// aop core manager---start service here [iipitching ^ aopnbpcore]
class AOPNBPCoreManagerCenter: NSObject {
    
    private static var shareInstance: AOPNBPCoreManagerCenter!
    
    /// aop-nbp-ut have cache ?
    public var isHaveCacheFunctions: Bool = false
    
    private override init() {
        super.init()
    }
    
    static func getInstance()-> AOPNBPCoreManagerCenter {
        if shareInstance == nil {
            shareInstance = AOPNBPCoreManagerCenter()
        }
        return shareInstance
    }
    
    /// AOP-NBP-monitor-service start  [withCache-if have cache functions]
    func startService(_ withCache: Bool = false) {
        self.createFolder()
        self.isHaveCacheFunctions = withCache
        AOPNotificaitonCenter.getInstance()
        ApplicitonSwizzing().aopFunction()
        TABLESwizzing().aopFunction()
        VCSwizzing().aopFunction()
    }
    
    /// before start service - create AOPNBP Folder - for mmap open file function
    private func createFolder() {
        let aopFileFolder = NSHomeDirectory().stringByAppendingPathComponent("Documents").stringByAppendingPathComponent("AOPNBPUTFile")
        let filemanager = FileManager()
        var isDir:ObjCBool = false
        let exist = filemanager.fileExists(atPath: aopFileFolder, isDirectory: &isDir)
        if !(isDir.boolValue && exist) {
            do {
                try filemanager.createDirectory(atPath: aopFileFolder, withIntermediateDirectories: true, attributes: nil)
            }catch {}
        }
    }
}

