import 'dart:async';

import 'package:vegitabledelivery/models/fresh_green.dart';

class EachOrderedItem {
  int num;
  FreshGreen item;
  EachOrderedItem(this.item, this.num);

  Map<String, dynamic> toMap() {
    return {
      'price': item.price,
      'num': num,
      'group':item.group,
      'isVeg': item.isVeg,
      'name': item.name,
      'minQuantity': item.minQuantity,
      'uid': item.uid
    };
  }
}

class OrderedItems {
  Map<String, EachOrderedItem> orderedItems = {};
  StreamController<Map<String, EachOrderedItem>> _orderedItems =
      StreamController.broadcast();
  Stream<Map<String, EachOrderedItem>> get orderedItemsStream => _orderedItems.stream;

  void addNewItem(String key , EachOrderedItem value) {
    orderedItems[key] = value;
    this._orderedItems.sink.add(orderedItems);
  }

  void incrementExistingItem(String key) {
    orderedItems[key].num += 1;
    this._orderedItems.sink.add(orderedItems);
  }
  void decrementExistingItem(String key) {
    orderedItems[key].num -= 1;
    this._orderedItems.sink.add(orderedItems);
  }
  void removeAnItemCompletely(String key){
    orderedItems.remove(key);
    this._orderedItems.sink.add(orderedItems);
  }

  void clearAllData() {
    orderedItems = {};
    this._orderedItems.sink.add(orderedItems);
  }

  void dispose() {
    this._orderedItems.close();
  }
}
