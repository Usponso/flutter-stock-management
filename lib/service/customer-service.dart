import 'package:dio/dio.dart';
import 'package:stock_management/constants.dart';
import 'package:stock_management/modal/CustomerBill.dart';
import 'package:stock_management/modal/CustomerTransaction.dart';
import '../modal/Customer.dart';

Future<List<Customer>> getCustomers() async {
  try {
    var response = await Dio().get('$API_URL/customers');
    List<Customer> customersList =[];
    /*List<Customer> customersList = response.data.map((customer) => Customer.fromJson(customer)).toList() as List<Customer>;*/
    response.data.forEach((customer) => customersList.add(Customer.fromJson(customer)));

    return customersList;
  } catch (e) {
      print(e);
      return [];
  }
}

Future<List<CustomerBill>> getBillsByCustomer(int customerId) async{
  try{
    var response = await Dio().get('$API_URL/customers/$customerId/bills');
    List<CustomerBill> customerBills = [];
    response.data.forEach((bill) => customerBills.add(CustomerBill.fromJson(bill)));

    return customerBills;
  } catch(e){
    print(e);
    return [];
  }
}

Future<List<CustomerTransaction>> getAllTransactionsByBillAndCustomer(int customerId, int billId) async {
  try {
    var response = await Dio().get('$API_URL/customers/$customerId/bills/$billId/transactions');
    List<CustomerTransaction> transactionsList =[];
    /*List<Customer> customersList = response.data.map((customer) => Customer.fromJson(customer)).toList() as List<Customer>;*/
    response.data.forEach((transaction) => transactionsList.add(CustomerTransaction.fromJson(transaction)));

    return transactionsList;
  } catch (e) {
    print(e);
    return [];
  }
}





