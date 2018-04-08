//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// TwoViewController.swift
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

class TwoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(ThreeViewController(), animated: true)
    }
}
