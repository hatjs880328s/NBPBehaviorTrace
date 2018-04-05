//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// BLLOne.swift
//
// Created by    Noah Shan on 2018/3/28
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

// 
import Foundation

class BLLOne: NSObject,IBLLOne {
    
    func getName() {
        DEBUGPrintLog("getName-BLLOne")
    }
    
    func setName() {
        DEBUGPrintLog("setName-BLLOne")
    }
    
    deinit{
        print("bllone release")
    }
    
}

class BLLTwo: NSObject,IBLLOne {
    func getName() {
        DEBUGPrintLog("getName-BLLTwo")
    }
    
    func setName() {
        DEBUGPrintLog("setName-BLLTwo")
    }
    
    deinit{
        print("bll2 release")
    }
}
