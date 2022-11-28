import 'package:flutter/material.dart';
import 'package:stock_management/screen/widgets/AddButton.dart';
import 'package:stock_management/screen/widgets/CustomersList.dart';
import 'package:stock_management/screen/widgets/SearchInput.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: AddButton(),
        body: SingleChildScrollView(
          child: Column(
              children: [
                  SearchInput(),
                  CustomersList(),
              ],
          ),
        )
    );
  }
}
