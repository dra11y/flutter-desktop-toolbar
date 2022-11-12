library desktop_toolbar;

import 'dart:io';

import 'package:desktop_toolbar/src/pigeons.g.dart';
export 'package:desktop_toolbar/src/pigeons.g.dart';
import 'package:flutter/material.dart';

export 'src/desktop_toolbar_platform_interface.dart';
export 'src/desktop_toolbar_macos.dart';

class DesktopToolbar extends ToolbarFlutterApi {
  DesktopToolbar({
    ValueChanged<SelectedToolbarItem>? didSelectItem,
    // ToolbarStyle? style,
    required this.items,
  }) : // style = style ?? ToolbarStyle(),
        _didSelectItem = didSelectItem {
    assert(items.every((item) => item is ToolbarItem || item is ToolbarGroup));
    // _api.setStyle(this.style);
    _api.setItems(items);
    ToolbarFlutterApi.setup(this);
  }

  final ValueChanged<SelectedToolbarItem>? _didSelectItem;
  // final ToolbarStyle style;
  final List<Object> items;
  final ToolbarHostApi _api = ToolbarHostApi();

  @override
  void didSelectItem(SelectedToolbarItem item) {
    _didSelectItem?.call(item);
  }
}

class ToolbarItemIcon extends ToolbarItemIconData {
  factory ToolbarItemIcon.adaptive({
    required IconData material,
    required IconData cupertino,
  }) =>
      ToolbarItemIcon(
        icon: Platform.isMacOS ? cupertino : material,
      );

  ToolbarItemIcon({
    required IconData icon,
  }) : super(
          codePoint: icon.codePoint,
          fontFamily: icon.fontFamily,
        );
}
