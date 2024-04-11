import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:must_eat_place_app/view/sqlite/own_map.dart';
import 'package:must_eat_place_app/vm/database_handler.dart';

import 'sqlite/own_insert_restaurant.dart';
import 'sqlite/own_update_restaurant.dart';

/* 
  Description : Own Restaurant List
                appBar : actions -> Add List
                body : onTap -> See location
                      slidable -> Update & Delete
  Author 	  	: 이대근
  Date 		  	: 2024.04.10
*/

class OwnRestaurant extends StatefulWidget {
  const OwnRestaurant({super.key});

  @override
  State<OwnRestaurant> createState() => _OwnRestaurantState();
}

class _OwnRestaurantState extends State<OwnRestaurant> {

  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나만의 맛집 리스트'),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const OwnInsert())!
                    .then((value) => reloadData());
              },
              icon: const Icon(Icons.add_outlined))
        ],
      ),
      body: FutureBuilder(
        future: handler.queryRestaurant(),
        builder:(context, snapshot) {
          if(snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Get.to(const OwnUpdate(), arguments: snapshot.data![index])!.then((value) => setState(() {}));
                        },
                        icon: Icons.edit,
                        label: '수정하기',
                        backgroundColor: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: '삭제',
                        onPressed: (id) {
                          selectDelete(snapshot.data![index].id);
                        },
                      ),
                    ]),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                        () => const OwnMap(),
                        arguments: [
                          snapshot.data![index].lat,
                          snapshot.data![index].lng,
                        ]
                      );
                    },
                      child: Card(
                        child: Row(
                          children: [
                            Image.memory(
                              snapshot.data![index].image,
                              width: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '명칭 : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(snapshot.data![index].name)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        '전화번호 : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(snapshot.data![index].phone)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        '등록 날짜 : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(snapshot.data![index].initdate.substring(0,10))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      )
    );
  }

  // --- Functions ---
  reloadData() {
    handler.queryRestaurant();
    setState(() {});
  }



  selectDelete(id) {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoActionSheet(
        title: const Text('경고'),
        message: const Text('선택한 항목을 삭제 하시겠습니까?'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              handler.deleteRestaurant(id);
              setState(() {});
              Get.back();
            },
            child: const Text('삭제'),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Get.back(),
          child: const Text('Cancle'),
        ),
      ),
    );
  }

} // End