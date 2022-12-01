import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management/screen/widgets/Cards/ProductCard.dart';
import '../../modal/Device.dart';
import '../../providers/devicesProvider.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage(
      {Key? key, required this.productId, required this.search})
      : super(key: key);

  final String productId;
  final bool search;

  @override
  Widget build(BuildContext context) {
    Future<List<Device>> scannedDevice =
        Provider.of<DevicesProvider>(context, listen: false)
            .getDeviceByScan(productId);
    return Scaffold(
        appBar: AppBar(
          title: search
              ? Text('Résultat de la recherche')
              : Text('Détails du produit'),
          backgroundColor: Colors.deepPurple[400],
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: FutureBuilder<List<Device>>(
            future: scannedDevice,
            builder:
                (BuildContext context, AsyncSnapshot<List<Device>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data?.length != 0) {
                  return ListView.builder(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        Device device = snapshot.data![index];
                        return ProductCard(device: device);
                      });
                } else {
                  return Center(
                      child: Text(
                          "Pas de produit correspondant à votre recherche : ID ${productId}"));
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
