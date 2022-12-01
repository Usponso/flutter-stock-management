import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:stock_management/service/customer-service.dart';

import '../../modal/Customer.dart';
import '../../providers/CustomersProvider.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({Key? key}) : super(key: key);

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Form(child:
        Container(
            width: MediaQuery.of(context).size.width,
            child: Consumer<CustomerProvider>(
              builder: (context, value, child) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.search),
                    //value: fav.searchExpression
                    title: TextField(
                      onChanged: (value) {
                        Provider.of<CustomerProvider>(context, listen: false)
                            .changeSearchExpression(value);
                      },
                      decoration: InputDecoration(
                          hintText: 'Rechercher...',
                          border: InputBorder.none),
                    ),
                  ),
                );
              },
            ))
        ));
  }
}
