//
//  BaseNibView.swift
//  BaseUI
//
//  Created by Daniel Le on 18/11/2022.
//

import UIKit

open class BaseNibView: UIView {
    var contentView: UIView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        contentView = nibView
        
        contentView.backgroundColor = backgroundColor
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(contentView)
        contentView.backgroundColor = .clear
        setupViews()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    open func setupViews() {}
}
