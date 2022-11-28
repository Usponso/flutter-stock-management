import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management/screen/customerPage/CustomerDetailsPage.dart';
import '../../modal/Customer.dart';
import '../../providers/CustomersProvider.dart';

class CustomersList extends StatefulWidget {
  const CustomersList({Key? key}) : super(key: key);

  Future<List<Customer>> getCustomers(BuildContext context) async {
    return await Provider.of<CustomerProvider>(context, listen: false)
        .getCustomers();
  }

  @override
  State<CustomersList> createState() => _CustomersListState();
}

class _CustomersListState extends State<CustomersList> {
 
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<List<Customer>>(
            future: widget.getCustomers(context),
            builder: (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
              if (snapshot.hasData) {
                return Consumer<CustomerProvider>(
                  builder: (BuildContext context, provider, Widget? child) {
                    return ListView.builder(
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      itemCount: provider.getListFoundedCustomers().length,
                      itemBuilder: (BuildContext context, int index) {
                        Customer customer = provider.customers![index];
                        return Card(
                            color: Colors.grey[100],
                            elevation: 0,
                            margin: EdgeInsets.all(5),
                            child: ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CustomerDetailsPage(
                                            id: customer.id,
                                            companyName: customer.companyName,
                                            phoneNumber: customer.phoneNumber,
                                            siret: customer.siret,
                                          ))),
                              title: Text(customer.companyName),
                              leading: Icon(
                                Icons.person_outline_outlined,
                                color: Colors.black,
                              ),
                            ));
                      },
                    );
                  },
                );
              } else {
                return Text("Loading");
              }
            }));
  }
}
