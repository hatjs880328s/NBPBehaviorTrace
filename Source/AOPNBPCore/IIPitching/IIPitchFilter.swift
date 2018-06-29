//
//  IIPitchFilter.swift
//  OralStunts
//
//  Created by Noah_Shan on 2018/6/26.
//  Copyright © 2018 Inspur. All rights reserved.
//

import Foundation

/// Filter-progress CLASS<sys class> & METHOD<sys method>
class IIPitchFilter: NSObject {
    
    /// ignore shouldn't progress classes
    private static let filterArr: [String] = ["TABLESwizzing","VCSwizzing","ApplicitonSwizzing","Aspect","AOPNBPCoreManagerCenter","GodfatherSwizzingPostnotification","AOPNotificaitonCenter"]
    
    /// ignore shouldn't progress methods
    private static let filterFunctionArr : [String] = ["init","startServices","cxx_destruct","AnalyzeNetWorkWithNoti","description","heightForRowAt","numberOfRowsInSection","cellForRowAt","didSelectRowAt","numberOfSections"]
    
    /// bundle name - progress swift class
    private static let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String + "."
    
    /// filter classes
    public static func filterNouseClass(className:String)->Bool {
        if !className.contains(bundleName) { return false }
        for eachItem in filterArr {
            if className.contains(eachItem) {
                return false
            }
        }
        
        return true
    }
    
    /// filter methods
    public static func filterNouseFunction(funcName:String) ->Bool {
        for eachItem in filterFunctionArr {
            if funcName.contains(eachItem) {
                return false
            }
        }
        
        return true
    }
}
