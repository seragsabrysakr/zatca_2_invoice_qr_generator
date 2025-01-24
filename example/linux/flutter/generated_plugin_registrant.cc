//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <qr_bar_code/qr_bar_code_plugin.h>
#include <zatca_2_invoice/zatca2_invoice_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) qr_bar_code_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "QrBarCodePlugin");
  qr_bar_code_plugin_register_with_registrar(qr_bar_code_registrar);
  g_autoptr(FlPluginRegistrar) zatca_2_invoice_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "Zatca2InvoicePlugin");
  zatca2_invoice_plugin_register_with_registrar(zatca_2_invoice_registrar);
}
