class CustomerTransaction {
  final String productName;
  final int quantity;
  final double price;

  CustomerTransaction({required this.productName, required this.quantity, required this.price});

  CustomerTransaction.fromJson(Map<String, dynamic> json)
      :
        productName = json['name'],
        quantity = json['quantity'],
        price = json['price'].toDouble();

  Map<String, dynamic> toJson() => {
    'name': productName,
    'quantity': quantity,
    'price' : price
  };


}