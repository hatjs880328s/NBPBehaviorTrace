//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// ExtensionTest.swift
//
// Created by    Noah Shan on 2018/3/19
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


import XCTest
@testable import source

class ExtensionTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStrExt() {
        let strLong: NSString = "abcdefghijklmn"
        let arr = strLong.subStrEachParameterCharacter(countPara: 3)
        
        XCTAssert(arr[0] == "abc", "大于1的数据正确")
        
        XCTAssert(arr.last == "mn", "不能整除不正确")
        
        let arr2 = strLong.subStrEachParameterCharacter(countPara: 1)
        
        XCTAssert(arr2[2] == "c", "=1不对")
    }
    
}
