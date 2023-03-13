class TransactionToAddInBill {
  final int quantity;
  final bool buying;
  final int deviceId;
  late int customerId;
  late int billId;
  final String deviceName;
  final double devicePrice;
  bool isDisplayQuantitySelectorInput = false;

  TransactionToAddInBill(this.isDisplayQuantitySelectorInput, {required this.quantity, required this.buying, required this.deviceId, required this.deviceName, required this.devicePrice});

  TransactionToAddInBill.fromJson(Map<String, dynamic> json)
      :
        quantity = json['quantity'],
        buying = json['buying'],
        deviceId = json['device_id'],
        customerId = json['customer_id'],
        billId = json['bill_id'],
        deviceName = json['name'],
        devicePrice = json['price'];

  Map<String, dynamic> toJson() => {
    'quantity': quantity,
    'buying': buying,
    'device_id' : deviceId,
    'customer_id' : customerId,
    'bill_id' : billId,
    'name' : deviceName,
    'price' : devicePrice
  };


}