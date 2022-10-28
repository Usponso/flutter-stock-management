import 'package:flutter/material.dart';

import '../../../modal/CustomerTransaction.dart';
import '../../../service/customer-service.dart' as CustomerService;

class AllTransactionsCard extends StatefulWidget {
  const AllTransactionsCard(
      {Key? key,
      required this.idCustomer,
      required this.idBill,
      required this.totalBill})
      : super(key: key);
  final int idCustomer;
  final int idBill;
  final double totalBill;

  @override
  State<AllTransactionsCard> createState() => _AllTransactionsCardState();
}

class _AllTransactionsCardState extends State<AllTransactionsCard> {
  @override
  Widget build(BuildContext context) {
    final Future<List<CustomerTransaction>> customerTransactions =
        CustomerService.getAllTransactionsByBillAndCustomer(
            widget.idCustomer, widget.idBill);

    return Container(
      margin: EdgeInsets.only(top: 20),
      width: 343,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text("Produit",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Spacer(),
                      Container(
                        width: 80,
                        child: Text("Quantité",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        alignment: Alignment.center,
                      ),
                      Container(
                        child: Text("Prix",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        width: 60,
                        alignment: Alignment.center,
                      ),
                    ],
                  )),
              Row(
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 250,
                          width: 301,
                          child: FutureBuilder<List<CustomerTransaction>>(
                              future: customerTransactions,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<CustomerTransaction>>
                                      snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      itemCount: snapshot.data?.length,
                                      itemBuilder: (context, index) {
                                        CustomerTransaction transaction =
                                            snapshot.data![index];
                                        return Container(
                                            height: 25,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                      child: Text(
                                                          "${transaction.productName}"),
                                                      width: 100),
                                                  Spacer(),
                                                  Container(
                                                      child: Text(
                                                          "${transaction.quantity}"),
                                                      width: 80,
                                                      alignment:
                                                          Alignment.center),
                                                  Container(
                                                      child: Text(
                                                          "${transaction.price}"),
                                                      width: 60,
                                                      alignment:
                                                          Alignment.center),
                                                ]));
                                      });
                                } else {
                                  return CircularProgressIndicator();
                                }
                              }),
                        ),
                        Container(
                          width: 301,
                          child: Text("Total : ${widget.totalBill} €",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ])
                ],
              )
            ],
          )),
    );
  }
}
