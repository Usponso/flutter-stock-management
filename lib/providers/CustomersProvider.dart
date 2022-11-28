import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_management/constants.dart';
import '../modal/Customer.dart';

class CustomerProvider extends ChangeNotifier {
  String customerName = "";
  String customerSiret = "";
  String customerPhoneNumber = "";

  void setData(dataType, value) {
    switch (dataType) {
      case "customerName":
        {
          customerName = value;
        }
        break;

      case "customerSiret":
        {
          customerSiret = value;
        }
        break;

      case "customerPhoneNumber":
        {
          customerPhoneNumber = value;
        }
        break;
    }
  }

  void resetData() {
    customerName = "";
    customerSiret = "";
    customerPhoneNumber = "";
  }

  Future<void> addCustomer() async {
    Customer customer = Customer(
        companyName: customerName,
        siret: customerSiret,
        phoneNumber: customerPhoneNumber);
    try {
      await Dio().post('$API_URL/customers', data: customer);
      _customers.add(customer);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  List<Customer> _customers = [];
  String searchExpression = "";

  UnmodifiableListView<Customer> get customers =>
      UnmodifiableListView(_customers);

  Future<List<Customer>> getCustomers() async {
    _customers = [];
    try {
      var response = await Dio().get('$API_URL/customers');
      /*List<Customer> customersList =[];*/
      /*List<Customer> customersList = response.data.map((customer) => Customer.fromJson(customer)).toList() as List<Customer>;*/
      if (_customers.length == 0)
        response.data
            .forEach((customer) => _customers.add(Customer.fromJson(customer)));
      notifyListeners();

      return _customers;
    } catch (e) {
      print(e);
      return [];
    }
  }

  void changeSearchExpression(String newExpression){
    searchExpression = newExpression;
    notifyListeners();
  }

  List<Customer> getListFoundedCustomers(){
    List<Customer> foundedCustomers = [];
    _customers.forEach((customer) {
      if(customer.companyName.trim().toLowerCase().contains(searchExpression.trim().toLowerCase())) {
        foundedCustomers.add(customer);
      }
    });
    return foundedCustomers;
  }


}

