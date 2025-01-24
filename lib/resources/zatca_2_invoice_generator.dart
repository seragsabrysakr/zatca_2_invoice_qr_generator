import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_bar_code/qr/qr.dart';
import 'package:zatca_2_invoice_generator/zatca_2_invoice_generator.dart';
 
class Zatca2InvoiceQrGenerator extends StatelessWidget {
  const Zatca2InvoiceQrGenerator({
    super.key,
    required this.qrDataModel,

    this.backgroundColor = Colors.transparent,
    this.size = 200,
  });

  final QrDataModel qrDataModel; 
// Certificate authority signature
  final double size; // Size of the QR code
  final Color backgroundColor; // Background color of the QR code

  /// Generates the QR code content by creating a TLV string and encoding it to Base64.
  String _getQrCodeContent() {
    // Map of tag-value pairs for the ZATCA QR code
    Map<int, String> invoiceData = {
      1: qrDataModel.sellerName,
      2: qrDataModel.sellerTRN,
      3: qrDataModel.issueDate,
      4: qrDataModel.invoiceData.totalAmount,
      5: qrDataModel.invoiceData.taxAmount,
      6: qrDataModel.invoiceHash,
      7: qrDataModel.digitalSignature,
      8: qrDataModel.publicKey,
      9: qrDataModel.certificateSignature,
    };

    // Generate TLV string
    String tlvString = _generateTlv(invoiceData);

    // Convert the TLV string to Base64
    return _tlvToBase64(tlvString);
  }

  /// Converts a string to its hexadecimal representation.
  String _stringToHex(String input) {
    return input.codeUnits
        .map((unit) => unit.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  /// Generates a TLV string from a map of tag-value pairs.
  String _generateTlv(Map<int, String> data) {
    StringBuffer tlv = StringBuffer();

    data.forEach((tag, value) {
      String tagHex =
          tag.toRadixString(16).padLeft(2, '0'); // Convert tag to hex
      String valueHex = _stringToHex(value); // Convert value to hex
      String lengthHex =
          value.length.toRadixString(16).padLeft(2, '0'); // Length in hex

      // Concatenate tag, length, and value into the TLV structure
      tlv.write(tagHex);
      tlv.write(lengthHex);
      tlv.write(valueHex);
    });

    return tlv.toString();
  }

  /// Converts a TLV string to a Base64 encoded string.
  String _tlvToBase64(String tlv) {
    List<int> bytes = [];

    for (int i = 0; i < tlv.length; i += 2) {
      String hexStr = tlv.substring(i, i + 2); // Two hex characters at a time
      int byte = int.parse(hexStr, radix: 16); // Parse as a byte
      bytes.add(byte);
    }

    Uint8List byteArray = Uint8List.fromList(bytes);
    return base64Encode(byteArray); // Convert to Base64
  }

  @override
  Widget build(BuildContext context) {
    return QRCode(
      data: _getQrCodeContent(),
      size: size,
      eyeStyle: const QREyeStyle(
        eyeShape: QREyeShape.square,
        color: Colors.black,
      ),
      backgroundColor: backgroundColor,
    );
  }
}
