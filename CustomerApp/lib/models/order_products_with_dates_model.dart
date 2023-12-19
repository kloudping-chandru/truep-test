import 'order_model.dart';

class OrderProductsWithDatesModel {
  String? date;
  List<OrderModel> orderModelList = [];

  OrderProductsWithDatesModel(this.date, this.orderModelList);
}