import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_management/screen/widgets/Cards/AllTransactionsCard.dart';
import 'package:stock_management/screen/widgets/Cards/BillNumberAndDateCard.dart';
import '../../modal/CustomerTransaction.dart';
import 'Cards/CompanyCard.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../service/customer-service.dart' as CustomerService;

class DetailedBill extends StatefulWidget {
  const DetailedBill(
      {Key? key,
      required this.id,
      required this.idBill,
      required this.companyName,
      required this.siret,
      required this.phoneNumber,
      required this.billDate,
      required this.totalBill})
      : super(key: key);
  final int id, idBill;
  final double totalBill;
  final String companyName, siret, phoneNumber, billDate;

  @override
  State<DetailedBill> createState() => _DetailedBillState();
}

class _DetailedBillState extends State<DetailedBill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.companyName} - Commande n°${widget.idBill}'),
          backgroundColor: Colors.deepPurple[400],
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CompanyCard(
                  companyName: widget.companyName,
                  siret: widget.siret,
                  phoneNumber: widget.phoneNumber),
              BillNumberAndDateCard(
                  billDate: widget.billDate, idBill: widget.idBill),
              AllTransactionsCard(
                  idCustomer: widget.id,
                  idBill: widget.idBill,
                  totalBill: widget.totalBill),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 300,
                  child: ElevatedButton.icon(
                      icon: Icon(Icons.download),
                      label: Text("Télécharger"),
                      onPressed: () async => {
                            _createPDF(
                                widget.id,
                                widget.companyName,
                                widget.siret,
                                widget.phoneNumber,
                                widget.idBill,
                                widget.billDate,
                                widget.totalBill)
                          },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple[400]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0))),
                      )))
            ],
          ),
        )));
  }

  Future<void> _createPDF(idCustomer, companyName, siret, phoneNumber, idBill,
      dateBill, totalBill) async {
    List<CustomerTransaction> customerTransactions =
        await CustomerService.getAllTransactionsByBillAndCustomer(
            idCustomer, idBill);

    //Create a new PDF document
    PdfDocument document = PdfDocument();

    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    // File fontFile = File('assets/fonts/Roboto-Regular.ttf');
    ByteData bytesF = await rootBundle.load('assets/fonts/Roboto-Medium.ttf');
    Uint8List fontBytes = bytesF.buffer.asUint8List(bytesF.offsetInBytes, bytesF.lengthInBytes);

    // PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.helvetica, 14);
    PdfFont subHeadingFont = PdfTrueTypeFont(fontBytes, 14);
    PdfBrush solidBrush = PdfSolidBrush(PdfColor(103, 80, 164));
    Rect bounds = Rect.fromLTWH(0, 150, graphics.clientSize.width, 30);

    var maxSize = [subHeadingFont.measureString(companyName).width,subHeadingFont.measureString('SIRET : ${siret}').width,subHeadingFont.measureString('Téléphone: ${phoneNumber}').width].reduce(max);

    graphics.drawString("My Company", subHeadingFont, bounds: Rect.fromLTWH(0, 20, 0, 0));
    graphics.drawString('SIRET : 123456987123', subHeadingFont,
        bounds: Rect.fromLTWH(0, 40, 0, 0));
    graphics.drawString('Téléphone: 0102030405', subHeadingFont,
        bounds: Rect.fromLTWH(0, 60, 0, 0));

    graphics.drawString(companyName, subHeadingFont, bounds: Rect.fromLTWH(graphics.clientSize.width - maxSize, 60, 0, 0));
    graphics.drawString('SIRET : ${siret}', subHeadingFont,
        bounds: Rect.fromLTWH(graphics.clientSize.width - maxSize, 80, 0, 0));
    graphics.drawString('Téléphone: ${phoneNumber}', subHeadingFont,
        bounds: Rect.fromLTWH(graphics.clientSize.width - maxSize, 100, 0, 0));

    //Draws a rectangle to place the heading in that region
    graphics.drawRectangle(brush: solidBrush, bounds: bounds);

    //Creates a text element to add the invoice number
    PdfTextElement element =
        PdfTextElement(text: 'FACTURE N°${idBill}', font: subHeadingFont);
    element.brush = PdfBrushes.white;

    //Draws the heading on the page
    PdfLayoutResult result = element.draw(page: page, bounds: Rect.fromLTWH(10, bounds.top + 8, 0, 0))!;

    //Use 'intl' package for date format.
    String currentDate = dateBill;

    //Measures the width of the text to place it in the correct location
    Size textSize = subHeadingFont.measureString(currentDate);

    //Draws the date by using drawString method
    graphics.drawString(currentDate, subHeadingFont,
        brush: element.brush,
        bounds: Offset(graphics.clientSize.width - textSize.width - 10,
                result.bounds.top) &
            Size(textSize.width + 2, 20));

    //Create a PdfGrid
    PdfGrid grid = PdfGrid();

    //Create a border
    PdfBorders border = PdfBorders(
        right: PdfPen(PdfColor(255, 255, 255), width: 0),
        left: PdfPen(PdfColor(255, 255, 255), width: 0),
        top: PdfPen(PdfColor(0, 0, 0), width: 1),
        bottom: PdfPen(PdfColor(0, 0, 0), width: 1),
    );

    //Add the columns to the grid
    grid.columns.add(count: 3);

    //Add header to the grid
    grid.headers.add(1);

    //Add the rows to the grid
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Nom du produit';
    header.cells[1].value = 'Quantité';
    grid.columns[1].width = 100;
    header.cells[2].value = 'Prix';
    grid.columns[2].width = 100;

    //Creates the header style
    PdfGridCellStyle headerStyle = PdfGridCellStyle();
    headerStyle.borders.all = PdfPen(PdfColor(103, 80, 164));
    headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(103, 80, 164));
    headerStyle.textBrush = PdfBrushes.white;
    headerStyle.font = PdfTrueTypeFont(fontBytes, 14,
        style: PdfFontStyle.regular);

    //Adds cell customizations
    for (int i = 0; i < header.cells.count; i++) {
      header.cells[i].stringFormat = PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle);
      header.cells[i].style = headerStyle;
    }

    //Add rows to grid
    PdfGridRow row;
    customerTransactions.forEach((CustomerTransaction ct) {
      row = grid.rows.add();
      row.cells[0].value = ct.productName;
      row.cells[1].value = ct.quantity.toString();
      row.cells[2].value = '${ct.price} €';
    });

    //Set padding for grid cells
    grid.style.cellPadding =
        PdfPaddings(left: 10, right: 10, top: 10, bottom: 10);

    //Creates the grid cell styles
    PdfGridCellStyle cellStyle = PdfGridCellStyle();
    cellStyle.font = PdfTrueTypeFont(fontBytes, 12);
    cellStyle.textBrush = PdfSolidBrush(PdfColor(103, 80, 164));

    //Adds cell customizations
    for (int i = 0; i < grid.rows.count; i++) {
      PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        row.cells[j].style = cellStyle;
        if (j == 0) {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.left,
              lineAlignment: PdfVerticalAlignment.middle);
        } else if (j == 1) {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.center,
              lineAlignment: PdfVerticalAlignment.middle);
        } else {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.right,
              lineAlignment: PdfVerticalAlignment.middle);
        }
      }
    }

    //Creates layout format settings to allow the table pagination
    PdfLayoutFormat layoutFormat =
        PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

    //Draws the grid to the PDF page
    PdfLayoutResult gridResult = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 20,
            graphics.clientSize.width, graphics.clientSize.height - 100),
        format: layoutFormat)!;

    var total = 'Total : ${totalBill} €';
    Size size = subHeadingFont.measureString(total);

    //Draws a rectangle to place the heading in that region
    graphics.drawRectangle(
        brush: solidBrush,
        bounds: Rect.fromLTWH(gridResult.bounds.right - size.width - 20,
            gridResult.bounds.bottom + 20, graphics.clientSize.width, 30));

    gridResult.page.graphics.drawString(total, subHeadingFont,
        brush: PdfSolidBrush(PdfColor(255, 255, 255)),
        bounds: Rect.fromLTWH(gridResult.bounds.right - size.width - 10,
            gridResult.bounds.bottom + 28, 0, 0));

    //Save the document
    List<int> bytes = await document.save();

    //Dispose the document
    document.dispose();

    //Get external storage directory
    final directory = await getApplicationSupportDirectory();

    //Get directory path
    final path = directory.path;

    //Create an empty file to write PDF data
    File file = File('$path/Output.pdf');

    //Write PDF data
    await file.writeAsBytes(bytes, flush: true);

    //Open the PDF document in mobile
    OpenFile.open('$path/Output.pdf');
  }
}
