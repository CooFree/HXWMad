//
//  PageTitleView.swift
//  PageView
//
//  Created by 51desk on 2017/11/28.
//  Copyright © 2017年 hxw. All rights reserved.
//
import UIKit

//MARK: /**PageTitleViewDelegate**/
@objc protocol PageTitleViewDelegate : class {
    @objc optional func pageTitleView(_ titleView: PageTitleView, selectedIndex index : Int)
    @objc optional func tapActionBtn(_ isPop: Bool, titleViewHeight: CGFloat)
}

//MARK: /**常量**/
private let sliderLineHeight: CGFloat = 2//滑块高度
private let bottomLineHeight: CGFloat = 0.5//底部线高
private let titleLblGap: CGFloat = 10//每一个标题文字左右和Label边距的距离
private let normalColor: (CGFloat, CGFloat, CGFloat) = (0, 0, 0)
private let selectColor: (CGFloat, CGFloat, CGFloat) = (255, 0, 0)
private let actionBtnWidth: CGFloat = 50//右侧操作按钮宽度
private let tailGap: CGFloat = 50//选中的标题尾部和操作按钮之间的距离

class PageTitleView: UIView {
    
    weak var delegate: PageTitleViewDelegate?
    fileprivate var currentIndex: Int = 0
    fileprivate var isPop: Bool = false
    var widthAry: [NSNumber]! = []
    var titleAry: [String]! {
        didSet {
            setUpTitleLbl()
        }
    }
    fileprivate lazy var  titleLabels: [UILabel] = [UILabel]()
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        return bottomLine
    }()
    fileprivate lazy var sliderLine: UIView = {
        let sliderLine = UIView()
        sliderLine.backgroundColor = UIColor (red: selectColor.0, green: selectColor.1, blue: selectColor.2, alpha: 1)
        return sliderLine
    }()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = true
        return scrollView
    }()
    lazy var actionBtn: UIButton = { [unowned self] in
        let actionBtn = UIButton()
        actionBtn.setImage(UIImage.init(named: "arrow"), for: .normal)
        actionBtn.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
        return actionBtn
    }()
    lazy var sliderView: PageSliderView = {
        let sliderView = PageSliderView()
        sliderView.isHidden = true
        sliderView.delegate = self
        addSubview(sliderView)
        return sliderView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        scrollView.addSubview(sliderLine)
        addSubview(scrollView)
        addSubview(bottomLine)
        addSubview(actionBtn)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: /**右侧操作按钮点击事件**/
    @objc func actionTap() {
        delegate?.tapActionBtn?(isPop, titleViewHeight: (!isPop ? CalcSliderHeight() + PageTitleViewH : PageTitleViewH))
        sliderView.frame = CGRect (x: 0, y: PageTitleViewH, width: PageScreenW, height: CalcSliderHeight())
    }
    
}

extension PageTitleView {
    
    //MARK: /**初始化标题栏**/
    fileprivate func setUpTitleLbl() {
        //清空原有titleLbl
        if titleLabels.count > 0 {
            for lbl in titleLabels {
                lbl.removeFromSuperview()
            }
            titleLabels.removeAll()
        }
        
        //添加新的titleLbl
        for (index, title) in titleAry.enumerated() {
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textAlignment = .center
            scrollView.addSubview(label)
            titleLabels.append(label)
            label.isUserInteractionEnabled = true
            label.backgroundColor = .clear
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            widthAry.append(NSNumber.init(value: Float(CalcTextWidth(textStr: title, font: UIFont.systemFont(ofSize: 14), height: PageTitleViewH)) + 40))
        }
        
        actionBtn.frame = CGRect (x: PageScreenW - actionBtnWidth, y: 0, width: actionBtnWidth, height: PageTitleViewH)
        scrollView.frame = CGRect (x: 0, y: 0, width: PageScreenW - actionBtnWidth, height: PageTitleViewH)
        var totalLength: CGFloat = 0
        for (index, lbl) in titleLabels.enumerated() {
            let lblWidth = CalcTextWidth(textStr: lbl.text!, font: lbl.font, height: PageTitleViewH) + titleLblGap*2
            lbl.frame = CGRect (x: totalLength, y: 0, width: lblWidth, height: PageTitleViewH)
            if currentIndex == index {
                lbl.textColor = UIColor (red: selectColor.0, green: selectColor.1, blue: selectColor.2, alpha: 1)
                sliderLine.frame = CGRect (x: totalLength, y: PageTitleViewH - sliderLineHeight, width: lblWidth, height: sliderLineHeight)
            }
            else
            {
                lbl.textColor = UIColor (red: normalColor.0, green: normalColor.1, blue: normalColor.2, alpha: 1)
            }
            totalLength += lblWidth
        }
        scrollView.contentSize = CGSize (width: totalLength, height: PageTitleViewH)
        bottomLine.frame = CGRect (x: 0, y: PageTitleViewH - bottomLineHeight, width: PageScreenW, height: bottomLineHeight)
    }
    
