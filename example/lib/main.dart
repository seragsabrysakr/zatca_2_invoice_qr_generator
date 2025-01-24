import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:zatca_2_invoice/zatca_2_invoice.dart';
import 'package:zatca_2_invoice_example/zatca_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Zatca2Invoice(
            sellerName: ZatcaConstants.companyName,
            sellerTRN: ZatcaConstants.taxRegistrationNumber,
            totalWithVat: "100",
            totalVat: "10",
            issueDate: DateTime.now().toUtc().toIso8601String(),
            invoiceHash: "invoiceHash",
          ),
        ),
      ),
    );
  }
}
