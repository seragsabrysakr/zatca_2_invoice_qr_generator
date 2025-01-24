import 'dart:convert';

import 'package:zatca_2_invoice/models/qr_data_model.dart';
import 'package:zatca_2_invoice/zatca_2_invoice_generator.dart';

QrDataModel generateZatcaQrInit({
  required Supplier supplier,
  required String privateKeyBase64,
  required String certificateBase64,
  required String sellerName,
  required String sellerTRN,
  required String totalWithVat,
  required String totalVat,
  required String issueDate, // YYYY-MM-DD,
  required String issueTime, // HH:MM:SS
  required String invoiceType, // HH:MM:SS
}) {
  final invoice = InvoiceData(
    profileID: 'reporting:1.0',
    id: 'SME00010',
    uuid: '8e6000cf-1a98-4174-b3e7-b5d5954bc10d',
    issueDate: issueDate,
    issueTime: issueTime,
    invoiceTypeCode: '388',
    invoiceTypeName: invoiceType,
    note: 'Test Invoice',
    currencyCode: 'SAR',
    taxCurrencyCode: 'SAR',
    supplier: Supplier(
      companyID: supplier.companyID,
      registrationName: supplier.registrationName,
      address: Address(
        streetName: supplier.address.streetName,
        buildingNumber: supplier.address.buildingNumber,
        citySubdivisionName: supplier.address.citySubdivisionName,
        cityName: supplier.address.cityName,
        postalZone: supplier.address.postalZone,
        countryCode: 'SA',
      ),
    ),
    customer: Customer(
      companyID: '2020020000',
      registrationName: 'Customer Co.',
      address: Address(
        streetName: 'Street 2',
        buildingNumber: '456',
        citySubdivisionName: 'Subdivision',
        cityName: 'City',
        postalZone: '11111',
        countryCode: 'SA',
      ),
    ),
    invoiceLines: [
      InvoiceLine(
        id: '1',
        quantity: '10',
        unitCode: 'PCE',
        lineExtensionAmount: '100.00',
        itemName: 'Item 1',
        taxPercent: '15',
      ),
    ],
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
    totalWithVat: totalWithVat,
    totalVat: totalVat,
    issueDate: issueDate,
    invoiceHash: xmlHash,
    digitalSignature: signature,
    publicKey: publicKey,
    certificateSignature: certificateSignature,
  );
}
