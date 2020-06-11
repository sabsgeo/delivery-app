enum OrderStatus {
  AWAITING_CONFORMATION,
  ORDER_ACCEPTED,
  ORDER_DECLINED,
  ORDER_ON_THE_WAY,
  ORDER_DELIVERED,
  ORDER_CANCELLED
}

class Order {
  String userUid;
  Map<String, dynamic> items;
  OrderStatus orderStatus;
  int rating;
  int orderTime;
  int deliveryTime;
  int cancelledTime;
  String id;
  Order(
      {this.id,
      this.userUid,
      this.items,
      this.orderStatus,
      this.rating,
      this.orderTime,
      this.deliveryTime,
      this.cancelledTime});
}
