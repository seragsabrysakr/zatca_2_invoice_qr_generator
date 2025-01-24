#include "include/zatca_2_invoice/zatca2_invoice_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "zatca2_invoice_plugin.h"

void Zatca2InvoicePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  zatca_2_invoice::Zatca2InvoicePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
