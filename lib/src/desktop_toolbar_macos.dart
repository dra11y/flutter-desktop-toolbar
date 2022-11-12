import 'package:desktop_toolbar/desktop_toolbar.dart';

class DesktopToolbarMacOS extends DesktopToolbarPlatform {
  static void registerWith() {
    DesktopToolbarPlatform.instance = DesktopToolbarMacOS();
  }
}
