import 'dart:convert';

import 'package:zatca_2_invoice/models/qr_data_model.dart';
import 'package:zatca_2_invoice/resources/enums.dart';
import 'package:zatca_2_invoice/zatca_2_invoice_generator.dart';

QrDataModel generateZatcaQrInit({
  required Supplier supplier,
  required List<InvoiceLine> invoiceLines,
  required InvoiceType invoiceType,
  required String privateKeyBase64,
  required String issueDate,
  required String invoiceUUid,
  required String invoiceNumber,
  required String issueTime,
  required String certificateBase64,
  required String sellerName,
  required String sellerTRN,
  required String totalWithVat,
  required String totalVat,
}) {
  final invoice = InvoiceData(
    profileID: 'reporting:1.0',
    id: invoiceNumber,
    uuid: invoiceUUid,
    issueDate: issueDate,
    issueTime: issueTime,
    invoiceTypeCode: '388',
    invoiceTypeName: invoiceType.value,
    note: invoiceType.value,
    currencyCode: 'SAR',
    taxCurrencyCode: 'SAR',
    supplier: supplier,
    customer: Customer(
      companyID: ' ',
      registrationName: ' ',
      address: Address(
        streetName: ' ',
        buildingNumber: ' ',
        citySubdivisionName: ' ',
        cityName: ' ',
        postalZone: ' ',
        countryCode: ' ',
      ),
    ),
    invoiceLines: invoiceLines,
    taxAmount: '15.00',
    totalAmount: '115.00',
  );

  final xmlString = generateZATCAXml(invoice);

  final xmlHash = generateHash(xmlString);
  final privateKey = parsePrivateKey(privateKeyBase64);

  // Example XML hash

  // Generate the ECDSA signature
  final signature = generateECDSASignature(xmlHash, privateKey);
  final result = parseCSR(certificateBase64);
  final publicKey = result['publicKey'];
  final certificateSignature = base64.encode(result['signature']);
  print('xmlHash: $xmlHash');
  print('signature: $signature');
  print('Public Key (Base64): ${result['publicKey']}');
  print('Signature (Base64): ${base64.encode(result['signature'])}');

  return QrDataModel(
      sellerName: sellerName,
      sellerTRN: sellerTRN,
      issueDate: issueDate,
      invoiceHash: xmlHash,
      digitalSignature: signature,
      publicKey: publicKey,
      certificateSignature: certificateSignature,
      invoiceData: invoice);
}
