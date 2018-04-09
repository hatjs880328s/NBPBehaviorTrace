//
//  Model2Sql.swift
//  DHBIos
//  创建表格使用
//  Created by MrShan on 2017/7/14.
//  Copyright © 2017年 JNDZ. All rights reserved.
//

import Foundation

class Model2Sql {
    
    private init() {
        
    }
    
    static var instance:Model2Sql?
    
    class func getInstance() ->Model2Sql {
        if self.instance == nil {
            return Model2Sql()
        }
        return self.instance!
    }
    
    /// 将model转化为某个创建表格的SQL语句
    ///
    /// - Parameter model: model
    /// - Returns: sql语句
    func model2SqlWithCtg(model:Any,tableName:String)->String {
        var resultInfo:[(String,String)] = []
        let mirror = Mirror(reflecting: model)
        for case let(key?, _) in mirror.children {
            if !key.contains("strInfo") {
                resultInfo.append((key, "varchar(50)"))
            }else{
                resultInfo.append((key, "TEXT"))
            }
        }
        return self.createTable(info: resultInfo,tableName:tableName)
    }
    
    /// 拼接SQL 方法
    ///
    /// - Parameters:
    ///   - info: 属性列表
    ///   - tableName: tablename
    /// - Returns: sql
    func createTable(info:[(String,String)],tableName:String)->String {
        var tabCreateSQL = "CREATE TABLE IF NOT EXISTS \(tableName) ("
        for i in 0 ... info.count - 1 {
            var eachSql = ""
            if i == 0 {
                eachSql = info[i].0 + " " + info[i].1 + " " + "primary key,"
            }else if i == (info.count - 1) {
                eachSql = info[i].0 + " " + info[i].1
            }else{
                eachSql = info[i].0 + " " + info[i].1 + ","
            }
            tabCreateSQL += eachSql
        }
        tabCreateSQL += ") ;"
        return tabCreateSQL
    }
    
    
}
