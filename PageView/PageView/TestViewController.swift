//
//  TestViewController.swift
//  PageView
//
//  Created by 51desk on 2017/11/28.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = title
        lbl.textColor = .black
        view.addSubview(lbl)
        lbl.frame = CGRect (x: 0, y: 0, width: PageScreenW, height: PageScreenH - (PageTitleViewH + PageStatusBarH + PageNavigationBarH))
    }

}
