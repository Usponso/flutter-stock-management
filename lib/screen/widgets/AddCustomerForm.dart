import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management/screen/customerPage/CustomersPage.dart';
import 'package:stock_management/main.dart';
import 'package:stock_management/providers/CustomersProvider.dart';

class AddCustomerForm extends StatefulWidget {
  const AddCustomerForm({Key? key}) : super(key: key);

  @override
  State<AddCustomerForm> createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: AlertDialog(
      backgroundColor: Colors.deepPurple[50],
      icon: Icon(Icons.person, color: Colors.deepPurple[400]),
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Center(
          child: Text(
        "Ajouter un client",
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              /*key: _formKey,*/
              child: Consumer<CustomerProvider>(
                builder: (context, value, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) {
                            Provider.of<CustomerProvider>(context,
                                    listen: false)
                                .setData("customerName", value);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nom du fournisseur',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) {
                            Provider.of<CustomerProvider>(context,
                                    listen: false)
                                .setData("customerSiret", value);
                          },
                          decoration: InputDecoration(
                            labelText: 'SIRET',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) {
                            Provider.of<CustomerProvider>(context,
                                    listen: false)
                                .setData("customerPhoneNumber", value);
                          },
                          decoration: InputDecoration(
                            labelText: 'Numéro de téléphone',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<CustomerProvider>(context, listen: false).resetData();
            Navigator.pop(context);
          },
          child: Text("Annuler",
              style: TextStyle(
                  color: Colors.deepPurple[400], fontWeight: FontWeight.bold)),
        ),
        TextButton(
            onPressed: () {
              Provider.of<CustomerProvider>(context, listen: false)
                  .addCustomer();
              Navigator.pop(context);
            },
            child: Text(
              "Ajouter",
              style: TextStyle(
                  color: Colors.deepPurple[400], fontWeight: FontWeight.bold),
            )),
      ],
    ));
  }
}


