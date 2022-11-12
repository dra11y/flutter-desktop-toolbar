//
//  FlutterToolbarItem.swift
//  desktop_toolbar
//
//  Created by Tom Grushka on 11/11/22.
//

import Cocoa

protocol AnyFlutterToolbarItem: NSToolbarItem {
    var displayMode: NSToolbar.DisplayMode { get set }
}

class FlutterToolbarItem: NSToolbarItem, AnyFlutterToolbarItem {
    let item: ToolbarItem
    var displayMode: NSToolbar.DisplayMode

    init(
        item: ToolbarItem,
        displayMode: NSToolbar.DisplayMode,
        target: AnyObject?,
        action: Selector)
    {
        self.item = item
        self.displayMode = displayMode
        super.init(itemIdentifier: item.identifier())
        self.target = target
        self.action = action
        self.label = item.title
        self.isBordered = true
        self.image = item.iconData.render()
        if let menuItem = menuFormRepresentation {
            menuItem.image = image
            menuItem.target = target
            menuItem.action = action
        }
        if #available(macOS 13.0, *) {
            possibleLabels = [item.title]
        }
    }
}

class FlutterToolbarSpace: NSToolbarItem, AnyFlutterToolbarItem {
    var displayMode: NSToolbar.DisplayMode = .default

    init() {
        super.init(itemIdentifier: .space)
    }
}

class FlutterToolbarFlexibleSpace: NSToolbarItem, AnyFlutterToolbarItem {
    var displayMode: NSToolbar.DisplayMode = .default

    init() {
        super.init(itemIdentifier: .flexibleSpace)
    }
}
