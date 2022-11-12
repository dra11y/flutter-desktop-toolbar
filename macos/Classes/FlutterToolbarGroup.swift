//
//  FlutterToolbarGroup.swift
//  desktop_toolbar
//
//  Created by Tom Grushka on 11/11/22.
//

import Cocoa

class FlutterToolbarGroup: NSToolbarItemGroup, AnyFlutterToolbarItem {
    private(set) var group: ToolbarGroup!
    let segmented: NSSegmentedControl!
    let didTapItem: ((ToolbarItem) -> Void)?

    var displayMode: NSToolbar.DisplayMode {
        didSet { refreshUI() }
    }

    private func refreshUI() {
        let itemWidth = maxLabelWidth()
        for (index, item) in group.compactItems.enumerated() {
            let isSelected = item.isSelected ?? false
            segmented.setWidth(itemWidth, forSegment: index)
            segmented.setSelected(isSelected, forSegment: index)
            if let menuItem = subitems[index].menuFormRepresentation {
                menuItem.state = isSelected ? .on : .off
            }
        }
    }

    private func toggleSelected(item: ToolbarItem) {
        let isSelected: Bool
        switch selectionMode {
        case .selectOne:
            isSelected = true
        case .selectAny:
            isSelected = !(item.isSelected ?? false)
        case .momentary:
            isSelected = false
        @unknown default:
            return
        }
        if isSelected != item.isSelected {
            let newItems = group.compactItems.map { it in
                let itemIsSelected: Bool? = it == item ? isSelected : (
                    selectionMode == .selectOne ? false : it.isSelected)
                return it.copyWith(isSelected: itemIsSelected)
            }
            let newGroup = group.copyWith(items: newItems)
            group = newGroup
            refreshUI()
        }
    }

    private func didSelect(index: Int) {
        toggleSelected(item: group.compactItems[index])
        didTapItem?(group.compactItems[index])
    }

    @objc func didTapMenuItem(_ sender: NSMenuItem) {
        didSelect(index: sender.tag)
    }

    @objc func didTapSegment(_ sender: NSSegmentedControl) {
        didSelect(index: sender.selectedSegment)
    }

    init(
        group: ToolbarGroup,
        displayMode: NSToolbar.DisplayMode,
        didTapItem: ((ToolbarItem) -> Void)? = nil)
    {
        self.group = group
        self.displayMode = displayMode
        self.didTapItem = didTapItem
        let images = group.compactItems.compactMap { $0.iconData.render() }
        self.segmented = NSSegmentedControl(
            images: images,
            trackingMode: group.selectionMode.segmentedSwitchTracking,
            target: nil,
            action: #selector(didTapSegment(_:)))
        super.init(itemIdentifier: group.identifier())

        // ClassDumpUtility.dumpClass(klass: NSToolbarItem.self)

        if let label = group.paletteLabel {
            paletteLabel = label
        } else {
            /// The only way to "clear" the paletteLabel if it has been set!
            /// (Empty string does not work.)
            setValue(Optional<Any>(nilLiteral: ()), forKey: "paletteLabel")
        }
        selectionMode = group.selectionMode.toolbarSelectionMode
        segmented.target = self
        segmented.segmentStyle = .texturedSquare
        let itemWidth = maxLabelWidth()
        for (index, item) in group.compactItems.enumerated() {
            let subitem = NSToolbarItem(itemIdentifier: item.identifier())

            let isSelected = item.isSelected ?? false

            subitem.title = item.title
            subitem.label = item.title
            subitem.toolTip = item.title

            if let menuItem = subitem.menuFormRepresentation {
                menuItem.image = images[index]
                menuItem.state = isSelected ? .on : .off
                menuItem.tag = index
                menuItem.target = self
                menuItem.action = #selector(didTapMenuItem(_:))
            }

            segmented.setSelected(isSelected, forSegment: index)
            segmented.setWidth(itemWidth, forSegment: index)

            subitems.insert(subitem, at: index)
        }
        self.view = segmented
    }

    private let defaultItemWidth: CGFloat = 24

    private func maxLabelWidth() -> CGFloat {
        displayMode == .iconAndLabel
            ? (group.compactItems.map { $0.labelWidth() }.max() ?? defaultItemWidth)
            : defaultItemWidth
    }
}
