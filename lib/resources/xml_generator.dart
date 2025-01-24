import 'package:xml/xml.dart';
import 'package:zatca_2_invoice_generator/zatca_2_invoice_generator.dart';
 
String generateZATCAXml(InvoiceData data) {
  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('Invoice', nest: () {
    builder.attribute(
        'xmlns', 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2');
    builder.attribute('xmlns:cac',
        'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2');
    builder.attribute('xmlns:cbc',
        'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2');
    builder.attribute('xmlns:ext',
        'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2');

    builder.element('cbc:ProfileID', nest: data.profileID);
    builder.element('cbc:ID', nest: data.id);
    builder.element('cbc:UUID', nest: data.uuid);
    builder.element('cbc:IssueDate', nest: data.issueDate);
    builder.element('cbc:IssueTime', nest: data.issueTime);
    builder.element('cbc:InvoiceTypeCode', nest: () {
      builder.attribute('name', data.invoiceTypeName);
      builder.text(data.invoiceTypeCode);
    });
    builder.element('cbc:Note', nest: () {
      builder.attribute('languageID', 'ar');
      builder.text(data.note);
    });
    builder.element('cbc:DocumentCurrencyCode', nest: data.currencyCode);
    builder.element('cbc:TaxCurrencyCode', nest: data.taxCurrencyCode);

    // Supplier
    builder.element('cac:AccountingSupplierParty', nest: () {
      builder.element('cac:Party', nest: () {
        builder.element('cac:PartyIdentification', nest: () {
          builder.element('cbc:ID', nest: () {
            builder.attribute('schemeID', 'CRN');
            builder.text(data.supplier.companyID);
          });
        });
        builder.element('cac:PostalAddress', nest: () {
          builder.element('cbc:StreetName',
              nest: data.supplier.address.streetName);
          builder.element('cbc:BuildingNumber',
              nest: data.supplier.address.buildingNumber);
          builder.element('cbc:CitySubdivisionName',
              nest: data.supplier.address.citySubdivisionName);
          builder.element('cbc:CityName', nest: data.supplier.address.cityName);
          builder.element('cbc:PostalZone',
              nest: data.supplier.address.postalZone);
          builder.element('cac:Country', nest: () {
            builder.element('cbc:IdentificationCode',
                nest: data.supplier.address.countryCode);
          });
        });
        builder.element('cac:PartyTaxScheme', nest: () {
          builder.element('cbc:CompanyID', nest: data.supplier.companyID);
        });
        builder.element('cac:PartyLegalEntity', nest: () {
          builder.element('cbc:RegistrationName',
              nest: data.supplier.registrationName);
        });
      });
    });

    // Customer
    builder.element('cac:AccountingCustomerParty', nest: () {
      builder.element('cac:Party', nest: () {
        builder.element('cac:PostalAddress', nest: () {
          builder.element('cbc:StreetName',
              nest: data.customer.address.streetName);
          builder.element('cbc:BuildingNumber',
              nest: data.customer.address.buildingNumber);
          builder.element('cbc:CitySubdivisionName',
              nest: data.customer.address.citySubdivisionName);
          builder.element('cbc:CityName', nest: data.customer.address.cityName);
          builder.element('cbc:PostalZone',
              nest: data.customer.address.postalZone);
          builder.element('cac:Country', nest: () {
            builder.element('cbc:IdentificationCode',
                nest: data.customer.address.countryCode);
          });
        });
        builder.element('cac:PartyTaxScheme', nest: () {
          builder.element('cbc:CompanyID', nest: data.customer.companyID);
        });
        builder.element('cac:PartyLegalEntity', nest: () {
          builder.element('cbc:RegistrationName',
              nest: data.customer.registrationName);
        });
      });
    });

    // Invoice Lines
    for (var line in data.invoiceLines) {
      builder.element('cac:InvoiceLine', nest: () {
        builder.element('cbc:ID', nest: line.id);
        builder.element('cbc:InvoicedQuantity', nest: () {
          builder.attribute('unitCode', line.unitCode);
          builder.text(line.quantity);
        });
        builder.element('cbc:LineExtensionAmount',
            nest: line.lineExtensionAmount);
        builder.element('cac:Item', nest: () {
          builder.element('cbc:Name', nest: line.itemName);
        });
        builder.element('cac:TaxTotal', nest: () {
          builder.element('cbc:TaxAmount', nest: line.taxPercent);
        });
      });
    }

    // Totals
    builder.element('cac:TaxTotal', nest: () {
      builder.element('cbc:TaxAmount', nest: data.taxAmount);
    });
    builder.element('cac:LegalMonetaryTotal', nest: () {
      builder.element('cbc:PayableAmount', nest: data.totalAmount);
    });
  });

  final document = builder.buildDocument();
  return document.toXmlString(pretty: true);
}
