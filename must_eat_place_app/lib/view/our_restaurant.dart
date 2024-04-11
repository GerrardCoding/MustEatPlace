import 'package:flutter/material.dart';

class OurRestaurant extends StatefulWidget {
  const OurRestaurant({super.key});

  @override
  State<OurRestaurant> createState() => _OurRestaurantState();
}

class _OurRestaurantState extends State<OurRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나만의 맛집 리스트'),
      ),
    );
  }
}