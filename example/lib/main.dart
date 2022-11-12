import 'package:desktop_toolbar/desktop_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _desktopToolbar = DesktopToolbar(
    didSelectItem: (selectedToolbarItem) =>
        print("DID SELECT ITEM: ${selectedToolbarItem.item.title}"),
    items: [
      ToolbarItem(
          title: 'Cool',
          iconData: ToolbarItemIcon.adaptive(
              material: Icons.abc_sharp,
              cupertino: CupertinoIcons.add_circled)),
      ToolbarGroup(
        isCenterItem: true,
        selectionMode: GroupSelectionMode.single,
        items: [
          ToolbarItem(
            title: "Home",
            iconData: ToolbarItemIcon.adaptive(
              cupertino: CupertinoIcons.house,
              material: Icons.house,
            ),
          ),
          ToolbarItem(
            title: "Todos",
            isSelected: true,
            iconData: ToolbarItemIcon.adaptive(
              cupertino: CupertinoIcons.list_bullet,
              material: Icons.list,
            ),
          ),
          ToolbarItem(
            title: "Schedule",
            iconData: ToolbarItemIcon.adaptive(
              cupertino: CupertinoIcons.clock,
              material: Icons.list,
            ),
          ),
          ToolbarItem(
            title: "Settings",
            iconData: ToolbarItemIcon.adaptive(
              cupertino: CupertinoIcons.settings,
              material: Icons.settings,
            ),
          ),
        ],
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: Text('Running toolbar example!'),
        ),
      ),
    );
  }
}
