import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';

/// Converts a BigInt to a byte array.
Uint8List bigIntToByteArray(BigInt number) {
  if (number == BigInt.zero) {
    return Uint8List(1);
  }

  final bytes = <int>[];
  var value = number;

  while (value != BigInt.zero) {
    bytes.add((value & BigInt.from(0xFF)).toInt());
    value = value >> 8;
  }

  return Uint8List.fromList(bytes.reversed.toList());
}

/// Initialize a SecureRandom instance using FortunaRandom
SecureRandom createSecureRandom() {
  final secureRandom = FortunaRandom();
  final random = Random.secure();

  // Generate a random seed
  final seed = Uint8List(32); // 32 bytes = 256 bits
  for (int i = 0; i < seed.length; i++) {
    seed[i] = random.nextInt(256);
  }

  secureRandom.seed(KeyParameter(seed));
  return secureRandom;
}

/// Parses a Base64-encoded private key in PKCS#8 or SEC1 format.
ECPrivateKey parsePrivateKey(String base64Key) {
  // Decode the Base64 key
  final keyBytes = base64.decode(base64Key);

  // Parse the ASN.1 structure
  final asn1Parser = ASN1Parser(keyBytes);
  final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

  if (topLevelSeq.elements.length == 3) {
    // PKCS#8 format
    final privateKeyOctets =
        (topLevelSeq.elements[2] as ASN1OctetString).octets;
    final privateKeyParser = ASN1Parser(privateKeyOctets);
    final pkSeq = privateKeyParser.nextObject() as ASN1Sequence;

    final privateKeyInt = (pkSeq.elements[1] as ASN1Integer).valueAsBigInteger;
    final curve = ECCurve_secp256r1();
    return ECPrivateKey(privateKeyInt, curve);
  } else if (topLevelSeq.elements.length == 4) {
    // SEC1 format
    final privateKeyBytes = (topLevelSeq.elements[1] as ASN1OctetString).octets;
    final privateKeyInt = BigInt.parse(
      privateKeyBytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join(),
      radix: 16,
    );
    final curve = ECCurve_secp256r1();
    return ECPrivateKey(privateKeyInt, curve);
  } else {
    throw ArgumentError('Invalid private key format');
  }
}

/// Generate ECDSA Signature
String generateECDSASignature(String data, ECPrivateKey privateKey) {
  final signer = Signer('SHA-256/ECDSA');
  final params = PrivateKeyParameter<ECPrivateKey>(privateKey);

  // Initialize the signer with SecureRandom
  signer.init(true, ParametersWithRandom(params, createSecureRandom()));

  // Hash the data
  final hash = Uint8List.fromList(utf8.encode(data));

  // Generate the signature
  final ECSignature signature = signer.generateSignature(hash) as ECSignature;

  // Encode R and S as Base64
  final r = base64.encode(bigIntToByteArray(signature.r));
  final s = base64.encode(bigIntToByteArray(signature.s));

  return '$r:$s'; // Combine R and S
}

// void main() {
//   // Your private key in Base64 format
//   final privateKeyBase64 =
//       'MHQCAQEEIHOlLXEYEf3hop0BCA743QJ5OFZRxl+yi8l//Jt8l74JoAcGBSuBBAAKoUQDQgAELeYl68/VgiX6KkELLfcWsP8ZCWct9q4R9x71Ou4EBNWxNWqnC7m3Eh2iQOqaKoNIc2w8Tq1VnDuZnmdCzDUWKQ==';
//
//   // Parse the private key
//   final privateKey = parsePrivateKey(privateKeyBase64);
//
//   // Example XML hash
//   final xmlHash = 'This is a sample hash for the XML data';
//
//   // Generate the ECDSA signature
//   final signature = generateECDSASignature(xmlHash, privateKey);
//
//   print('ECDSA Signature: $signature');
// }
