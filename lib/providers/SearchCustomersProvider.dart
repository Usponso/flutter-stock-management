/*
import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../modal/Customer.dart';

class SearchCustomerProvider extends ChangeNotifier {

  List<Customer> _customersSearchList = [];
  UnmodifiableListView<Customer> get customersSearchList => UnmodifiableListView(_customersSearchList);


  Future<List<Customer>> getCustomersSearchList() async {
    _customersSearchList = [];
    try {
      var response = await Dio().get('$API_URL/customers');
      response.data.forEach((customer) => _customersSearchList.add(Customer.fromJson(customer)));
      notifyListeners();
      return _customersSearchList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  void changeCustomersList(searchValue) {
    List<Customer> actualCustomers = _customersSearchList;
    _customersSearchList = [];
    actualCustomers.forEach((customer) => {
      if (customer.companyName.contains(searchValue)) _customersSearchList.add(customer)
    });
    notifyListeners();
  }

}*/
