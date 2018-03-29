//
//  ProgressView.swift
//  FakeApp
//
//  Created by Pedro Henrique on 16/09/17.
//  Copyright © 2017 IESB. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    
    @IBOutlet weak var effect: UIVisualEffectView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    
    private var canShow: Bool {
        get {
            return reachability?.currentReachabilityStatus != .notReachable
        }
    }
    
    private lazy var reachability: Reachability? = {
        return Reachability.networkReachabilityForInternetConnection()
    }()
    
    private func commonInit() {
        isOpaque = false
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = UIColor.clear
        layer.allowsGroupOpacity = false
    }
    
    private func initReachability() {
        if let r = reachability {
            if r.startNotifier() {
                NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: ReachabilityDidChangeNotificationName, object: nil)
            }
        }
    }
    
    @objc private func reachabilityDidChange(_ notification: Notification) {
        reachability =  notification.object as? Reachability
        if let status = reachability?.currentReachabilityStatus {
            print("Reachability did change to status: \(status)")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func prepareOutlets() {
        effect.layer.cornerRadius = 20
        effect.layer.masksToBounds = true
        
        //label.font = UIFont.vertrina(ofSize: 18)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    public class func show(addedToView view: UIView? = nil) {
        DispatchQueue.main.async {
            if let v = view {
                let nib = UINib.init(nibName: "ProgressView", bundle: Bundle.main)
                let hud = nib.instantiate(withOwner: nil, options: nil)[0] as! ProgressView
                if hud.canShow {
                    hud.frame = v.frame
                    hud.prepareOutlets()
                    
                    hud.activityIndicator.startAnimating()
                    hud.center = v.center
                    v.addSubview(hud)
                }
            }else {
                show(addedToView: UIApplication.shared.keyWindow)
            }
        }
    }
    
    public class func hide(fromView view: UIView? =  nil) {
        DispatchQueue.main.async {
            if view == nil {
                return hide(fromView: UIApplication.shared.keyWindow)
            }
            if let hud = progressView(forView: view) {
                hud.activityIndicator.stopAnimating()
                hud.removeFromSuperview()
            }
        }
    }
    
    private class func progressView(forView view: UIView?) -> ProgressView? {
        if let subviews = view?.subviews.reversed() {
            for subview in subviews {
                if subview.isKind(of: ProgressView.self) {
                    let hud = subview as! ProgressView
                    return hud
                }
            }
        }
        return nil
    }
    

}
