//
//  PageContentView.swift
//  PageView
//
//  Created by 51desk on 2017/11/28.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit

//MARK: /**PageContentViewDelegate**/
@objc protocol PageContentViewDelegate : class {
    @objc optional func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
    @objc optional func pageContentView(_ contentView: PageContentView, currentIndex: Int)
}

class PageContentView: UIView {

    var childVcs = [AnyObject]()
    var titleAry = [String]()
    var currentIndex: Int = 0
    var childVcNames: [String]! {
        didSet {
            childVcs.removeAll()
            for _ in 0 ..< childVcNames.count {
                childVcs.append(NSNull.init())
            }
            collectionView.reloadData()
        }
    }
    fileprivate weak var parentViewController : UIViewController?
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var isForbidScrollDelegate : Bool = false//是否点击事件
    weak var delegate : PageContentViewDelegate?
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        // 创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = true
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ContentCellID")
        
        return collectionView
    }()

    //MARK: /**自定义构造函数**/
    init(frame: CGRect, parentViewController: UIViewController?) {
        super.init(frame: frame)
        self.parentViewController = parentViewController
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageContentView {
    
    //MARK: /**设置UI**/
    fileprivate func setupUI() {
        for childVc in childVcs {
            parentViewController?.addChildViewController(childVc as! UIViewController)
        }
        addSubview(collectionView)
        collectionView.frame = bounds
    }
    
    //MARK: /**设置当前页**/
    func setCurrentIndex(_ currentIndex : Int) {
        self.currentIndex = currentIndex
        isForbidScrollDelegate = true
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
    
}

//MARK: /**UICollectionViewDataSource**/
extension PageContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         return self.childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCellID", for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        var childVc = childVcs[(indexPath as NSIndexPath).item]
        if childVc as! NSObject == NSNull.init() {
            let crl = NSClassFromString("PageView." + childVcNames[(indexPath as NSIndexPath).item])! as? UIViewController.Type
            childVc = (crl?.init())!
            childVcs[(indexPath as NSIndexPath).item] = childVc
        }
        (childVc as! UIViewController).title = titleAry[(indexPath as NSIndexPath).item]
        (childVc as! UIViewController).view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
    
}

//MARK: /**UICollectionViewDelegate**/
extension PageContentView: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //关闭禁止代理方法
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
        print("beginDragging")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //判断是否是点击事件
        if isForbidScrollDelegate { return }
        //定义需要获取的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        //判断是左滑动还是右滑动
        let currentOffsetX : CGFloat = scrollView.contentOffset.x
        let scrollViewW = scrollView.frame.width
        if currentOffsetX <= 0 || Int(currentOffsetX / scrollViewW) >= childVcs.count - 1 {
            //当偏移量小于0或者大于scrollView的contentsize.width
            return
        }
        if currentOffsetX > startOffsetX { //左滑动
            //计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            //计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            //计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            //如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1.0
                targetIndex = sourceIndex
            }
        } else { //右滑动
            //计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            //计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            //计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            //如果完全划过去
            if startOffsetX - currentOffsetX == scrollViewW {
                progress = 1.0
                sourceIndex = targetIndex
            }
        }
        print("targetIndex = %d, sourceIndex = %d",targetIndex, sourceIndex)
        //将progress/sourceIndex/targetIndex传递给titleView
        delegate?.pageContentView?(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isForbidScrollDelegate { return }
        delegate?.pageContentView?(self, currentIndex: (Int(scrollView.contentOffset.x / PageScreenW)))
    }
    
}
