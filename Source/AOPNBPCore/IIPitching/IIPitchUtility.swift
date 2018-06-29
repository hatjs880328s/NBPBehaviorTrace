//
//  TraverseUtility.swift
//  TraverseFunctions
//
//  Created by Noah_Shan on 2018/6/25.
//  Copyright © 2018 Inspur. All rights reserved.
//

import Foundation

/// Traverse all classes of this APP & progress them
class IIPitchUtility: NSObject {
    
    private static var shareInstance: IIPitchUtility!
    
    private static  let formatStrValue = "yyyy-MM-dd HH:mm:ss"
    
    private static let enterStr = "\n"
    
    private override init() {
        super.init()
    }
    
    @objc public static func getInstance() ->IIPitchUtility {
        if shareInstance == nil {
            shareInstance = IIPitchUtility()
        }
        return shareInstance
    }
    
    /// Custom [asm pitching code]
    @objc public var insertCode: ((_ id : AspectInfo)->Void)! {
        didSet{
            self.realInsertCode = insertCode
        }
    }
    
    /// [asm pitching code]
    private var realInsertCode: @convention(block) (_ id : AspectInfo)->Void = { aspectInfo in
        let className = aspectInfo.instance()
        let methodName = aspectInfo.originalInvocation()?.selector.description
        let parameters = aspectInfo.arguments()?.description
        //print("=========progress start=========")
        let time = Date().formatStr(format: formatStrValue)
        var realClassName = ""
        if className != nil {
            realClassName = "\(className!)".split(":")[0].substringFromIndex(1)
        }
        var realMethodName = ""
        if methodName != nil {
            realMethodName = methodName!.split("_")[2]
        }
        var realParameters = ""
        if parameters != nil {
            realParameters = parameters!
        }
        //print("=========progress ended=========")
        AOPMmapOCUtility.writeData(NSUUID().uuidString, fileContent: "[F:" + time + enterStr + realClassName + enterStr + realMethodName + enterStr + "\(Thread.current.description.split(">")[1])" + enterStr + realParameters + "]" + enterStr)
    }
    
    /// Start service[swift methods use @objc dynamic]
    @objc public func startService() {
        let ins = IIPitchCoreOBJC()
        ins.containsObject { (arr) in
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {[weak self] () in
                for eachItem in arr {
                    let className = eachItem as! String
                    if !IIPitchFilter.filterNouseClass(className: className) { continue }
                    self?.registerFunctions(className: className)
                }
            })
        }
    }
    
    /// runtime get class.type from str value
    ///
    /// - Returns: turpleInfo
    private func getClassType(className:String)->(String,AnyClass) {
        let cls:AnyClass = NSClassFromString(className)!
        return (className,cls)
    }
    
    /// aop-loop register methods
    private func registerFunctions(className:String) {
        var methodNum:UInt32 = 0
        let anyCls: AnyClass = getClassType(className: className).1
        let methodlist = class_copyMethodList(getClassType(className: className).1, &methodNum)
        for index in 0 ..< numericCast(methodNum) {
            let method:Method = methodlist![index]
            let methodSelector = method_getName(method)
            if IIPitchFilter.filterNouseFunction(funcName: methodSelector.description){
                self.aopFunction(selector: methodSelector, whoseIns: anyCls.self)
            }
        }
    }
    
    /// real swizzing methods
    private func aopFunction(selector:Selector,whoseIns: AnyClass) {
        do {
            let _ = try whoseIns.aspect_hook(selector,with: AspectOptions.positionBefore,usingBlock: self.realInsertCode)
        }catch {}
    }
}
