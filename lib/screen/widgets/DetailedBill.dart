import 'package:flutter/material.dart';
import 'package:stock_management/screen/widgets/Cards/AllTransactionsCard.dart';
import 'package:stock_management/screen/widgets/Cards/BillNumberAndDateCard.dart';
import 'Cards/CompanyCard.dart';

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
          title: Text('${widget.companyName} - Facture n°${widget.idBill}'),
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
                      onPressed: () {},
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
}
