class InvoiceData {
  final String profileID;
  final String id;
  final String uuid;
  final String issueDate;
  final String issueTime;
  final String invoiceTypeCode;
  final String invoiceTypeName;
  final String note;
  final String currencyCode;
  final String taxCurrencyCode;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceLine> invoiceLines;
  final String taxAmount;
  final String totalAmount;

  InvoiceData({
    required this.profileID,
    required this.id,
    required this.uuid,
    required this.issueDate,
    required this.issueTime,
    required this.invoiceTypeCode,
    required this.invoiceTypeName,
    required this.note,
    required this.currencyCode,
    required this.taxCurrencyCode,
    required this.supplier,
    required this.customer,
    required this.invoiceLines,
    required this.taxAmount,
    required this.totalAmount,
  });
}

class Supplier {
  final String companyID;
  final String registrationName;
  final Address address;

  Supplier({
    required this.companyID,
    required this.registrationName,
    required this.address,
  });
}

class Customer {
  final String companyID;
  final String registrationName;
  final Address address;

  Customer({
    required this.companyID,
    required this.registrationName,
    required this.address,
  });
}

class Address {
  final String streetName;
  final String buildingNumber;
  final String citySubdivisionName;
  final String cityName;
  final String postalZone;
  final String countryCode;

  Address({
    required this.streetName,
    required this.buildingNumber,
    required this.citySubdivisionName,
    required this.cityName,
    required this.postalZone,
      this.countryCode= "SA",
  });
}

class InvoiceLine {
  final String id;
  final String quantity;
  final String unitCode;
  final String lineExtensionAmount;
  final String itemName;
  final String taxPercent;

  InvoiceLine({
    required this.id,
    required this.quantity,
    required this.unitCode,
    required this.lineExtensionAmount,
    required this.itemName,
    required this.taxPercent,
  });
}
