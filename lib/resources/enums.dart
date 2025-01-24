// ignore_for_file: constant_identifier_names

enum InvoiceType {
  StandardInvoicesAndSimplifiedInvoices(
      "Standard Invoices and Simplified Invoices"),
  SimplifiedCreditNote("SimplifiedCreditNote");

  final String value;
  const InvoiceType(this.value);
}
