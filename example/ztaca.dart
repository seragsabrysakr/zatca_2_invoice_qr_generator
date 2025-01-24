import 'dart:convert';

import 'package:zatca_2_invoice/models/invoice_data_model.dart';
import 'package:zatca_2_invoice/resources/public_key_signature_generator.dart';
import 'package:zatca_2_invoice/resources/signature_generator.dart';
import 'package:zatca_2_invoice/resources/xml_generator.dart';
import 'package:zatca_2_invoice/resources/xml_hashing.dart';

import 'constants.dart';

void main() {
  final invoice = InvoiceData(
    profileID: 'reporting:1.0',
    id: 'SME00010',
    uuid: '8e6000cf-1a98-4174-b3e7-b5d5954bc10d',
    issueDate: '2022-08-17',
    issueTime: '17:41:08',
    invoiceTypeCode: '388',
    invoiceTypeName: '0200000',
    note: 'Test Invoice',
    currencyCode: 'SAR',
    taxCurrencyCode: 'SAR',
    supplier: Supplier(
      companyID: '1010010000',
      registrationName: 'Supplier Co.',
      address: Address(
        streetName: 'Street 1',
        buildingNumber: '123',
        citySubdivisionName: 'Subdivision',
        cityName: 'City',
        postalZone: '00000',
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
  final privateKey = parsePrivateKey(ZatcaConstants.privateKeyBase64);

  // Example XML hash

  // Generate the ECDSA signature
  final signature = generateECDSASignature(xmlHash, privateKey);
  final result = parseCSR(ZatcaConstants.csrPem);
  print('xmlHash: $xmlHash');
  print('signature: $signature');
  print('Public Key (Base64): ${result['publicKey']}');
  print('Signature (Base64): ${base64.encode(result['signature'])}');
}
