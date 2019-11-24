//
//  iLoader.swift
//  iLoader
//
//  Created by Dhaval on 19/06/19.
//  Copyright © 2019 Monarchy Infotech. All rights reserved.
//

import UIKit

public class iLoader: UIView {
    
    //MARK: - Variables
    public static let shared = iLoader()
    
    struct SIZES {
        static let WIDTH = UIScreen.main.bounds.width
        static let HEIGHT = UIScreen.main.bounds.height
    }
    
    var view:UIView!;
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var mainActivityIndicatorView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var nslcTitleLabelLeading: NSLayoutConstraint!
    @IBOutlet var nslcTitleLabelTrailing: NSLayoutConstraint!

    fileprivate var loaderColor : UIColor = .white
    fileprivate var titleTextColor : UIColor = .white
    fileprivate var loaderContainerBGColor : UIColor = .clear
    fileprivate var title : String = ""

    public var loaderTintColor: UIColor {
        get {
            return loaderColor
        }
        set {
            loaderColor = newValue
            activityIndicator?.color = newValue
        }
    }
    
    public var loaderTitleTextColor: UIColor {
        get {
            return titleTextColor
        }
        set {
            titleTextColor = newValue
            titleLabel?.textColor = newValue
        }
    }
    
    public var loaderBackgroundColor: UIColor {
        get {
            return loaderContainerBGColor
        }
        set {
            loaderContainerBGColor = newValue
            
            let titleExist = (title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count != 0)

            if newValue != .clear || titleExist {
                containerView?.backgroundColor = newValue.withAlphaComponent(0.4)
            }
            else {
                containerView?.backgroundColor = newValue
            }
            
        }
    }
    
    public var loaderTitle: String {
        get {
            return title
        }
        set {
            title = newValue
            titleLabel?.text = newValue
        }
    }
    
    func xibSetup() {
        // Remove existing instance from any superview
//        self.removeFromSuperview()
        if view != nil {
            view.removeFromSuperview()
            view = nil
        }
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = CGRect(x: 0, y: 0, width: SIZES.WIDTH, height: SIZES.HEIGHT)
        self.frame = CGRect(x: 0, y: 0, width: SIZES.WIDTH, height: SIZES.HEIGHT)
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        setupUserPreferences()
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "iLoader", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func setupUserPreferences() {
        let titleExist = (title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count != 0)
        nslcTitleLabelLeading.constant = titleExist ? 8 : 0
        nslcTitleLabelTrailing.constant = titleExist ? 10 : 10

        activityIndicator.color = loaderTintColor
        if loaderContainerBGColor != .clear || titleExist {
            containerView.backgroundColor = loaderContainerBGColor.withAlphaComponent(0.4)
        }
        else {
            containerView.backgroundColor = loaderContainerBGColor
        }
        
        titleLabel.text = loaderTitle
        titleLabel.textColor = titleTextColor

    }
    
    public func show() {
        // Setup Loader
        self.xibSetup()
        
        let window = UIApplication.shared.windows.first //UIApplication.shared.keyWindow
        window?.addSubview(self)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
    }
    
    // MARK: Below method is used to show Progress for a particuler time interval
    public func showForTimeInterval(timeInterval:TimeInterval) {
        show()
        self.perform(#selector(hide), with: nil, afterDelay: timeInterval)
    }
    
    
    @objc public func hide() {
        DispatchQueue.main.async(execute: { () -> Void in
            // Set navigationbar background color back
            self.activityIndicator.stopAnimating()
            self.view.removeFromSuperview()
            self.removeFromSuperview()
        })
        
    }
    
}
