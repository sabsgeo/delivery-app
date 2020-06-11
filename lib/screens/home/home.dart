import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:vegitabledelivery/assets/fresh_food_icons.dart';
import 'package:vegitabledelivery/assets/ready_to_cook_icons.dart';
import 'package:vegitabledelivery/assets/ready_to_eat_icons.dart';
import 'package:vegitabledelivery/models/fresh_green.dart';
import 'package:vegitabledelivery/services/freshgreen_database.dart';
import 'package:vegitabledelivery/services/image.dart';
import 'package:vegitabledelivery/shared/widgets/shopping_item_card.dart';
import 'package:vegitabledelivery/singletons/app_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatefulWidget {
  final bool userAuthenticated;
  Home(this.userAuthenticated);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Map<String, num> orderedItems = {};
  List<FreshGreen> fruits = [];
  TabController _tabController;
  final refStorage = FireStorageService();

  Future<Null> _refresh() async {
    List<FreshGreen> fruits =
        await FreshGreenDatabaseService().getAllFreshGreen(refreshData: true);
    setState(() {
      this.fruits = fruits;
    });
    return null;
  }

  Future homeInit() async {
    return true;
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.fruits = appData.freshGreen;
    return Container(
      color: Hexcolor('#DFE9AC'),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Hexcolor('#DFE9AC'),
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  primary: false,
                  floating: true,
                  leading: Container(),
                  backgroundColor: Hexcolor('#DFE9AC'),
                  snap: true,
                  pinned: false,
                  expandedHeight:70,
                  flexibleSpace: Container(
                    height: 70,
                    child: TabBar(
                      indicatorColor: Hexcolor('#97BE11'),
                      tabs: [
                        Tab(
                          icon:
                              Icon(FreshFood.basket, color: Hexcolor('#FFA820')),
                          child: Text(
                            'Fresh green',
                            style: TextStyle(
                                fontSize: 10.0, color: Hexcolor('#FFA820')),
                          ),
                        ),
                        Tab(
                          icon: Icon(ReadyToCook.baking,
                              color: Hexcolor('#FFA820')),
                          child: Text(
                            'Ready to cook',
                            style: TextStyle(
                                fontSize: 10.0, color: Hexcolor('#FFA820')),
                          ),
                        ),
                        Tab(
                          icon: Icon(ReadyToEat.ready_to_eat,
                              color: Hexcolor('#FFA820')),
                          child: Text(
                            'Ready to eat',
                            style: TextStyle(
                                fontSize: 10.0, color: Hexcolor('#FFA820')),
                          ),
                        ),
                      ],
                      controller: _tabController,
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                Container(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      itemCount: (this.fruits.length / 2).round(),
                      itemBuilder: (listContext, index) {
                        return Row(
                          children: <Widget>[
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: index * 2 + 1 > this.fruits.length
                                    ? Container()
                                    : ShoppingItemCard(
                                        index: index * 2,
                                        enableAddToCart:
                                            this.widget.userAuthenticated,
                                      )),
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: index * 2 + 2 > this.fruits.length
                                    ? Container()
                                    : ShoppingItemCard(
                                        index: index * 2 + 1,
                                        enableAddToCart:
                                            this.widget.userAuthenticated,
                                      )),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Icon(Icons.directions_bike),
                Icon(Icons.directions_bike),
              ],
              controller: _tabController,
            ),
          ),
        ),
      ),
    );
  }
}
