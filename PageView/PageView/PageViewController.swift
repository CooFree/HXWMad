//
//  PageViewController.swift
//  PageView
//
//  Created by 51desk on 2017/11/28.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit

//MARK: /**常量**/
let PageTitleViewH: CGFloat = 44
let PageSliderItemH: CGFloat = 44
let PageStatusBarH : CGFloat = 20
let PageNavigationBarH : CGFloat = 44
let PageMaxSliderH: CGFloat = 300
let PageScreenW = UIScreen.main.bounds.size.width
let PageScreenH = UIScreen.main.bounds.size.height

class PageViewController: UIViewController {

    var titleAry: [String]! {
        didSet {
            pageTitleView.titleAry = titleAry
            pageContentView.titleAry = titleAry
        }
    }
    var crlNameAry: [String]! {
        didSet {
            pageContentView.childVcNames = crlNameAry
        }
    }
    fileprivate lazy var pageTitleView: PageTitleView = {[weak self] in
        let titleView = PageTitleView()
        titleView.delegate = self
        titleView.frame = CGRect(x: 0, y: PageStatusBarH + PageNavigationBarH, width: PageScreenW, height: PageTitleViewH)
        return titleView
        }()
    fileprivate lazy var pageContentView: PageContentView = {[weak self] in
        let contentFrame = CGRect(x: 0, y: PageStatusBarH + PageNavigationBarH + PageTitleViewH, width: PageScreenW, height: PageScreenH - PageStatusBarH - PageNavigationBarH - PageTitleViewH)
        let pageContentView = PageContentView(frame: contentFrame, parentViewController: self)
        pageContentView.delegate = self
        return pageContentView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

extension PageViewController {
    
    //MARK: /**设置UI**/
    fileprivate func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(pageContentView)
        view.addSubview(pageTitleView)
    }

}

//MARK: /**PageTitleViewDelegate**/
extension PageViewController : PageTitleViewDelegate {
    
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(index)
    }
    
    func tapActionBtn(_ isPop: Bool, titleViewHeight: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.pageTitleView.frame = CGRect(x: 0, y: PageStatusBarH + PageNavigationBarH, width: PageScreenW, height: titleViewHeight)
            if !isPop {
                self.pageTitleView.actionBtn.transform = CGAffineTransform.identity
                self.pageTitleView.scrollView.isHidden = true
            }
            else
            {
                self.pageTitleView.actionBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                self.pageTitleView.sliderView.isHidden = true
            }
        }) { (isFinished) in
            self.pageTitleView.refresh()
        }
    }
    
}

//MARK: /**PageContentViewDelegate**/
extension PageViewController : PageContentViewDelegate {
    
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func pageContentView(_ contentView: PageContentView, currentIndex: Int) {
        pageTitleView.setSelectTitle(currentIndex)
    }
    
}
