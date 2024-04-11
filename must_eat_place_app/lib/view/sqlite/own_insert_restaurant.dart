import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:must_eat_place_app/model/sqlite_restaurant.dart';
import 'package:must_eat_place_app/vm/database_handler.dart';

class OwnInsert extends StatefulWidget {
  const OwnInsert({super.key});

  @override
  State<OwnInsert> createState() => _OwnInsertState();
}

class _OwnInsertState extends State<OwnInsert> {

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController estimateController;
  late DatabaseHandler handler;

  late double lat;
  late double lng;
  
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    lat = 0;
    lng = 0;
    nameController = TextEditingController();
    phoneController = TextEditingController();
    estimateController = TextEditingController();
    handler = DatabaseHandler();
    checkLocationPermission();
  }

  checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    // 거절
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 다신 사용하지 않음
    if(permission == LocationPermission.deniedForever) {
      return;
    }

    // 앱을 사용 중 or 항상 허용 일때,
    if(permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      getCurrentLocation();
    }
  }

  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(
      // 정확도
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true).then((position) {
        lat = position.latitude;
        lng = position.longitude;
        setState(() {
          
        });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('맛집 추가'),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => getImageFromGallery(ImageSource.gallery), 
                  child: const Text('사진 추가'),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  color: Colors.grey,
                  child: Center(
                    child: imageFile == null
                    ? const Text('Image is not selected')
                    : Image.file(File(imageFile!.path)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('위도 : $lat'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('경도 : $lng'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: '이름',
                      border: OutlineInputBorder(
                        borderSide: BorderSide()
                      ),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: '전화',
                      border: OutlineInputBorder(
                        borderSide: BorderSide()
                      ),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: estimateController,
                    decoration: const InputDecoration(
                      labelText: '평가',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    maxLength: 50,
                    maxLines: null,
                    expands: false,
                    keyboardType: TextInputType.text,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if(imageFile == null) {
                      checkImage();
                      return;
                    }
                    insertAction();
                    _showDialog();
                  },
                  child: const Text('저장하기'),
                ),   
              ],
            ),
          ),
        ),
      )
    );
  }

  // --- Functions ---
    insertAction() async {
    await handler.insertRestaurant(
      Restaurant(
        name: nameController.text,
        phone: phoneController.text,
        lat: lat,
        lng: lng,
        image: await imageFile!.readAsBytes(),
        estimate: estimateController.text,
        initdate: DateTime.now().toString()
      )
    );
  }

  _showDialog() {
    Get.defaultDialog(
      title: '완료',
      middleText: '맛집 리스트가 추가되었습니다.',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          }, 
          child: const Text('OK'),
          ),
      ],
    );
  }

  checkImage() {
    Get.defaultDialog(
      title: '경고',
      middleText: '이미지를 선택해 주세요!',
      barrierDismissible: false,
      actions: [
        ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('확인')
        )
      ]
    );
  }

  getImageFromGallery(ImageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource);
    if(pickedFile == null) {
      imageFile = null;
      // return;
    }else {
      imageFile = XFile(pickedFile.path);
      setState(() {
        
      });
    }
  }

} // End