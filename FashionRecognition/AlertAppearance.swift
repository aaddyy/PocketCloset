import Foundation
import UIKit

extension UIAlertController {
    
    class Appearance {
        private static let sharedInstance = Appearance()
        var tintColor: UIColor?
        private init() {
        }
        
        class func appearance() -> Appearance {
            return sharedInstance
        }
    }
    
    class func appearance() -> Appearance {
        return Appearance.appearance()
    }
    
    public override class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            let originalSelector = Selector("viewWillLayoutSubviews")
            let swizzledSelector = Selector("swizzle_viewWillLayoutSubviews")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    }
    
    func swizzle_viewWillLayoutSubviews() {
        swizzle_viewWillLayoutSubviews()
        self.view.tintColor = self.dynamicType.appearance().tintColor
    }
}