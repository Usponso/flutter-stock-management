import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:stock_management/providers/devicesProvider.dart';
import 'package:stock_management/screen/searchResultPage/SearchResultPage.dart';
import '../customDialog/CustomDialog.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key,required this.user});

  final User user;

  Future<bool> getDevices(BuildContext context) async {
    await Provider.of<DevicesProvider>(context, listen: false).getDevices(false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> scanBarcodeNormal() async {
      String barcodeScanRes;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#ff6666', 'Annuler', true, ScanMode.BARCODE);
        Provider.of<DevicesProvider>(context, listen: false).barcodeScanned = barcodeScanRes;
        if (barcodeScanRes != '-1') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchResultPage(scan: true, productIdOrSerialNumber: barcodeScanRes)));
        }
      } on PlatformException {
        barcodeScanRes = 'Failed to get platform version.';
      }
    }

    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        //Shape modifiée sur le widget lui-même -> pas propre mais seule solution
        backgroundColor: Colors.deepPurple[400],
        closeButtonStyle: ExpandableFabCloseButtonStyle(
            backgroundColor: Colors.red),
        children: [
          FloatingActionButton(
            heroTag: 'scan',
            child: const Icon(CupertinoIcons.barcode_viewfinder),
            onPressed: () => scanBarcodeNormal(),
            backgroundColor: Colors.deepPurple[400],
          ),
          FloatingActionButton(
            heroTag: 'addProduct',
            child: const Icon(Icons.add),
            onPressed: () => createDevice(context),
            backgroundColor: Colors.deepPurple[400],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: Provider.of<DevicesProvider>(context, listen: false).refresh,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
              child: Card(
                color: Colors.deepPurple[400],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade500, width: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text('Bonjour, ${user.displayName} 👋', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: getDevices(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Consumer<DevicesProvider>(
                    builder: (context, provider, child) {
                      return ListView.builder(
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: provider.devices.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultPage(scan: false, productIdOrSerialNumber: provider.devices[index].id.toString())));
                              },
                              leading:
                                  Icon(Icons.devices, color: Colors.deepPurple[400]),
                              title: Text(
                                  "${provider.devices[index].name} - ${provider.devices[index].price} €"),
                              subtitle: Text(
                                  "Stock : ${provider.devices[index].stockQuantity}",
                                  style: TextStyle(
                                      color:
                                      provider.devices[index].stockQuantity <= 0
                                          ? Colors.red
                                          : (provider.devices[index].stockQuantity <= 5)
                                          ? Colors.yellow[800]
                                          : Colors.green[500]),
                              ),
                              trailing: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 44,
                                  minHeight: 44,
                                  maxWidth: 64,
                                  maxHeight: 64,
                                ),
                                child: Image.network(provider.devices[index].picture,
                                    fit: BoxFit.cover),
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.grey.shade500, width: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void createDevice(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog();
      },
    );
  }
}
