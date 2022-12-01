import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management/providers/TransactionProvider.dart';

import '../../modal/Customer.dart';
import '../../providers/CustomersProvider.dart';

class CustomersDropdown extends StatefulWidget {
  const CustomersDropdown({Key? key}) : super(key: key);

  Future<List<Customer>> getCustomers(BuildContext context) async {
    return await Provider.of<CustomerProvider>(context, listen: false)
        .getCustomers();
  }

  @override
  State<CustomersDropdown> createState() => _CustomersDropdownState();
}

class _CustomersDropdownState extends State<CustomersDropdown> {
  List<DropDownValueModel> dropDownListCustomers = [];
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Customer?>>(
        future: widget.getCustomers(context),
        builder:
            (BuildContext context, AsyncSnapshot<List<Customer?>> snapshot) {
          if (snapshot.hasData) {
            return Consumer2<CustomerProvider, TransactionProvider>(builder:
                (BuildContext context, customerProvider, transactionProvider,
                    Widget? child) {
              dropDownListCustomers = [];
              customerProvider.customers.forEach((customer) => {
                    dropDownListCustomers.add(DropDownValueModel(
                        name: customer.companyName, value: customer.id))
                  });
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(style: TextStyle(fontSize: 18), "Client"),
                        Container(
                            width: 200,
                            child: DropDownTextField(
                              clearOption: true,
                              textFieldFocusNode: textFieldFocusNode,
                              searchFocusNode: searchFocusNode,
                              // searchAutofocus: true,
                              dropDownItemCount: 5,
                              searchShowCursor: false,
                              enableSearch: true,
                              searchKeyboardType: TextInputType.text,
                              dropDownList: dropDownListCustomers,
                              onChanged: (customerDropDownValueModel) {
                                if (customerDropDownValueModel != "") {
                                  Provider.of<TransactionProvider>(context, listen: false).setCustomerId(customerDropDownValueModel.value);
                                }
                              },
                            ))
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
