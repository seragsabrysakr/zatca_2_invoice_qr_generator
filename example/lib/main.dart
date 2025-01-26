import 'package:example/zatca_constants.dart';
import 'package:flutter/material.dart';
import 'package:zatca_2_invoice_generator/zatca_2_invoice_generator.dart';

void main() {
  initZacta();
  runApp(MyApp());
}

void initZacta() {
  ZatcaManager.instance.initializeZacta(
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
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final qrDataModel = ZatcaManager.instance.generateZatcaQrInit(
    totalVat: "45.0",
    totalWithVat: "300.0",
    issueDate: "2024-01-17",
    issueTime: "05:41:08",
    invoiceUUid: "8e6000cf-1a98-4174-b3e7-b5d5954bc10d",
    invoiceNumber: "INV0001",
    invoiceLines: [
      InvoiceLine(
        id: '1',
        quantity: '10',
        unitCode: 'PCE',
        lineExtensionAmount: '100.00',
        itemName: 'Item 1',
        taxPercent: '15',
      ),
      InvoiceLine(
        id: '2',
        quantity: '1',
        unitCode: 'PCE',
        lineExtensionAmount: '200.00',
        itemName: 'Item 1',
        taxPercent: '15',
      ),
    ],
    invoiceType: ZatcaConstants.invoiceType,
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zatca Phase 2 Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Zatca Phase 2 Demo'),
        ),
        body: Center(
          child: Zatca2InvoiceQrGenerator(qrDataModel: qrDataModel),
        ),
      ),
    );
  }
}
