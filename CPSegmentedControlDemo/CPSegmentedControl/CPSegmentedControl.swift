//
//  CPSegmentedControl.swift
//  hnup
//
//  Created by CP3 on 17/4/5.
//  Copyright © 2017年 DataYP. All rights reserved.
//

import UIKit

public final class CPSegmentedControl: UIControl {
    public var segmentSelected: ((segment: Int) -> Void)?
    
    private var _selectedSegmentIndex: Int = 0
    public var selectedSegmentIndex: Int {
        get {
           return _selectedSegmentIndex
        }
        set(index) {
            selectingSegment(atIndex: index)
        }
    }
    
    public var textColor: UIColor = UIColor.blackColor() {
        didSet {
            buttons.forEach { button in
                button.setTitleColor(textColor, forState: .Normal)
            }
        }
    }
    public var highlightedTextColor = UIColor(red: 0, green: 122/255.0, blue: 1.0, alpha: 1.0) {
        didSet {
            buttons.forEach { button in
                button.setTitleColor(highlightedTextColor, forState: .Selected)
                
                
            }
        }
    }
    public var textFont = UIFont.systemFontOfSize(16) {
        didSet {
            buttons.forEach { button in
                button.titleLabel?.font = textFont
            }
        }
    }
    public var lineColor = UIColor(red: 0, green: 122/255.0, blue: 1.0, alpha: 1.0) {
        didSet {
            line.backgroundColor = lineColor
        }
    }
    
    public var lineWidth: CGFloat = 0.0 {
        didSet {
            layoutIfNeeded()
        }
    }
    public var lineHeight: CGFloat = 2.0 {
        didSet {
            layoutIfNeeded()
        }
    }
    public var lineOffsetY: CGFloat = 0.0 {
        didSet {
            layoutIfNeeded()
        }
    }
    public var titleGap: CGFloat = 0.0 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    private let kButtonBaseTag = 100
    private let items: [String]
    private var buttons = [UIButton]()
    private let line = UIView()
    public init(items: [String]) {
        self.items = items
        super.init(frame: CGRect.zero)
        
        for (idx, title) in items.enumerate() {
            let button = UIButton()
            button.tag = kButtonBaseTag + idx
            button.setTitle(title, forState: .Normal)
            button.titleLabel?.font = textFont
            button.setTitleColor(textColor, forState: .Normal)
            button.setTitleColor(highlightedTextColor, forState: .Selected)
            button.addTarget(self, action: #selector(tap(_:)), forControlEvents: .TouchUpInside)
            buttons.append(button)
            addSubview(button)
        }
        buttons.first?.selected = true
        
        line.backgroundColor = lineColor
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
        let buttonWidth = (width - (count - 1) * titleGap) / count
        for (idx, button) in buttons.enumerate() {
            button.frame = CGRect(x: CGFloat(idx) * (buttonWidth + titleGap), y: 0, width: buttonWidth, height: height)
        }
        
        let selectedButton = buttons[_selectedSegmentIndex]
        line.frame = CGRect(x: 0, y: height - lineHeight - lineOffsetY, width: lineWidth > 0 ? lineWidth : buttonWidth, height: lineHeight)
        var center = line.center
        center.x = selectedButton.center.x
        line.center = center
    }
    
    override public func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 44)
    }
}

public extension CPSegmentedControl {
    public func selectingSegment(atIndex index: Int, animated: Bool = false) {
        guard index != _selectedSegmentIndex else { return }
        
        _selectedSegmentIndex = index
        
        buttons.forEach { $0.selected = false }
        let selectedButton = buttons[_selectedSegmentIndex]
        selectedButton.selected = true

        var center = line.center
        center.x = selectedButton.center.x
        if animated {
            UIView.animateWithDuration(0.3, animations: {
                self.line.center = center
            })
        } else {
           self.line.center = center
        }
    }
}

private extension CPSegmentedControl {
    @objc func tap(button: UIButton) {
        let idx = button.tag - kButtonBaseTag
        guard idx != _selectedSegmentIndex else { return }
        
        selectingSegment(atIndex: idx, animated: true)
        segmentSelected?(segment: _selectedSegmentIndex)
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
}
