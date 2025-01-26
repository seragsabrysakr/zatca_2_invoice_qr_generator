import 'dart:convert';
import 'dart:developer';
import 'package:zatca_2_invoice_generator/zatca_2_invoice_generator.dart';

class ZatcaManager {
  ZatcaManager._();
  static ZatcaManager instance = ZatcaManager._();
  Supplier? _supplier;
  String? _privateKeyBase64;
  String? _certificateBase64;
  String? _sellerName;
  String? _sellerTRN;

  initializeZacta({
    required Supplier supplier,
    required String privateKeyBase64,
    required String certificateBase64,
    required String sellerName,
    required String sellerTRN,
  }) {
    _supplier = supplier;
    _privateKeyBase64 = privateKeyBase64;
    _certificateBase64 = certificateBase64;
    _sellerName = sellerName;
    _sellerTRN = sellerTRN;
  }

  QrDataModel generateZatcaQrInit({
    required List<InvoiceLine> invoiceLines,
    required InvoiceType invoiceType,
    required String issueDate,
    required String invoiceUUid,
    required String invoiceNumber,
    required String issueTime,
    required String totalWithVat,
    required String totalVat,
  }) {
    if (_supplier == null ||
        _privateKeyBase64 == null ||
        _certificateBase64 == null ||
        _sellerName == null ||
        _sellerTRN == null) {
      throw Exception(
          'Supplier, private key, certificate, seller name, and seller TRN must be initialized before generating the QR code.');
    }
    
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
      supplier: _supplier!,
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
    final privateKey = parsePrivateKey(_privateKeyBase64!);

    // Example XML hash

    // Generate the ECDSA signature
    final signature = generateECDSASignature(xmlHash, privateKey);
    final result = parseCSR(_certificateBase64!);
    final publicKey = result['publicKey'];
    final certificateSignature = base64.encode(result['signature']);
    log('xmlHash: $xmlHash');
    log('signature: $signature');
    log('Public Key (Base64): ${result['publicKey']}');
    log('Signature (Base64): ${base64.encode(result['signature'])}');

    return QrDataModel(
        sellerName: _sellerName!,
        sellerTRN: _sellerTRN!,
        issueDate: issueDate,
        invoiceHash: xmlHash,
        digitalSignature: signature,
        publicKey: publicKey,
        certificateSignature: certificateSignature,
        invoiceData: invoice);
  }
}
