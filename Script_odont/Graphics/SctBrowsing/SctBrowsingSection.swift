//
//  SctBrowsingSection.swift
//  Script_odont
//
//  Created by Régis Iozzino on 15/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctBrowsingSection: UIView
{
    fileprivate static let titleWidthRatio_: CGFloat = 0.9
    fileprivate static let topSpace_: CGFloat = 5.0
    fileprivate static let bottomSpace_: CGFloat = 10.0
    fileprivate static let spacing_: CGFloat = 5.0
    
    fileprivate var verticalStackView_ = UIStackView()
    fileprivate var titleStackView_ = UIStackView()
    fileprivate var seeAllButton_ = UIButton(type: .system)
    fileprivate var titleLabel_ = UILabel()
    fileprivate var descriptionLabel_ = UILabel()
    
    var sectionTitle: String {
        get {
            return titleLabel_.text ?? ""
        }
        set {
            titleLabel_.text = newValue
        }
    }
    
    var sectionDescription: String? {
        get {
            if descriptionLabel_.isHidden
            {
                return nil
            }
            return descriptionLabel_.text
        }
        set {
            if newValue == nil
            {
                descriptionLabel_.isHidden = true
            }
            else
            {
                descriptionLabel_.isHidden = false
                descriptionLabel_.text = newValue!
                
                descriptionLabel_.frame.size.width = UIScreen.main.bounds.width
                descriptionLabel_.frame.size.height = CGFloat(MAXFLOAT)
                descriptionLabel_.sizeToFit()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setupViews_()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupViews_()
    }
    
    var preferredHeight: CGFloat {
        
        if descriptionLabel_.isHidden
        {
            return SctBrowsingSection.topSpace_ + preferredTitleHeight_ + SctBrowsingSection.bottomSpace_
        }
        
        return SctBrowsingSection.topSpace_
            + preferredTitleHeight_
            + SctBrowsingSection.spacing_
            + preferredDescriptionHeight_
            + SctBrowsingSection.bottomSpace_
    }
    
    fileprivate var preferredTitleHeight_: CGFloat {
        return titleLabel_.sizeThatFits(UIScreen.main.bounds.size).height + 2 * SctBrowsingSection.spacing_
    }
    
    fileprivate var preferredDescriptionHeight_: CGFloat {
        return descriptionLabel_.sizeThatFits(UIScreen.main.bounds.size).height
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    func registerForSeeAllAction(target: Any?, selector: Selector, buttonTag: Int)
    {
        seeAllButton_.isHidden = false
        seeAllButton_.tag = buttonTag
        seeAllButton_.addTarget(target, action: selector, for: .touchUpInside)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setupViews_()
    {
        setupVerticalStackView_()
        setupTitleStackView_()
        setupTitleLabel_()
        setupSeeAllButton_()
        setupDescriptionLabel_()
        
        backgroundColor = UIColor.white
    }
    
    fileprivate func setupVerticalStackView_()
    {
        // view hierarchy
        self.addSubview(verticalStackView_)
        
        verticalStackView_.translatesAutoresizingMaskIntoConstraints = false
        
        // properties
        verticalStackView_.alignment = .center
        verticalStackView_.axis = .vertical
        verticalStackView_.distribution = .fillProportionally
        verticalStackView_.spacing = SctBrowsingSection.spacing_
        
        // arranged subviews
        verticalStackView_.addArrangedSubview(titleStackView_)
        verticalStackView_.addArrangedSubview(descriptionLabel_)
        
        // constraints
        let top = NSLayoutConstraint(item: verticalStackView_, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: SctBrowsingSection.topSpace_)
        let right = NSLayoutConstraint(item: verticalStackView_, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        let left = NSLayoutConstraint(item: verticalStackView_, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: verticalStackView_, attribute: .bottom, multiplier: 1.0, constant: SctBrowsingSection.bottomSpace_)
        
        self.addConstraints([top, right, left, bottom])
    }
    
    fileprivate func setupTitleStackView_()
    {
        titleStackView_.translatesAutoresizingMaskIntoConstraints = false
        
        // properties
        titleStackView_.alignment = .center
        titleStackView_.axis = .horizontal
        titleStackView_.distribution = .fillProportionally
        titleStackView_.spacing = SctBrowsingSection.spacing_
        
        // arranged subviews
        titleStackView_.addArrangedSubview(titleLabel_)
        titleStackView_.addArrangedSubview(seeAllButton_)
        
        // constraints
        let top = NSLayoutConstraint(item: titleStackView_, attribute: .top, relatedBy: .equal, toItem: verticalStackView_, attribute: .top, multiplier: 1.0, constant: 0.0)
        let left = NSLayoutConstraint(item: titleStackView_, attribute: .left, relatedBy: .equal, toItem: verticalStackView_, attribute: .left, multiplier: 1.0, constant: 10.0)
        
        verticalStackView_.addConstraints([top, left])
    }
    
    fileprivate func setupTitleLabel_()
    {
        let width = NSLayoutConstraint(item: titleLabel_, attribute: .width, relatedBy: .equal, toItem: seeAllButton_, attribute: .width, multiplier: SctBrowsingSection.titleWidthRatio_, constant: 0.0)
        titleStackView_.addConstraints([width])
        
        titleLabel_.textColor = Appearance.Color.default
        
        let font = UIFont.systemFont(ofSize: UIFont.labelFontSize * 1.2, weight: .bold)
        titleLabel_.font = font
        
        let top = NSLayoutConstraint(item: titleLabel_, attribute: .top, relatedBy: .equal, toItem: titleStackView_, attribute: .top, multiplier: 1.0, constant: 0.0)
        titleStackView_.addConstraint(top)
    }
    
    fileprivate func setupSeeAllButton_()
    {
        seeAllButton_.isHidden = true
        seeAllButton_.setTitle("SctBrowsingSection.SeeAll".localized, for: .normal)
    }
    
    fileprivate func setupDescriptionLabel_()
    {
        descriptionLabel_.isHidden = true
        descriptionLabel_.text = sectionDescription
        
        let leading = NSLayoutConstraint(item: descriptionLabel_, attribute: .leading, relatedBy: .equal, toItem: titleStackView_, attribute: .leading, multiplier: 1.0, constant: 0.0)
        verticalStackView_.addConstraint(leading)
        
        descriptionLabel_.preferredMaxLayoutWidth = UIScreen.main.bounds.width
        descriptionLabel_.textColor = UIColor.gray
        descriptionLabel_.numberOfLines = 0
        descriptionLabel_.lineBreakMode = .byWordWrapping
    }
}
