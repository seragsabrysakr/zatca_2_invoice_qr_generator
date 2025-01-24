import 'package:example/constants.dart';
import 'package:flutter/material.dart';
import 'package:zatca_2_invoice/zatca_2_invoice.dart';
import 'package:zatca_2_invoice/zatca_2_invoice_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final qrDataModel = generateZatcaQrInit(
    totalVat: "15.0",
    totalWithVat: "100.0",
    issueDate: "2022-08-17",
    issueTime: "17:41:08",
    invoiceType: ZatcaConstants.invoiceType,
    sellerName: ZatcaConstants.companyName,
    sellerTRN: ZatcaConstants.taxRegistrationNumber,
    privateKeyBase64: ZatcaConstants.privateKeyBase64,
    certificateBase64: ZatcaConstants.certificateBase64,
    supplier: Supplier(
      companyID: ZatcaConstants.commercialRegistrationNumber,
      registrationName: ZatcaConstants.taxRegistrationNumber,
      address: Address(
        streetName: ZatcaConstants.street,
        buildingNumber: ZatcaConstants.buildingNumber,
        citySubdivisionName: ZatcaConstants.area,
        cityName: ZatcaConstants.cityName,
        postalZone: ZatcaConstants.postalZone,
        countryCode: "SA",
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zatca Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Zatca Demo'),
        ),
        body: Center(
          child: Zatca2InvoiceQrGenerator(qrDataModel: qrDataModel),
        ),
      ),
      
    );
  }
}
