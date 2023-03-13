import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management/providers/TransactionProvider.dart';
import 'package:stock_management/screen/widgets/CustomersDropdown.dart';
import 'package:stock_management/screen/widgets/ProductsDropdown.dart';
import 'package:stock_management/screen/widgets/orderRadioInput.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    Provider
        .of<TransactionProvider>(context, listen: false)
        .allTransactions =
    [];
    Provider
        .of<TransactionProvider>(context, listen: false)
        .total = 0;

    final TextEditingController quantityController = TextEditingController();

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      quantityController.dispose();
      super.dispose();
    }

    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              OrderRadioInput(),
              CustomersDropdown(),
              ProductsDropdown(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                              height: 40,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Container(
                                    child: Text("Produit",
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                width: MediaQuery.of(
                                    context)
                                    .size
                                    .width *
                                    0.3,
                              ),
                              Spacer(),
                              Container(
                                width: MediaQuery.of(
                                    context)
                                    .size
                                    .width *
                                    0.2,
                                child: Text("Quantité",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                    alignment: Alignment.center,
                                  ),
                                  Container(
                                    child: Text("Prix",
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                width: MediaQuery.of(
                                    context)
                                    .size
                                    .width *
                                    0.2,
                                alignment: Alignment.center,
                              ),
                            ],
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(children: [
                            SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: Consumer<TransactionProvider>(
                                  builder: (BuildContext context,
                                      transactionProvider, Widget? child) {
                                    return ListView.builder(
                                        itemCount: transactionProvider
                                            .allTransactions.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              height: 25,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Container(
                                                            child: Text(
                                                                "${transactionProvider
                                                                    .allTransactions[index]
                                                                    .deviceName}"),
                                                            width: MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width *
                                                                0.2),
                                                        Spacer(),
                                                        ExpandTapWidget(
                                                          tapPadding:
                                                          EdgeInsets.all(25.0),
                                                          onTap: () {
                                                            transactionProvider
                                                                .displayQuantitySelectorInput(
                                                                transactionProvider
                                                                    .allTransactions[
                                                                index]
                                                                    .deviceId);

                                                            print(
                                                                transactionProvider
                                                                    .allTransactions[
                                                                index]
                                                                    .isDisplayQuantitySelectorInput);
                                                          },
                                                          child: Container(
                                                              child: showWidget(
                                                                  transactionProvider
                                                                      .allTransactions[
                                                                  index]
                                                                      .isDisplayQuantitySelectorInput,
                                                                  quantityController,
                                                                  transactionProvider
                                                                      .allTransactions[index]
                                                                      .quantity),
                                                              width: MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .width *
                                                                  0.2,
                                                              alignment:
                                                              Alignment.center),
                                                        ),
                                                        Container(
                                                            child: Text(
                                                                "${transactionProvider
                                                                    .allTransactions[index]
                                                                    .devicePrice}"),
                                                            width: MediaQuery
                                                                .of(
                                                                context)
                                                                .size
                                                                .width *
                                                                0.2,
                                                            alignment:
                                                            Alignment.center),
                                                      ]));
                                            });
                                      },
                                    )),
                                Consumer<TransactionProvider>(builder:
                                    (BuildContext context, transactionProvider,
                                    Widget? child) {

                                  return Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Text(
                                        "Total : ${transactionProvider
                                            .total} €",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  );
                                })
                              ]))
                        ],
                      )),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 300,
                  child: ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      label: Text("Enregistrer"),
                      onPressed: () async {
                        await Provider.of<TransactionProvider>(context,
                            listen: false)
                            .postTransactions();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurple[400]),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0))),
                      )))
            ],
          ),
        ));
  }
}

  showWidget(bool isDisplayQuantitySelectorInput,
      TextEditingController quantityController, int quantity) {
    if (isDisplayQuantitySelectorInput) {
      return TextField(
          controller:
          quantityController);
    } else {
      return Text(
          "${quantity}");
    }
  }
