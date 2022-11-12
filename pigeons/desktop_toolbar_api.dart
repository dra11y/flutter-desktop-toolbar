import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeons.g.dart',
    swiftOut: 'macos/Classes/GeneratedPigeons.swift',
  ),
)
enum GroupSelectionMode {
  single,
  multiple,
  momentary,
}

enum ToolbarSpace {
  single,
  flexible,
}

class ToolbarGroup {
  ToolbarGroup({
    required this.items,
    required this.selectionMode,
    this.leadingSpace,
    this.trailingSpace,
    this.isCenterItem,
    this.paletteLabel,
  });

  final List<ToolbarItem?> items;
  final GroupSelectionMode selectionMode;
  final ToolbarSpace? leadingSpace;
  final ToolbarSpace? trailingSpace;
  final bool? isCenterItem;
  final String? paletteLabel;
}

class ToolbarItem {
  ToolbarItem({
    required this.title,
    required this.iconData,
    this.leadingSpace,
    this.trailingSpace,
    this.isCenterItem,
    this.isSelected,
  });

  final String title;
  final ToolbarItemIconData iconData;
  final ToolbarSpace? leadingSpace;
  final ToolbarSpace? trailingSpace;
  final bool? isCenterItem;
  final bool? isSelected;
}

// class ToolbarStyle {
//   ToolbarStyle({this.itemWidthMultiplier});

//   final double? itemWidthMultiplier;
// }

class SelectedToolbarItem {
  SelectedToolbarItem({required this.index, required this.item, this.group});

  final int index;
  final ToolbarItem item;
  final ToolbarGroup? group;
}

class ToolbarItemIconData {
  ToolbarItemIconData({
    this.codePoint,
    this.fontFamily,
  });

  final int? codePoint;
  final String? fontFamily;
}

@FlutterApi()
abstract class ToolbarFlutterApi {
  void didSelectItem(SelectedToolbarItem item);
}

@HostApi()
abstract class ToolbarHostApi {
  // bool setStyle(ToolbarStyle style);
  bool setItems(List<Object> items);
  bool setSelected(ToolbarItem item);
}
