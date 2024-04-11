import 'package:flutter/material.dart';
import 'package:must_eat_place_app/view/everybody_restaurant.dart';
import 'package:must_eat_place_app/view/our_restaurant.dart';
import 'package:must_eat_place_app/view/own_restaurant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: const [
          OwnRestaurant(),
          OurRestaurant(),
          EverybodyRestaurant(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: TabBar(
          controller: tabController,
          indicatorPadding: const EdgeInsets.all(2),
          tabs: const [
            Tab(
              icon: Icon(Icons.food_bank,
                color: Colors.red,
              ),
              text: '나만의 맛집',
            ),
            Tab(
              icon: Icon(Icons.food_bank,
                color: Colors.blue,
              ),
              text: '우리만의 맛집',
            ),
            Tab(
              icon: Icon(Icons.food_bank,
                color: Colors.amber,
              ),
              text: '모두의 맛집',
            ),
          ]
        ),
      ),
    );
  }
} // End