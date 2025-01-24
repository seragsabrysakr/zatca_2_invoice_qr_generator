//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <qr_bar_code/qr_bar_code_plugin_c_api.h>
#include <zatca_2_invoice/zatca2_invoice_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  QrBarCodePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("QrBarCodePluginCApi"));
  Zatca2InvoicePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("Zatca2InvoicePluginCApi"));
}
