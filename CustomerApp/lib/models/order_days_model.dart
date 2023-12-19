
class OrderDaysModel{

  String? days;
  int? quantity;
  OrderDaysModel(this.days,this.quantity);

  OrderDaysModel.fromJson(Map<String, dynamic>json)  {
   days=json['day'];
   quantity=json['quantity'];
  }
}

