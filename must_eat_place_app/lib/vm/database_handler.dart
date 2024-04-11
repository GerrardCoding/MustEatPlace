import 'package:must_eat_place_app/model/sqlite_restaurant.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/* 
    Description : local db viewmodel
    Author  		: 이대근
    Date 		  	: 2024.04.10
*/

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    print(path);
    return openDatabase(
      join(path, 'restaurant.db'),
      onCreate: (db, version) async {
        await db.execute(
          'create table restaurant (id integer primary key autoincrement, name text, phone text, lat numeric(20), lng numeric(20), image blob, estimate text, initdate date)');
      },
      version: 1,
      
    );
  }

    Future<List<Restaurant>> queryRestaurant() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResults = 
    await db.rawQuery('select * from restaurant');
    return queryResults.map((e) => Restaurant.fromMap(e)).toList();
  }

  Future<int> insertRestaurant(Restaurant restaurant) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into restaurant(name, phone, lat, lng, image, estimate, initdate) values (?,?,?,?,?,?,?)',
      [restaurant.name, restaurant.phone, restaurant.lat, restaurant.lng, restaurant.image, restaurant.estimate, restaurant.initdate]
    );
    return result;
  }

    Future<void> updateRestaurant(Restaurant restaurant) async {
    final Database db = await initializeDB();
    await db.rawUpdate(
      'update restaurant set name=?, phone=?, lat=?, lng=?, image=?, estimate=? where id=?',
      [restaurant.name, restaurant.phone, restaurant.lat, restaurant.lng, restaurant.image, restaurant.estimate, restaurant.id]
    );
    
  }
  Future<void> deleteRestaurant(int id) async {
    final Database db = await initializeDB();
    await db.rawDelete(
      'delete from restaurant where id=?',
      [id]
    );
    
  }
}