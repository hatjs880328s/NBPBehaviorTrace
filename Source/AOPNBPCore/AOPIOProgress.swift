//
// 
//  AOPMmapIOProgress.swift
//  source
//
//  Created by Noah_Shan on 2018/4/8.
//  Copyright © 2018年 Inspur. All rights reserved.
//
// 
import Foundation

protocol  IAOPIOProgress {
    /// set data
    func postDataToDisk()
    /// get data
    func getAllSavedKeys() ->Array<String>?
    /// deleate data
    func deleateDiskDataWithFirstLevelKey(key: String)
}

class AOPIOProgress: IAOPIOProgress {
    
    func postDataToDisk() {
        
    }
    
    func getAllSavedKeys() -> Array<String>? {
        
        return nil
    }
    
    func deleateDiskDataWithFirstLevelKey(key: String) {
        
    }
    
    
}
