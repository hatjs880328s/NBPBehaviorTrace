//
// 
//  AOPSQliteUtility.swift
//  source
//
//  Created by Noah_Shan on 2018/4/8.
//  Copyright © 2018年 Inspur. All rights reserved.
//
// 
import Foundation


class AOPSQliteEventModel {
    var key: String = ""
    var eventInfo: String = ""
}

class AOPSQliteUtility: NSObject {
    static public var shareInstance: AOPSQliteUtility!
    
    private override init() {
        super.init()
        createTab()
    }
    
    public static func getInstance()->AOPSQliteUtility {
        if shareInstance == nil {
            shareInstance = AOPSQliteUtility()
        }
        return shareInstance
    }
    
    func createTab() {
        let createTBSql = Model2Sql.getInstance().model2SqlWithCtg(model: AOPSQliteEventModel(), tableName: "EventTb")
        FMDatabaseQueuePublicUtils.executeUpdate(sql: createTBSql)
    }
    
    func insertSome(key: String,value: String) {
        let sql = "insert into EventTb values ( '\(key)' , '\(value)');"
        FMDatabaseQueuePublicUtils.executeUpdate(sql: sql)
//        FMDatabaseQueuePublicUtils.executeSingleSQL(sql: sql)
    }
    
    func getSome()->NSMutableArray {
        let sql = "select * from EventTb ; "
        return FMDatabaseQueuePublicUtils.getResultWithSql(sql: sql)
    }
    
    
}
