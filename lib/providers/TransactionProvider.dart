import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_management/constants.dart';
import '../modal/Customer.dart';
import '../modal/TransactionToAddInBill.dart';

class TransactionProvider extends ChangeNotifier {
  int quantity = 1;
  bool buying = false;
  int deviceId = 0;
  int customerId = 0;
  int billId = 0;
  String deviceName = "";
  double devicePrice = 0;
  List<TransactionToAddInBill> allTransactions = [];
  double total = 0;
  bool displayButtonQuantityValidator = false;

  void setData(TransactionToAddInBill transaction) {
    quantity = transaction.quantity;
    buying = transaction.buying;
    deviceId = transaction.deviceId;
    deviceName = transaction.deviceName;
    devicePrice = transaction.devicePrice;
    total += transaction.devicePrice*transaction.quantity;
  }

  void setQuantity(int deviceId, int quantity) {
    allTransactions.forEach((transaction) => {
      if(transaction.deviceId == deviceId) {
        transaction.isDisplayQuantitySelectorInput = true,
        displayButtonQuantityValidator = true
      }
    });
  }

  void updateTotal() {
    total = 0;
    allTransactions.forEach((transaction) => {
      total += transaction.quantity*transaction.devicePrice
    });
    notifyListeners();
  }

  void setCustomerId(int id) {
    customerId = id;
  }

  void setActionType(bool isBuying) {
    buying = isBuying;
  }

  void resetData() {
    quantity = 0;
    buying = true;
    deviceId = 0;
    customerId = 0;
    billId = 0;
    deviceName = "";
    devicePrice = 0;
  }

  void addTransactionInBill(TransactionToAddInBill transaction) {
    allTransactions.add(transaction);
    notifyListeners();
  }

  void displayQuantitySelectorInput (int deviceId) {
    print(deviceId);
    allTransactions.forEach((transaction) => {
      if(transaction.deviceId == deviceId) {
        print('TEST'),
        transaction.isDisplayQuantitySelectorInput = true,
        displayButtonQuantityValidator = true
      }
    });
    notifyListeners();
  }

  Future<void> postTransactions() async {
    try {
      var billId = (await Dio().post('$API_URL/bills',
          data: {"date": DateTime.now().toLocal().toString()}));
      allTransactions.forEach((transaction) => {
            transaction.billId = billId.data,
            transaction.customerId = customerId
          });

      var transactionsToPost = [];

      allTransactions.forEach((transaction) => {
            transactionsToPost.add([
              transaction.quantity,
              transaction.buying,
              transaction.deviceId,
              transaction.customerId,
              transaction.billId
            ])
          });

      await Dio().post('$API_URL/transactions', data: transactionsToPost);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
