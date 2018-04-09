//
//  Model2Sql.swift
//  DHBIos
//  插入数据使用
//  Created by MrShan on 2017/7/14.
//  Copyright © 2017年 JNDZ. All rights reserved.
//

import Foundation

class Model2SqlInsert {
    
    private init() {
        
    }
    
    static var instance:Model2SqlInsert?
    
    class func getInstance() ->Model2SqlInsert {
        if self.instance == nil {
            return Model2SqlInsert()
        }
        return self.instance!
    }
    
    /// 将model转化为某个创建表格的SQL语句
    ///
    /// - Parameter model: model
    /// - Returns: sql语句
    func insertModelWithCtg(model:Any,tableName:String)->String {
        var resultInfo:[(String,String)] = []
        let mirror = Mirror(reflecting: model)
        for case let(_, value) in mirror.children {
            if (value as AnyObject).isKind(of: NSNumber.self) {
                resultInfo.append(("number",value as! String))
            }else{
                let mirrorC = Mirror(reflecting: value as AnyObject).children.count
                if mirrorC == 0 || mirrorC == 1{
                    resultInfo.append(("string", value as! String))
                }else{ }
            }
        }
        return self.insertSQLCreate(info: resultInfo,tableName:tableName)
    }
    
    /// 拼接SQL 方法
    ///
    /// - Parameters:
    ///   - info: 属性列表
    ///   - tableName: tablename
    /// - Returns: sql
    func insertSQLCreate(info:[(String,String)],tableName:String)->String {
        var tabCreateSQL = "INSERT INTO \(tableName) VALUES ("
        for i in 0 ... info.count - 1 {
            if i == info.count - 1 {
                tabCreateSQL += "'" + info[i].1 + "'"
            }else{
                tabCreateSQL += "'" + info[i].1 + "'" + " , "
            }
        }
        tabCreateSQL += ") ;"
        return tabCreateSQL
    }
    
    
}
