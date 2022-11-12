//
//  Extensions.swift
//  desktop_toolbar
//
//  Created by Tom Grushka on 11/5/22.
//

import Foundation

extension NSToolbar.Identifier {
    static let mainWindowToolbar = NSToolbar.Identifier("MainWindowToolbar")
}

extension GroupSelectionMode {
    var segmentedSwitchTracking: NSSegmentedControl.SwitchTracking {
        switch self {
        case .single:
            return .selectOne
        case .multiple:
            return .selectAny
        case .momentary:
            return .momentary
        }
    }

    var toolbarSelectionMode: NSToolbarItemGroup.SelectionMode {
        switch self {
        case .single:
            return .selectOne
        case .multiple:
            return .selectAny
        case .momentary:
            return .momentary
        }
    }
}

extension ToolbarGroup {
    func copyWith(items: [ToolbarItem]? = nil, selectionMode: GroupSelectionMode? = nil) -> ToolbarGroup {
        ToolbarGroup(
            items: items ?? self.items,
            selectionMode: selectionMode ?? self.selectionMode)
    }
    
    var compactItems: [ToolbarItem] {
        items.compactMap { $0 }
    }

    var isEmpty: Bool {
        compactItems.isEmpty
    }

    func identifier() -> NSToolbarItem.Identifier {
        NSToolbarItem.Identifier("group-\(compactItems.map { $0.title }.joined(separator: "-"))")
    }
}

extension ToolbarGroup: Hashable {
    static func == (lhs: ToolbarGroup, rhs: ToolbarGroup) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(compactItems)
        hasher.combine(isCenterItem)
        hasher.combine(selectionMode)
        hasher.combine(leadingSpace)
        hasher.combine(trailingSpace)
    }
}

extension ToolbarItemIconData {
    func render(width: CGFloat = 18) -> NSImage? {
        guard
            let fontFamily = fontFamily,
            let codePoint = codePoint
        else { return nil }
        return FontRegistry.resolve(
            family: fontFamily,
            size: 18)?.renderIcon(
            codePoint: codePoint.int,
            size: CGSize(width: width, height: 18))
    }
}

extension ToolbarItemIconData: Hashable {
    static func == (lhs: ToolbarItemIconData, rhs: ToolbarItemIconData) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(codePoint)
        hasher.combine(fontFamily)
    }
}

extension ToolbarItem {
    func copyWith(title: String? = nil, iconData: ToolbarItemIconData? = nil, isSelected: Bool? = nil) -> ToolbarItem {
        ToolbarItem(
            title: title ?? self.title,
            iconData: iconData ?? self.iconData,
            isSelected: isSelected ?? self.isSelected)
    }
    
    static let labelFont = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: .small))

    func identifier() -> NSToolbarItem.Identifier {
        NSToolbarItem.Identifier("item-\(title)")
    }

    func labelWidth() -> CGFloat {
        (title as NSString).size(withAttributes: [.font: ToolbarItem.labelFont]).width
    }
}

extension ToolbarItem: Hashable {
    public static func == (lhs: ToolbarItem, rhs: ToolbarItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(iconData)
        hasher.combine(leadingSpace)
        hasher.combine(trailingSpace)
    }
}

extension Int32 {
    var int: Int { Int(self) }
}

extension Int {
    var int32: Int32 { Int32(self) }
}

extension NSImage {
    @nonobjc convenience init(imageLiteralResourceName name: String) {
        fatalError("init(imageLiteralResourceName:) has not been implemented")
    }
}

extension NSAppearance {
    public var isDark: Bool {
        [
            .darkAqua,
            .vibrantDark,
            .accessibilityHighContrastDarkAqua,
            .accessibilityHighContrastVibrantDark,
        ].contains(name)
    }
}

extension NSFont {
    func renderIcon(codePoint: Int, size: CGSize? = nil) -> NSImage? {
        guard let scalar = UnicodeScalar(codePoint) else {
            assertionFailure("Invalid Unicode code point: \(codePoint).")
            return nil
        }

        let cgSize = size ?? CGSize(width: pointSize, height: pointSize)
        let iconString = NSString(string: String(scalar))

        let attributes: [NSAttributedString.Key: Any] = [
            .font: withSize(cgSize.height),
        ]

        let image = NSImage(size: cgSize, flipped: false) { rect in
            let centeredSquare = NSRect(
                x: rect.minX + (rect.width - rect.height) / 2,
                y: rect.minY,
                width: rect.height,
                height: rect.height)
            iconString.draw(in: centeredSquare, withAttributes: attributes)
            return true
        }
        image.isTemplate = true

        return image
    }
}
