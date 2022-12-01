import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management/screen/widgets/Cards/ProductCard.dart';

import '../../modal/Device.dart';
import '../../providers/devicesProvider.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage(
      {Key? key, required this.productIdOrSerialNumber, required this.scan})
      : super(key: key);

  final String productIdOrSerialNumber;
  final bool scan;

  @override
  Widget build(BuildContext context) {
    Future<Device> scannedOrClickedDevice =
        Provider.of<DevicesProvider>(context, listen: false)
            .getDeviceByScanOrClick(scan, productIdOrSerialNumber);

    return Scaffold(
        appBar: AppBar(
          title: scan
              ? Text('Résultat de la recherche')
              : Text('Détails du produit'),
          backgroundColor: Colors.deepPurple[400],
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: FutureBuilder<Device>(
            future: scannedOrClickedDevice,
            builder:
                (BuildContext context, AsyncSnapshot<Device> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return ListView.builder(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        Device device = snapshot.data!;
                        return ProductCard(device: device);
                      });
                } else {
                  return Center(
                      child: Text(
                          "Pas de produit correspondant à votre recherche : ID ${productIdOrSerialNumber}"));
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
