import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/route_manager.dart';
import 'package:must_eat_place_app/model/firebase_restaurant.dart';
import 'package:must_eat_place_app/view/firebase/everybody_insert_restaurant.dart';

class EverybodyRestaurant extends StatefulWidget {
  const EverybodyRestaurant({super.key});

  @override
  State<EverybodyRestaurant> createState() => _EverybodyRestaurantState();
}

class _EverybodyRestaurantState extends State<EverybodyRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나만의 맛집 리스트'),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(const EverybodyInsert());
              },
              icon: const Icon(Icons.add_outlined))
        ],
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
                  .collection('musteatplace') //collection name made in firebase 
                  .orderBy('name',descending: false)
                  .snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator(),);
            }
            final documents = snapshot.data!.docs; 
            return ListView(
              children: documents.map((e) => _buildItemWidget(e)).toList(),
            );
          },
        ),
      ),
    );
  }
  // ---FUNCTIONS---
    Widget _buildItemWidget(QueryDocumentSnapshot<Object?> doc) {
      final restaurant = FirebaseRestaurant(
        name: doc['name'],
        phone: doc['phone'],
        estimate: doc['estimate'],
        initdate: doc['initdate'],
        lat: doc['lat'],
        lng: doc['lng'],
        image: doc['image'],
      );
      
      // Remove nested Slidable widgets
      return Slidable(
          // Start action pane for the map action
          startActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                  SlidableAction(
                      backgroundColor: Colors.orange,
                      icon: Icons.map_rounded,
                      label: 'Map',
                      onPressed: (context) {
                          // Get.to(
                          //     () => const Location(),
                          //     arguments: [
                          //         double.parse(doc['lat']),
                          //         double.parse(doc['lng']),
                          //     ],
                          // );
                      },
                  ),
              ],
          ),
          
          // End action pane for the delete action
          endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                  SlidableAction(
                      backgroundColor: Colors.red,
                      icon: Icons.delete_forever,
                      label: 'Delete',
                      onPressed: (context) async {
                          await FirebaseFirestore.instance
                          .collection('musteatplace')
                          .doc(doc.id)
                          .delete();
                      },
                  ),
              ],
          ),
          
          // Child widget
          child: GestureDetector(
              onTap: () {
                  // Get.to(const Update(), arguments: [
                  //     doc.id, // Document ID
                  //     doc['name'],
                  //     doc['phone'],
                  //     doc['estimate'],
                  //     doc['lat'],
                  //     doc['lng'],
                  //     doc['image'],
                  // ]);
              },
              
              // ListTile inside Card
              child: Card(
                  child: ListTile(
                      title: Row(
                          children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                      restaurant.image,
                                      width: 80,
                                  ),
                              ),
                              Text(
                                  "NAME : ${restaurant.name}\n\nPHONE : ${restaurant.phone}",
                              ),
                          ],
                      ),
                  ),
              ),
          ),
      );
  }
} // End