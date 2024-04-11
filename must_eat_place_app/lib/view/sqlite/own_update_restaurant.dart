import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:must_eat_place_app/model/sqlite_restaurant.dart';
import 'package:must_eat_place_app/vm/database_handler.dart';

class OwnUpdate extends StatefulWidget {
  const OwnUpdate({super.key});

  @override
  State<OwnUpdate> createState() => _OwnUpdateState();
}

class _OwnUpdateState extends State<OwnUpdate> {

  Restaurant argument = Get.arguments;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController estimateController;
  late DatabaseHandler handler;
  late double lat;
  late double lng;

  ImagePicker picker = ImagePicker();
  XFile? imageFile;


  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    estimateController = TextEditingController();
    handler = DatabaseHandler();

    alreadyExistData();
  }

  alreadyExistData() {
    nameController.text = argument.name;
    phoneController.text = argument.phone;
    estimateController.text = argument.estimate;

    lat = argument.lat;
    lng = argument.lng;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('맛집 수정'),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => getImageFromGallery(ImageSource.gallery), 
                  child: const Text('사진 변경'),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  color: Colors.grey,
                  child: Center(
                    child: imageFile == null
                    ? Image.memory(argument.image)
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
                    _showDialog();
                  },
                  child: const Text('수정하기'),
                ),   
              ],
            ),
          ),
        ),
      )
    );
  }

  // --- Functions ---
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

  getImageFromGallery(imageSource) async {
  final XFile? pickedFile = await picker.pickImage(source: imageSource);
  if(pickedFile == null) {
    imageFile = null;
  }
  else {
    imageFile = XFile(pickedFile.path);
  }
  setState(() {});
}

  _showDialog() {
     Get.defaultDialog(
      title: '확인',
      middleText: '정말로 수정하시겠습니까?',
      actions: [
        ElevatedButton(
          onPressed: () async {
            await handler.updateRestaurant(
              Restaurant(
                id: argument.id,
                name: nameController.text,
                phone: phoneController.text,
                lat: lat,
                lng: lng,
                image: imageFile == null ? argument.image : await imageFile!.readAsBytes(),
                estimate: estimateController.text,
                initdate: DateTime.now().toString()
              )
            );
            Get.back();
            updateDialog();
          },
          child: const Text('확인')
        ),
        ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('취소')
        ),
      ]
    );
  }

  updateDialog() {
    Get.defaultDialog(
      title: '완료',
      middleText: '맛집 리스트가 수정되었습니다.',
      actions: [
        ElevatedButton(
          onPressed: () async {
            Get.back();
            Get.back();
          },
          child: const Text('확인')
        )
      ]
    );
  }

} // End