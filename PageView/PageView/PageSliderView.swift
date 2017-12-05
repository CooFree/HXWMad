//
//  PageSliderView.swift
//  PageView
//
//  Created by 51desk on 2017/11/29.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit

@objc protocol PageSliderViewDelegate : class {
    @objc optional func tapSliderAt(_ index: NSInteger)
}

class PageSliderView: UIView {

    weak var delegate: PageSliderViewDelegate?
    var btnAry: [UIButton]! = []
    var oldTitleAry: [String]! = []
    var titleAry: [String]! {
        didSet {
            setUpUI()
        }
    }
    var widthAry: [NSNumber]! = []
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.scrollsToTop = false
        scrollView.bounces = true
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        if oldTitleAry == titleAry {
        }
        else
        {
            oldTitleAry = titleAry
            if btnAry!.count > 0 {
                for btn in btnAry {
                    btn .removeFromSuperview()
                }
                btnAry.removeAll()
            }
            UIView.beginAnimations( nil, context: nil)
            var btnX: CGFloat = 0
            var btnY: CGFloat = 0
            for (index, str) in titleAry.enumerated() {
                let btn = UIButton()
                btn.tag = index
                btn.setTitle(str, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                btn.setTitleColor(.black, for: .normal)
                btn.addTarget(self, action: #selector(tapbtn(_:)), for: .touchUpInside)
                btnAry?.append(btn)
                
                btn.frame = CGRect (x: btnX, y: btnY, width: CGFloat(truncating: widthAry[index]), height: PageSliderItemH)
                scrollView.addSubview(btn)
                btnX += CGFloat(truncating: widthAry[index])
                if index < widthAry.count - 1 {
                    if (btnX + CGFloat(truncating: widthAry[index + 1])) > PageScreenW {
                        btnX = 0
                        btnY += PageSliderItemH
                    }
                }
            }
            scrollView.frame = self.bounds
            scrollView.contentSize = CGSize (width: PageScreenW, height: btnY + PageSliderItemH)
            UIView.commitAnimations()
        }
    }
        
    @objc func tapbtn(_ btn: UIButton) {
        delegate?.tapSliderAt?(btn.tag)
    }
    
}
