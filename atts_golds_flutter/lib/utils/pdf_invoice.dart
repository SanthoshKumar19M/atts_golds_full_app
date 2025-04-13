import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import '../models/bill_model.dart';

class PDFInvoice {
  static Future<void> generateInvoice(List<BillItem> items, double totalAmount, String customer, String invoiceNumber) async {
    final pdf = pw.Document();

    // App Color Theme
    final headerColor = PdfColor.fromHex('#FFBF00'); // Amber
    final borderColor = PdfColor.fromHex('#1E1E1E'); // Dark for contrast

    // Current Date & Time
    String invoiceDate = DateFormat('dd-MMM-yyyy HH:mm a').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header Section
            pw.Container(
              alignment: pw.Alignment.center,
              padding: pw.EdgeInsets.symmetric(vertical: 15),
              decoration: pw.BoxDecoration(
                color: headerColor,
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Text(
                'ATTS Gold - Invoice',
                style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              ),
            ),
            pw.SizedBox(height: 15),

            // Customer and Invoice Info
            _buildInfoRow('Invoice.No      : ', invoiceNumber),
            _buildInfoRow('Customer        : ', customer),
            _buildInfoRow('Invoice Date    : ', invoiceDate),
            _buildInfoRow('GST Number   : ', '123AAA456BBB'),
            _buildInfoRow('Shop Location: ', 'Thanjavur, Tamil Nadu, 613006'),
            pw.SizedBox(height: 20),

            // Product Table
            pw.TableHelper.fromTextArray(
              context: context,
              border: pw.TableBorder.all(width: 1, color: borderColor),
              headerStyle: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: pw.BoxDecoration(color: headerColor),
              cellAlignment: pw.Alignment.centerLeft,
              columnWidths: {
                0: pw.IntrinsicColumnWidth(),
                1: pw.IntrinsicColumnWidth(),
                2: pw.IntrinsicColumnWidth(),
                3: pw.IntrinsicColumnWidth(),
                4: pw.IntrinsicColumnWidth(),
                5: pw.IntrinsicColumnWidth(),
              },
              headers: ['Product', 'Qty', 'Price', 'Tax%', 'Disc%', 'Total'],
              data: items.map((item) {
                final p = item.product;
                return [
                  p.name,
                  item.quantity.toString(),
                  p.price.toStringAsFixed(2),
                  p.tax.toString(),
                  p.discount.toString(),
                  item.totalPrice.toStringAsFixed(2),
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 20),

            // Total
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Total: ${totalAmount.toStringAsFixed(2)}",
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),

            // Footer
            pw.Divider(),
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(
                'Thank you, visit again!',
                style: pw.TextStyle(fontSize: 16, fontStyle: pw.FontStyle.italic),
              ),
            ),
            pw.SizedBox(height: 10),
          ],
        ),
      ),
    );

    // Save & Open
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/invoice.pdf");
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  // Info Row
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 1,
          child: pw.Text(
            label,
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            value,
            style: pw.TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
