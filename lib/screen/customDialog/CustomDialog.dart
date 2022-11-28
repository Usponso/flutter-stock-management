import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stock_management/providers/devicesProvider.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog(
      {Key? key,
      this.name = '',
      this.serialNumber = '',
      this.price = '',
      this.stockQuantity = ''})
      : super(key: key);

  String name, serialNumber, price, stockQuantity;

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (newText) {
                    name = newText;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nom du produit",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (newText) {
                    serialNumber = newText;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Numéro de série",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(new RegExp('[A-Za-z]'))
                  ],
                  onChanged: (newText) {
                    price = newText;
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
                    stockQuantity = newText;
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
                    .postDevice(name, serialNumber, price, stockQuantity);
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
}
