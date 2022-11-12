//
//  NSToolbarSwizzler.swift
//  desktop_toolbar
//
//  Created by Tom Grushka on 11/12/22.
//

import Cocoa

class NSToolbarSwizzler {
    @objc func swizzled_allowsDisplayMode(_ mode: NSToolbar.DisplayMode) -> Bool {
        mode != .labelOnly
    }
    
    static private(set) var isSwizzled: Bool = false
    
    static func swizzleIfNeeded() {
        if isSwizzled { return }
        isSwizzled = true
        swizzle(
            klass: NSToolbar.self,
            originalSelector: Selector(("_allowsDisplayMode:")),
            swizzledSelector: #selector(swizzled_allowsDisplayMode)
        )
    }
    
    private static func swizzle(klass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        guard
            let originalMethod = class_getInstanceMethod(klass, originalSelector)
        else {
            assertionFailure("Could not get original method!")
            return
        }

        guard
            let swizzledMethod = class_getInstanceMethod(NSToolbarSwizzler.self, swizzledSelector)
        else {
            assertionFailure("Could not get swizzled method!")
            return
        }

        let didAdd = class_addMethod(klass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))

        if didAdd {
            class_replaceMethod(klass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
