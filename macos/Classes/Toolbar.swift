//
//  Toolbar.swift
//  desktop_toolbar
//
//  Created by Tom Grushka on 10/31/22.
//

import Cocoa

class Toolbar: NSToolbar, ToolbarHostApi, NSToolbarDelegate, NSToolbarItemValidation {
//    func setStyle(style: ToolbarStyle) -> Bool {
//        self.style = style
//        refreshToolbar()
//        return true
//    }

    private let flutterApi: ToolbarFlutterApi
    // private var style = ToolbarStyle()
    private var itemIdentifiers = [NSToolbarItem.Identifier]()
    private var toolbarItems = [AnyFlutterToolbarItem]()
    
    private func refreshToolbar() {
        for _ in 0 ..< items.count {
            removeItem(at: 0)
        }

        itemIdentifiers.enumerated().forEach { index, itemIdentifier in
            insertItem(withItemIdentifier: itemIdentifier, at: index)
        }

        validateVisibleItems()
    }
    
    func addItem(_ item: ToolbarItem) {
        addSpaceIfNeeded(item.leadingSpace)
        let toolbarItem = FlutterToolbarItem(
            item: item,
            displayMode: displayMode,
            target: self,
            action: #selector(didTapItem(_:)))
        toolbarItems.append(toolbarItem)
        itemIdentifiers.append(toolbarItem.itemIdentifier)
        addSpaceIfNeeded(item.trailingSpace)
    }

    func addSpaceIfNeeded(_ space: ToolbarSpace?) {
        guard let space = space else { return }
        let item: AnyFlutterToolbarItem
        switch space {
        case .single:
            item = FlutterToolbarSpace()
        case .flexible:
            item = FlutterToolbarFlexibleSpace()
        }
        toolbarItems.append(item)
        itemIdentifiers.append(item.itemIdentifier)
    }

    func refreshWidths() {
        for item in toolbarItems {
            item.displayMode = displayMode
        }
    }

    func addGroup(_ group: ToolbarGroup) -> Bool {
        if group.isEmpty { return false }
        addSpaceIfNeeded(group.leadingSpace)
        let toolbarGroup = FlutterToolbarGroup(
            group: group,
            displayMode: displayMode) { item in
                print("did tap callback: \(item)")
            }
        toolbarItems.append(toolbarGroup)
        itemIdentifiers.append(toolbarGroup.itemIdentifier)
        addSpaceIfNeeded(group.trailingSpace)
        return false
    }

    override var displayMode: NSToolbar.DisplayMode {
        didSet {
            refreshWidths()
        }
    }

    func setItems(items: [Any]) -> Bool {
        itemIdentifiers.removeAll()
        toolbarItems.removeAll()
        var centerIdentifiers = Set<NSToolbarItem.Identifier>()
        for item in items {
            switch item {
            case let item as ToolbarItem:
                addItem(item)
                if item.isCenterItem == true {
                    centerIdentifiers.insert(item.identifier())
                }
            case let group as ToolbarGroup:
                if addGroup(group) && group.isCenterItem == true {
                    centerIdentifiers.insert(group.identifier())
                }
            default:
                break
            }
        }
        if centerIdentifiers.isEmpty {
            centerIdentifiers = Set(toolbarItems.map { $0.itemIdentifier })
        }
        if #available(macOS 13.0, *) {
            centeredItemIdentifiers = centerIdentifiers
        } else {
            centeredItemIdentifier = centerIdentifiers.first
        }
        refreshToolbar()
        return true
    }

    func setSelected(item _: ToolbarItem) -> Bool {
//        selectedItemIdentifier
//        itemGroup?.selectedIndex = toolbarItems.firstIndex(where: { $0 == item }) ?? 0
        return true
    }

    init(identifier: NSToolbar.Identifier, flutterApi: ToolbarFlutterApi) {
        NSToolbarSwizzler.swizzleIfNeeded()
        self.flutterApi = flutterApi
        super.init(identifier: identifier)
        delegate = self
        allowsUserCustomization = true
        autosavesConfiguration = false
        self.displayMode = .iconAndLabel
    }

    func validateToolbarItem(_: NSToolbarItem) -> Bool {
        return true
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        toolbarItems.map { $0.itemIdentifier }
    }
    
    func toolbarAllowedItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] {
        toolbarItems.map { $0.itemIdentifier } + [.flexibleSpace, .space]
    }

    func toolbar(_: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar _: Bool) -> NSToolbarItem? {
        toolbarItems.first { $0.itemIdentifier == itemIdentifier }
    }

    @objc func didTapItem(_ sender: NSToolbarItem) {
        print("didTapItem \(sender)")
    }

    @objc func didTapGroup(_ sender: NSObject) {
        print(sender)
        let selectedIndex: Int
        if let segmented = sender as? NSSegmentedControl {
            selectedIndex = segmented.selectedSegment
        } else if let menuItem = sender as? NSMenuItem {
            guard let group = menuItem.representedObject as? ToolbarGroup else { return }
            print(group)
//            segmentedControls[group]?.selectedSegment = menuItem.tag
//            flutterApi.didSelectItem(item: .init(
//                index: menuItem.tag.int32,
//                item: group.compactItems[menuItem.tag],
//                group: group)) {}
        } else if let group = sender as? NSToolbarItemGroup {
            selectedIndex = group.selectedIndex
        } else {
            return
        }

//        flutterApi.didSelectItem(
//            item: SelectedToolbarItem(
//                index: sender.selectedIndex.int32,
//                item: toolbarItems[sender.selectedIndex])) {}
    }
}
