import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:stock_management/providers/devicesProvider.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog(
      {Key? key,
      this.name = '',
      this.serialNumber = '',
      this.price = '',
      this.stockQuantity = ''})
      : super(key: key);

  String name, serialNumber, price, stockQuantity;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  String picture = "";
  String path = "";
  List<File> files = [];

  @override
  Widget build(BuildContext context) {
    Future<void> scanBarcodeNormal() async {
      String barcodeScanRes;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#ff0000', 'Annuler', true, ScanMode.BARCODE);
        widget.serialNumber = barcodeScanRes;
      } on PlatformException {
        barcodeScanRes = 'Failed to get platform version.';
      }
    }

    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: Colors.deepPurple[50],
        icon: Icon(Icons.devices, color: Colors.deepPurple[400]),
        insetPadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
            child: Text(
          "Ajouter un produit",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              picture.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          //to show image, you type like this.
                          File(path),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                        ),
                      ),
                    )
                  : Text(
                      "Aucune image",
                      style: TextStyle(fontSize: 15),
                    ),
              // getFilesWidgets(files),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: uploadPicture,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[400],
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text.rich(

                      TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.add), alignment: PlaceholderAlignment.middle),
                            TextSpan(text: '  Ajouter une photo')
                          ]),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (newText) {
                    widget.name = newText;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nom du produit",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                Expanded(
                child:TextField(
                  // TODO: TRYING TO MAKE IT DYNAMIC, THE TEXTFIELD ISNT REFRESHING WHEN SCANNING, IT NEEDS TO FOCUS ANOTHER INPUT
                      onChanged: (newText) {
                        widget.serialNumber = newText;
                      },
                      controller: TextEditingController(
                          text: widget.serialNumber,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Numéro de série",
                      ),
                    )),
                    IconButton(onPressed: ()=>scanBarcodeNormal(), icon: Icon(CupertinoIcons.barcode_viewfinder))
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(new RegExp('[A-Za-z]'))
                  ],
                  onChanged: (newText) {
                    widget.price = newText;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Prix du produit",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (newText) {
                    widget.stockQuantity = newText;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Quantité en stock",
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Annuler",
                style: TextStyle(
                    color: Colors.deepPurple[400], fontWeight: FontWeight.bold)),
          ),
          TextButton(
              onPressed: () {
                Provider.of<DevicesProvider>(context, listen: false)
                    .postDevice(widget.name, widget.serialNumber, widget.price, widget.stockQuantity, picture, path);
                Navigator.pop(context);
              },
              child: Text(
                "Ajouter",
                style: TextStyle(
                    color: Colors.deepPurple[400], fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Future<void> uploadPicture() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      // allowMultiple: true
    );
    if (result != null) {
      setState(() {
        // files = result.paths.map((path) => File(path!)).toList();
        picture = result.files.single.name!;
        path = result.files.single.path!;
      });
    } else {
      // User canceled the picker
      setState(() {
        picture = '';
        path = '';
      });
    }
  }
}
