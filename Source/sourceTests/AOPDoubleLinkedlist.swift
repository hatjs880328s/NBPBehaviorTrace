//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPDoubleLinkedlist.swift
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


import XCTest
@testable import source

class AOPDoubleLinkedlist: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitLList() {
        let list = AOPMemCacheList()
        
        XCTAssert(list.itemCount == 2, "初始化失败")
    }
    
    func testAddOneitem() {
        let list = AOPMemCacheList()
        let itemContent = AOPMemCacheModel(name: "第一个")
        let item = AOPLinkListItem(content: itemContent)
        list.addOneItemALL(with: item)
        
        XCTAssert(list.itemCount == 3, "添加失败，个数不对")
        XCTAssert(list.headerItem.afterItem.content.realName == "第一个", "添加个数对，但是业务数据不对")
    }
    
    func testdeleateLastItem() {
        let list = AOPMemCacheList()
        let itemContent = AOPMemCacheModel(name: "第一个")
        let item = AOPLinkListItem(content: itemContent)
        list.addOneItemALL(with: item)
        
        list.deleateLastOneItemALL()
        if list.itemCount >= list.itemMaxCount {
            XCTAssert(list.itemCount == 2, "没删除")
        }else{
            XCTAssert(list.itemCount == 3, "没删除")
        }
        XCTAssert(list.footerItem.content.realName == "footer", "删除最后一个的业务不对，个数对")
    }
    
    func testdeleateOneItem() {
        let list = AOPMemCacheList()
        let itemContent = AOPMemCacheModel(name: "第一个")
        let item = AOPLinkListItem(content: itemContent)
        list.addOneItemALL(with: item)
        
        let getItem = list.isExistTheItemALL(compare: item, beCompared: list.headerItem)
        list.deleateOneItemALL(with: getItem!)
        
        XCTAssert(list.itemCount == 2, "没删除")
        XCTAssert(list.footerItem.content.realName == "footer", "删除最后一个的业务不对，个数对")
    }
    
    func testGetallItems() {
        let list = AOPMemCacheList()
        for _ in 0 ... 9 {
            let itemContent = AOPMemCacheModel(name: "第一个")
            let item = AOPLinkListItem(content: itemContent)
            list.addOneItemALL(with: item)
        }
        
        let result  = list.getALLItemsAndDeleateALL()
        for i in result {
            DEBUGPrintLog(i.content.realName)
        }
        XCTAssert(result.count == 10, "个数对了")
        XCTAssert(list.itemCount == 2, "原来的链表数据也对")
    }
    
    func testManagerGetall() {
//        let manager = AOPMemListManager.getInstance()
//        for _ in 0 ... 9 {
//            manager.addOneEvent(event: TBEvent())
//        }
//        let result = manager.getAllitemInarrAndDeleateAllItems()
//        XCTAssert(result.count == 10, "个数对了")
    }
    
}
