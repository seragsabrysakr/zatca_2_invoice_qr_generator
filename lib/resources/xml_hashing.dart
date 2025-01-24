import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Function to generate a SHA-256 hash of the XML string
String generateHash(String xmlString) {
  // Compute the SHA-256 hash
  final bytes = utf8.encode(xmlString); // Convert XML to bytes
  final hash = sha256.convert(bytes); // Compute the SHA-256 hash

  // Encode the hash in Base64
  return base64.encode(hash.bytes);
}
