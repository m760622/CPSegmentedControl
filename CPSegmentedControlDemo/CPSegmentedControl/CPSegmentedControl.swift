//
//  CPSegmentedControl.swift
//  hnup
//
//  Created by CP3 on 17/4/5.
//  Copyright © 2017年 DataYP. All rights reserved.
//

import UIKit

public final class CPSegmentedControl: UIControl {
    public var segmentSelected: ((Int) -> Void)?
    
    fileprivate var _selectedSegmentIndex: Int = 0
    public var selectedSegmentIndex: Int {
        get {
           return _selectedSegmentIndex
        }
        set(index) {
            selectingSegment(atIndex: index)
        }
    }
    
    public var textColor: UIColor = UIColor.black {
        didSet {
            buttons.forEach { button in
                button.setTitleColor(textColor, for: UIControlState())
            }
        }
    }
    public var highlightedTextColor = UIColor(red: 0, green: 122/255.0, blue: 1.0, alpha: 1.0) {
        didSet {
            buttons.forEach { button in
                button.setTitleColor(highlightedTextColor, for: .selected)
                
                
            }
        }
    }
    public var textFont = UIFont.systemFont(ofSize: 16) {
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
    
    fileprivate let kButtonBaseTag = 100
    fileprivate let items: [String]
    fileprivate var buttons = [UIButton]()
    fileprivate let line = UIView()
    public init(items: [String]) {
        self.items = items
        super.init(frame: CGRect.zero)
        
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
        for (idx, button) in buttons.enumerated() {
            button.frame = CGRect(x: CGFloat(idx) * (buttonWidth + titleGap), y: 0, width: buttonWidth, height: height)
        }
        
        let selectedButton = buttons[_selectedSegmentIndex]
        line.frame = CGRect(x: 0, y: height - lineHeight - lineOffsetY, width: lineWidth > 0 ? lineWidth : buttonWidth, height: lineHeight)
        var center = line.center
        center.x = selectedButton.center.x
        line.center = center
    }
    
    override public var intrinsicContentSize : CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 44)
    }
}

public extension CPSegmentedControl {
    public func selectingSegment(atIndex index: Int, animated: Bool = false) {
        guard index != _selectedSegmentIndex else { return }
        
        _selectedSegmentIndex = index
        
        buttons.forEach { $0.isSelected = false }
        let selectedButton = buttons[_selectedSegmentIndex]
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
        guard idx != _selectedSegmentIndex else { return }
        
        selectingSegment(atIndex: idx, animated: true)
        segmentSelected?(_selectedSegmentIndex)
        self.sendActions(for: UIControlEvents.valueChanged)
    }
}
