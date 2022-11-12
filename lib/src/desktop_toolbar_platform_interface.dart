import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import './pigeons.g.dart';
export './pigeons.g.dart' show ToolbarItem;

class _PlaceholderImplementation extends DesktopToolbarPlatform {}

abstract class DesktopToolbarPlatform extends PlatformInterface {
  /// Constructs a DesktopToolbarPlatform.
  DesktopToolbarPlatform() : super(token: _token);

  static final Object _token = Object();

  static DesktopToolbarPlatform _instance = _PlaceholderImplementation();

  /// The default instance of [DesktopToolbarPlatform] to use.
  ///
  /// Defaults to [MethodChannelDesktopToolbar].
  static DesktopToolbarPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DesktopToolbarPlatform] when
  /// they register themselves.
  static set instance(DesktopToolbarPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
