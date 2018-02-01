//
//  CPSegmentedControl.swift
//  hnup
//
//  Created by CP3 on 17/4/5.
//  Copyright © 2017年 DataYP. All rights reserved.
//

import UIKit

public final class CPSegmentedControl: UIControl {
    public static var textColor: UIColor = UIColor.black
    public static var highlightedTextColor: UIColor = UIColor(red: 0, green: 122/255.0, blue: 1.0, alpha: 1.0)
    public static var lineColor: UIColor  = UIColor(red: 0, green: 122/255.0, blue: 1.0, alpha: 1.0)
    public static var seperatorColor: UIColor = UIColor.clear
    public static var textFont: UIFont = UIFont.systemFont(ofSize: 16)
    public static var lineWidth: CGFloat = 50.0
    public static var lineHeight: CGFloat = 2.0
    public static var lineBottomInset: CGFloat = 0.0
    public static var titleGap: CGFloat = 0.0
    public static var insets: UIEdgeInsets = UIEdgeInsets.zero
    
    public var segmentSelected: ((Int) -> Void)?
    
    private var _segmentIndex: Int = 0
    public var segmentIndex: Int {
        get {
           return _segmentIndex
        }
        set(index) {
            selectingSegment(atIndex: index)
        }
    }
    
    public var textColor: UIColor = CPSegmentedControl.textColor {
        didSet {
            buttons.forEach { button in
                button.setTitleColor(textColor, for: UIControlState())
            }
        }
    }
    
    public var highlightedTextColor: UIColor = CPSegmentedControl.highlightedTextColor {
        didSet {
            buttons.forEach { button in
                button.setTitleColor(highlightedTextColor, for: .selected)
            }
        }
    }
    
    public var lineColor: UIColor = CPSegmentedControl.lineColor {
        didSet {
            line.backgroundColor = lineColor
        }
    }
    
    public var seperatorColor: UIColor = CPSegmentedControl.seperatorColor {
        didSet {
            seperator.backgroundColor = seperatorColor
        }
    }
    
    public var textFont: UIFont = CPSegmentedControl.textFont {
        didSet {
            buttons.forEach { button in
                button.titleLabel?.font = textFont
            }
        }
    }
    
    public var lineWidth: CGFloat = CPSegmentedControl.lineWidth {
        didSet {
            layoutIfNeeded()
        }
    }
    
    public var lineHeight: CGFloat = CPSegmentedControl.lineHeight {
        didSet {
            layoutIfNeeded()
        }
    }
    
    // line离底部的space
    public var lineBottomInset: CGFloat = CPSegmentedControl.lineBottomInset {
        didSet {
            layoutIfNeeded()
        }
    }
    
    // title之间的space
    public var titleGap: CGFloat = CPSegmentedControl.titleGap {
        didSet {
            layoutIfNeeded()
        }
    }
    
    public var insets: UIEdgeInsets = CPSegmentedControl.insets {
        didSet {
            layoutIfNeeded()
        }
    }
    
    fileprivate let kButtonBaseTag = 100
    fileprivate let items: [String]
    fileprivate var buttons = [UIButton]()
    fileprivate let line = UIView()
    fileprivate let seperator = UIView()
    
    public init(items: [String]) {
        self.items = items
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        
        for (idx, title) in items.enumerated() {
            let button = UIButton()
            button.tag = kButtonBaseTag + idx
            button.setTitle(title, for: UIControlState())
            button.titleLabel?.font = textFont
            button.setTitleColor(textColor, for: UIControlState())
            button.setTitleColor(highlightedTextColor, for: .selected)
            button.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
            buttons.append(button)
            addSubview(button)
        }
        buttons.first?.isSelected = true
        line.backgroundColor = lineColor
        addSubview(seperator)
        addSubview(line)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = frame.width
        let height = frame.height
        let count = CGFloat(buttons.count)
        let buttonWidth = (width - (count - 1) * titleGap - insets.left - insets.right) / count
        for (idx, button) in buttons.enumerated() {
            button.frame = CGRect(x: insets.left + CGFloat(idx) * (buttonWidth + titleGap), y: 0, width: buttonWidth, height: height)
        }
        
        let selectedButton = buttons[_segmentIndex]
        line.frame = CGRect(x: 0, y: height - lineHeight - lineBottomInset, width: lineWidth > 0 ? lineWidth : buttonWidth, height: lineHeight)
        var center = line.center
        center.x = selectedButton.center.x
        line.center = center
        seperator.frame = CGRect(x: 0, y: height - lineHeight - lineBottomInset, width: width, height: lineHeight)
    }
    
    override public var intrinsicContentSize : CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 44)
    }
}

public extension CPSegmentedControl {
    public func selectingSegment(atIndex index: Int, animated: Bool = false) {
        guard index != _segmentIndex else { return }
        
        _segmentIndex = index
        
        buttons.forEach { $0.isSelected = false }
        let selectedButton = buttons[_segmentIndex]
        selectedButton.isSelected = true

        var center = line.center
        center.x = selectedButton.center.x
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.line.center = center
            })
        } else {
           self.line.center = center
        }
    }
}

private extension CPSegmentedControl {
    @objc func tap(_ button: UIButton) {
        let idx = button.tag - kButtonBaseTag
        guard idx != _segmentIndex else { return }
        
        selectingSegment(atIndex: idx, animated: true)
        segmentSelected?(_segmentIndex)
        self.sendActions(for: UIControlEvents.valueChanged)
    }
}
