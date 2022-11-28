import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:stock_management/service/customer-service.dart';

import '../../modal/Customer.dart';
import '../../providers/CustomersProvider.dart';
import '../../providers/SearchCustomersProvider.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({Key? key}) : super(key: key);


  Future<List<Customer>> getCustomers(BuildContext context) async {
    return await Provider.of<CustomerProvider>(context, listen: false).getCustomers();
  }

  /*Future<List<Customer>> getCustomersSearchList(BuildContext context) async {
    return await Provider.of<SearchCustomerProvider>(context, listen: false).getCustomersSearchList();
  }*/

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20) ,
        width: 300,
        child: Form(
            /*key: _formKey,*/
            child: FutureBuilder<List<Customer>>(
                future: widget.getCustomers(context),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Customer>> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Consumer<CustomerProvider> (builder: (context, value, child) {
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.search),
                              //value: fav.searchExpression
                              title: TextField(
                                onChanged: (value) {
                                  Provider.of<CustomerProvider>(context, listen: false).changeSearchExpression(value);
                                },
                                decoration: InputDecoration(
                                    hintText: 'Rechercher...', border: InputBorder.none),
                              ),
                            ),
                          );
                        },)
                    );

                    /*return Consumer2<CustomerProvider, SearchCustomerProvider>(builder:
                        (BuildContext context, customerProvider, searchProvider, Widget? child) {
                      return SearchField(
                        onSuggestionTap: (suggestion) {
                          customerProvider.changeCustomersList(suggestion.searchKey);
                        },
                        suggestions: searchProvider.customersSearchList
                            .map((customer) =>
                                SearchFieldListItem(customer.companyName))
                            .toList(),
                        *//*suggestionState: Suggestion.expand,
                        textInputAction: TextInputAction.next,*//*
                        hint: 'Rechercher...',
                        hasOverlay: false,
                        searchStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.8),
                        ),
                        validator: (x) {
                          if (!searchProvider.customersSearchList.contains(x) || x!.isEmpty) {
                            return 'Please Enter a valid State';
                          }
                          return null;
                        },
                        searchInputDecoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        maxSuggestionsInViewPort: 6,
                        itemHeight: 50,
                      );
                    });*/
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })));
  }
}
