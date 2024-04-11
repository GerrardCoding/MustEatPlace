import 'dart:typed_data';

class Restaurant{
  int? id; 
  String name; 
  String phone; 
  double lat; 
  double lng; 
  Uint8List image; 
  String estimate; 
  String initdate;

  Restaurant({
    this.id,
    required this.name,
    required this.phone,
    required this.lat,
    required this.lng, 
    required this.image,
    required this.estimate,
    required this.initdate
    
  });

  Restaurant.fromMap(Map<String, dynamic> res)
    : id = res['id'],
      name = res['name'],
      phone = res['phone'],
      lat = res['lat'],
      lng = res['lng'],
      image = res['image'],
      estimate = res['estimate'],
      initdate = res['initdate'];
      
}