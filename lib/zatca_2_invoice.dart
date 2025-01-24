import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_bar_code/qr/qr.dart';
import 'dart:convert';
import 'dart:typed_data';

class Zatca2Invoice extends StatelessWidget {
  const Zatca2Invoice({
    super.key,
    required this.sellerName,
    required this.sellerTRN,
    required this.totalWithVat,
    required this.totalVat,
    required this.issueDate,
    required this.invoiceHash,
    // required this.digitalSignature,
    // required this.publicKey,
    // required this.certificateSignature,
    this.backgroundColor = Colors.transparent,
    this.size = 200,
    this.eyeStyle,
  });

  final String sellerName;
  final String sellerTRN;
  final String totalWithVat;
  final String totalVat;
  final String issueDate;
  final String invoiceHash; // New parameter for invoice hash
  // final String digitalSignature; // New parameter for digital signature
  // final String publicKey; // New parameter for public key
  // final String certificateSignature; // New parameter for certificate signature
  final double size;
  final Color backgroundColor;
  final QREyeStyle? eyeStyle;

  String _getQrCodeContent() {
    Map<int, String> invoiceData = {
      1: sellerName, // Seller name
      2: sellerTRN, // VAT registration number
      3: issueDate, // Timestamp 2024-05-30T12:30:00Z
      4: totalWithVat, // Invoice total amount
      5: totalVat, // VAT total amount
      6: invoiceHash // VAT total amount
    };

    String tlvString = generateTlv(invoiceData);
    String base64String = tlvToBase64(tlvString);
    return base64String;
  }

  @override
  Widget build(BuildContext context) {
    return QRCode(
      data: _getQrCodeContent(),
      size: size,
      eyeStyle: eyeStyle ??
          const QREyeStyle(
            eyeShape: QREyeShape.square,
            color: Colors.black,
          ),
      backgroundColor: backgroundColor,
    );
  }

  /// Converts a string to its hexadecimal representation.
  String stringToHex(String input) {
    return input.codeUnits
        .map((unit) => unit.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  /// Generates a TLV string from a map of tag-value pairs.
  String generateTlv(Map<int, String> data) {
    StringBuffer tlv = StringBuffer();

    data.forEach((tag, value) {
      String valueHex = stringToHex(value);
      String lengthHex = value.length.toRadixString(16).padLeft(2, '0');
      String tagHex = tag.toRadixString(16).padLeft(2, '0');

      tlv.write(tagHex);
      tlv.write(lengthHex);
      tlv.write(valueHex);
    });

    return tlv.toString();
  }

  /// Converts a TLV string to a Base64 encoded string.
  String tlvToBase64(String tlv) {
    List<int> bytes = [];

    for (int i = 0; i < tlv.length; i += 2) {
      String hexStr = tlv.substring(i, i + 2);
      int byte = int.parse(hexStr, radix: 16);
      bytes.add(byte);
    }

    Uint8List byteArray = Uint8List.fromList(bytes);
    String base64Str = base64Encode(byteArray);

    return base64Str;
  }
}
