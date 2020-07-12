import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:vegitabledelivery/shared/widgets/main_list.dart';

class AllOptions extends StatelessWidget {
  final bool userAuthenticated;
  final String userType;
  AllOptions(this.userAuthenticated, {this.userType});
  @override
  Widget build(BuildContext context) {
    List<String> list = [
      'Veggies',
      'fruits',
      'meat and eggs',
      'ready to cook',
      'reay to eat'
    ];
    return SafeArea(
      child: Scaffold(
        appBar: this.userType == 'ADMIN' ? AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 16.0,
              color: Colors.green[900],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('OPTIONS', style: TextStyle(fontSize: 16, color: Colors.green[900]),),
          backgroundColor: Colors.white,
        ):null,
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            this.userType == 'ADMIN' ? Container() : Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Container(
                  child: CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * .25,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: list
                    .map((item) => Container(
                          child: Center(child: Text(item, style: TextStyle(color: Colors.green[900]),)),
                          color: Colors.amber[500],
                        ))
                    .toList(),
              )),
            ),
            Expanded(
              child: ListView(
               children: <Widget>[
                  MainItemCard(
                    localImage: 'assets/vegetables.jpg',
                    onTap: () {
                      Navigator.of(context).pushNamed('/home', arguments: {
                        'itemToShow': 'VEGETABLES'
                      });
                    },
                    mainText: 'Vegetables',
                  ),
                  MainItemCard(
                    localImage: 'assets/fruits.jpg',
                    onTap: () {
                      Navigator.of(context).pushNamed('/home', arguments: {
                        'itemToShow': 'FRUITS'
                      });
                    },
                    mainText: 'Fruits',
                  ),
                  MainItemCard(
                    localImage: 'assets/egg_milk.jpg',
                    onTap: () {
                      print('I am here');
                    },
                    mainText: 'Egg and \ndiary products',
                  ),
                  MainItemCard(
                    localImage: 'assets/meat.jpg',
                    onTap: () {
                      print('I am here');
                    },
                    mainText: 'Meats',
                  ),
                 MainItemCard(
                   localImage: 'assets/ready_to_cook.png',
                   onTap: () {
                     print('I am here');
                   },
                   mainText: 'Ready to cook',
                 ),
                 MainItemCard(
                   localImage: 'assets/ready_to_eat.png',
                   onTap: () {
                     print('I am here');
                   },
                   mainText: 'Ready to eat',
                 )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