    //MARK: /**监听Label的点击事件**/
    @objc fileprivate func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
        guard let currentLabel = tapGes.view as? UILabel else  { return }
        setSelectTitle(currentLabel.tag)
    }

    //MARK: /**设置选中标题**/
    func setSelectTitle(_ index: NSInteger) {
        if index == currentIndex { return }
        let currentLabel = titleLabels[index]
        // 获取之前的Label
        let oldLabel = titleLabels[currentIndex]
        // 切换文字的颜色
        currentLabel.textColor = UIColor (red: selectColor.0, green: selectColor.1, blue: selectColor.2, alpha: 1)
        oldLabel.textColor = UIColor (red: normalColor.0, green: normalColor.1, blue: normalColor.2, alpha: 1)
        currentIndex = index
        // 滚动条位置发生改变
        var newFrame = self.sliderLine.frame
        newFrame.origin.x = currentLabel.frame.origin.x
        newFrame.size.width = currentLabel.frame.size.width
        reSetTitlePosition(currentLabel, newFrame: newFrame)
        delegate?.pageTitleView?(self, selectedIndex: currentIndex)
    }
    
    //MARK: /**选中的标题滑动到操作按钮的左边**/
    func reSetTitlePosition(_ currentLabel: UILabel, newFrame: CGRect) {
        let leftGap = actionBtn.frame.minX - tailGap
        if currentLabel.frame.maxX > leftGap {
            if currentLabel.tag == titleAry.count - 1 {
                //点击最后一个
                UIView.animate(withDuration: 0.15, animations: {
                    self.sliderLine.frame = newFrame
                    self.scrollView.setContentOffset(CGPoint (x: currentLabel.frame.maxX - self.scrollView.frame.width, y: 0), animated: true)
                })
            }
            else
            {
                UIView.animate(withDuration: 0.15, animations: {
                    self.sliderLine.frame = newFrame
                    self.scrollView.setContentOffset(CGPoint (x: currentLabel.frame.maxX - leftGap, y: 0), animated: true)
                })
            }
        }
        else
        {
            UIView.animate(withDuration: 0.15, animations: {
                self.sliderLine.frame = newFrame
                self.scrollView.setContentOffset(CGPoint (x: 0, y: 0), animated: true)
            })
        }
    }
    
    //MARK: /**根据页面滑动过程切换标题**/
    func setTitleWithProgress(_ progress: CGFloat, sourceIndex: Int, targetIndex: Int)  {
        
        print("%f    ====  %d",progress, targetIndex)

        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]

        //处理颜色的渐变
        //取出变化的范围(元组类型)
        let colorDelta = (selectColor.0 - normalColor.0, selectColor.1 - normalColor.1, selectColor.2 - normalColor.2)
        //        print("源 == %@ 目标 == %@ colorDelta == %@ progress == %f",((normalColor.0 + colorDelta.0 * progress),(normalColor.1 + colorDelta.1 * progress),(normalColor.2 + colorDelta.2 * progress)),((selectColor.0 - colorDelta.0 * progress),(selectColor.1 - colorDelta.1 * progress),(selectColor.2 - colorDelta.2 * progress)),colorDelta,progress)
        sourceLabel.textColor = UIColor (red: selectColor.0 - colorDelta.0 * progress, green: selectColor.1 - colorDelta.1 * progress, blue: selectColor.2 - colorDelta.2 * progress, alpha: 1)
        targetLabel.textColor = UIColor (red: normalColor.0 + colorDelta.0 * progress, green: normalColor.1 + colorDelta.1 * progress, blue: normalColor.2 + colorDelta.2 * progress, alpha: 1)
        
        //处理滑块的逻辑
        var newFrame = self.sliderLine.frame
        newFrame.origin.x = sourceLabel.frame.origin.x + (targetLabel.frame.origin.x - sourceLabel.frame.origin.x) * progress
        newFrame.size.width = sourceLabel.frame.size.width + (targetLabel.frame.size.width - sourceLabel.frame.size.width) * progress
        sliderLine.frame = newFrame
    }
    
    //MARK: /**刷新sliderView**/
    func refresh() {
        if !isPop {
            self.sliderView.widthAry = self.widthAry
            self.sliderView.titleAry = self.titleAry
            self.sliderView.isHidden = false
        }
        else
        {
            self.scrollView.isHidden = false
        }
        isPop = !isPop
    }
    
    //MARK: /**计算文字宽度**/
    func CalcTextWidth(textStr: String,font: UIFont,height: CGFloat) -> CGFloat {
        let statusLabelText: String = textStr
        let size = CGSize(width: 900, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : AnyObject], context: nil).size
        return strSize.width
    }
    
    //MARK: /**计算sliderView高度**/
    func CalcSliderHeight() -> CGFloat {
        var btnX: CGFloat = 0
        var btnY: CGFloat = 0
        for (index, w) in widthAry.enumerated() {
            btnX += CGFloat(truncating: w)
            if index < widthAry.count - 1 {
                if (btnX + CGFloat(truncating: widthAry[index + 1])) > PageScreenW {
                    btnX = 0
                    btnY += PageSliderItemH
                }
            }
        }
        return ((btnY + PageSliderItemH) > PageMaxSliderH ? PageMaxSliderH : (btnY + PageSliderItemH))
    }
    
}

// MARK:PageSliderViewDelegate
extension PageTitleView : PageSliderViewDelegate {
    
    func tapSliderAt(_ index: NSInteger) {
        actionTap()
        setSelectTitle(index)
    }
    
}
