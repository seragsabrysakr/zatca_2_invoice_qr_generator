#ifndef FLUTTER_PLUGIN_ZATCA2_INVOICE_PLUGIN_H_
#define FLUTTER_PLUGIN_ZATCA2_INVOICE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace zatca_2_invoice {

class Zatca2InvoicePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  Zatca2InvoicePlugin();

  virtual ~Zatca2InvoicePlugin();

  // Disallow copy and assign.
  Zatca2InvoicePlugin(const Zatca2InvoicePlugin&) = delete;
  Zatca2InvoicePlugin& operator=(const Zatca2InvoicePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace zatca_2_invoice

#endif  // FLUTTER_PLUGIN_ZATCA2_INVOICE_PLUGIN_H_
