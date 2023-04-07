import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_management/modal/CustomerBill.dart';
import '../../service/customer-service.dart' as CustomerService;
import '../widgets/DetailedBill.dart';

class CustomerDetailsPage extends StatelessWidget {
  const CustomerDetailsPage(
      {Key? key,
      required this.id,
      required this.companyName,
      required this.siret,
      required this.phoneNumber})
      : super(key: key);

  final int id;
  final String companyName, siret, phoneNumber;

  @override
  Widget build(BuildContext context) {
    Future<List<CustomerBill>> bills = CustomerService.getBillsByCustomer(id);
    return Scaffold(
      appBar: AppBar(
        title: Text('$companyName'),
        backgroundColor: Colors.deepPurple[400],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Card(
            elevation: 0,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.grey.shade500, width: 1),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(20),
              leading: Icon(Icons.person, color: Colors.deepPurple[400]),
              title: Text(
                companyName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("SIRET : $siret \nTéléphone : $phoneNumber"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Divider(color: Colors.grey,),
          ),
          FutureBuilder<List<CustomerBill>>(
              future: bills,
              builder: (BuildContext context,
                  AsyncSnapshot<List<CustomerBill>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        CustomerBill bill = snapshot.data![index];
                        String formattedDate = DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(bill.date));
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(
                                color: Colors.grey.shade500, width: 1),
                          ),
                          child: ListTile(
                            onTap: ()=>{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedBill(id: id, idBill: bill.id, companyName: companyName, siret: siret, phoneNumber: phoneNumber, billDate: formattedDate, totalBill: bill.total)))
                            },
                            leading: Icon(Icons.shopping_cart,
                                color: Colors.deepPurple[400]),
                            title: Text(
                              'Commande #${bill.id}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(formattedDate),
                            trailing: Text(
                              '${bill.total} €',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      });
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      )),
    );
  }
}
