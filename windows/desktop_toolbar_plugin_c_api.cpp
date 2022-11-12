#include "include/desktop_toolbar/desktop_toolbar_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "desktop_toolbar_plugin.h"

void DesktopToolbarPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  desktop_toolbar::DesktopToolbarPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
