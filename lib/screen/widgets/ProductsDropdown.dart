import 'package:dio/dio.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management/modal/TransactionToAddInBill.dart';
import 'package:stock_management/providers/TransactionProvider.dart';

import '../../constants.dart';
import '../../modal/Customer.dart';
import '../../modal/Device.dart';
import '../../providers/CustomersProvider.dart';
import '../../providers/devicesProvider.dart';

class ProductsDropdown extends StatefulWidget {
  const ProductsDropdown({Key? key}) : super(key: key);


  Future<bool> getDevices(BuildContext context) async {
    await Provider.of<DevicesProvider>(context, listen: false)
        .getDevices(false);
    return true;
  }


  @override
  State<ProductsDropdown> createState() => _ProductsDropdownState();
}

class _ProductsDropdownState extends State<ProductsDropdown> {
  List<DropDownValueModel> dropDownListDevices = [];
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {


    return FutureBuilder(
        future: widget.getDevices(context),
        builder: (BuildContext context,
            AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Consumer2<DevicesProvider, TransactionProvider>(
                builder: (BuildContext context, deviceProvider, transactionProvider, Widget? child) {
                  Device scannedOrClickedDevice = Device(name: "", serialNumber: "", price: 0, stockQuantity: 0);
                  dropDownListDevices = [];

                  deviceProvider.devices.forEach((device) => {
                    dropDownListDevices.add(DropDownValueModel(
                        name: device.name, value: device.id)),
                  });

                  return Padding(
                      padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 170,
                                child: DropDownTextField(
                                  clearOption: true,
                                  textFieldFocusNode: textFieldFocusNode,
                                  searchFocusNode: searchFocusNode,
                                  // searchAutofocus: true,
                                  dropDownItemCount: 5,
                                  searchShowCursor: false,
                                  enableSearch: true,
                                  searchKeyboardType: TextInputType.text,
                                  dropDownList: dropDownListDevices,
                                  onChanged: (productDropDownValueModel) async {

                                    if(productDropDownValueModel != "") {
                                      scannedOrClickedDevice =
                                      await Provider.of<DevicesProvider>(context, listen: false)
                                          .getDeviceByScanOrClick(false, productDropDownValueModel.value.toString());
                                    }

                                  },
                                )),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.deepPurple[400],
                              ),
                              child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    TransactionToAddInBill transaction = TransactionToAddInBill(false, quantity: 1, buying: false, deviceId: scannedOrClickedDevice.id, deviceName: scannedOrClickedDevice.name, devicePrice: scannedOrClickedDevice.price);
                                    Provider.of<TransactionProvider>(context, listen: false).setData(transaction);
                                    Provider.of<TransactionProvider>(context, listen: false).addTransactionInBill(transaction);
                                  },
                                  icon: Icon(Icons.add)),
                            )

                          ]));
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
