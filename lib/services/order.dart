import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegitabledelivery/models/order.dart';
import 'package:vegitabledelivery/models/user.dart';
import 'package:vegitabledelivery/services/auth.dart';
import 'package:vegitabledelivery/singletons/app_data.dart';

class OrderItems {
  final CollectionReference orderCollection =
      Firestore.instance.collection('user_orders');
  final _auth = AuthService();
  OrderItems();
  Future completeOrder() async {
    User user = await _auth.user.first;
    await orderCollection.document().setData({
      'user': user.uid,
      'items': appData.orderedItems,
      'order_status': OrderStatus.AWAITING_CONFORMATION.toString(),
      'rating': -1,
      'ordered_time': DateTime.now().millisecondsSinceEpoch,
      'delivered_time': 0,
      'cancelled_time': 0,
      'address': appData.selectedAddress.getAllData()
    });
    appData.orderedItems = {};
  }

  Future<List<Order>> latestNOrders(int N) async {
    List<Order> finalData = [];
    User user = await _auth.user.first;
    QuerySnapshot tmpList = await orderCollection
        .where('user', isEqualTo: user.uid)
        .orderBy('ordered_time', descending: true)
        .limit(N)
        .getDocuments();
    tmpList.documents.forEach((DocumentSnapshot docSnapshot) {
      finalData.add(Order(
          id: docSnapshot.documentID,
          userUid: docSnapshot.data['user'],
          items: docSnapshot.data['items'],
          orderStatus: OrderStatus.values.firstWhere(
              (e) => e.toString() == docSnapshot.data['order_status']),
          rating: docSnapshot.data['rating'],
          deliveryTime: docSnapshot.data['delivered_time'],
          orderTime: docSnapshot.data['ordered_time'],
          cancelledTime: docSnapshot.data['cancelled_time']));
    });
    return finalData;
  }

  Future<Map<String,dynamic>> getOrder(String orderId) async {
    List<Order> finalData = [];
    User user = await _auth.user.first;
    DocumentSnapshot orderInfo = await orderCollection.document(orderId).get();
    return orderInfo.data;
  }

  Future rateOrder(String orderId, int rating, String feedback) async {
    await orderCollection.document(orderId).updateData({
      'rating': rating,
      'feedback': feedback
    });
  }

  Future cancelOrder(String orderId) async {
    await orderCollection.document(orderId).updateData({
      'order_status': OrderStatus.ORDER_CANCELLED.toString()
    });
  }
}
