/* 
    Description : Firebase의 Model 
    Author 		  : 이대근
    Date 			  : 2024.04.11
*/

class FirebaseRestaurant{
  int? id; 
  String name; 
  String phone; 
  double lat; 
  double lng; 
  String image; 
  String estimate; 
  String initdate;

  FirebaseRestaurant({
    this.id,
    required this.name,
    required this.phone,
    required this.lat,
    required this.lng, 
    required this.image,
    required this.estimate,
    required this.initdate
    
  });

}