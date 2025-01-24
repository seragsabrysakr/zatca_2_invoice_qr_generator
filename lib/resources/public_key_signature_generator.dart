import 'dart:convert';

import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';

Map<String, dynamic> parseCSR(String csrPem) {
  // Remove the PEM headers and footers
  final pemContent = csrPem
      .replaceAll("-----BEGIN CERTIFICATE REQUEST-----", "")
      .replaceAll("-----END CERTIFICATE REQUEST-----", "")
      .replaceAll("\n", "")
      .replaceAll("\r", ""); // Handle potential carriage returns

  // Decode the Base64 PEM content
  final bytes = base64.decode(pemContent);

  // Parse ASN.1 structure
  final asn1Parser = ASN1Parser(bytes);
  final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

  // Extract the certification request information
  final certificationRequestInfo = topLevelSeq.elements[0] as ASN1Sequence;

  // Extract the public key
  final publicKeyInfo = certificationRequestInfo.elements[2] as ASN1Sequence;
  final publicKeyBitString = publicKeyInfo.elements[1] as ASN1BitString;

  // Extract raw public key bytes
  final rawPublicKeyBytes = publicKeyBitString.contentBytes();
  final domainParams = ECDomainParameters('prime256v1');
  ECPoint ecPublicKeyPoint;

  // Handle compressed/uncompressed keys
  if (rawPublicKeyBytes.length == 33) {
    final prefix = rawPublicKeyBytes[0];
    final x = BigInt.parse(
        rawPublicKeyBytes
            .sublist(1)
            .map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(),
        radix: 16);
    ecPublicKeyPoint = domainParams.curve.decompressPoint(prefix, x);
  } else if (rawPublicKeyBytes.length == 65) {
    final x = BigInt.parse(
        rawPublicKeyBytes
            .sublist(1, 33)
            .map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(),
        radix: 16);
    final y = BigInt.parse(
        rawPublicKeyBytes
            .sublist(33)
            .map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(),
        radix: 16);
    ecPublicKeyPoint = domainParams.curve.createPoint(x, y);
  } else {
    throw ArgumentError('Unexpected length for raw public key bytes');
  }

  // Convert public key to DER format
  final publicKeyDER = [
    ...[0x30, 0x56], // SEQUENCE header
    ...[0x30, 0x10], // OID for EC public key
    ...[0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01],
    ...[0x06, 0x05, 0x2B, 0x81, 0x04, 0x00, 0x0A],
    ...[0x03, 0x42, 0x00],
    ...rawPublicKeyBytes
  ];

  // Extract the signature
  final signature = topLevelSeq.elements[2] as ASN1BitString;
  final signatureBytes = signature.contentBytes();

  return {
    'publicKey':
        base64.encode(publicKeyDER), // Public key in Base64-encoded DER format
    'publicKeyRaw': publicKeyDER, // Raw public key bytes
    'signature': signatureBytes, // Raw signature bytes
  };
}
