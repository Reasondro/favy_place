import 'package:favy_place/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final String dbPath = await sql.getDatabasesPath();
  final Database db = await sql.openDatabase(p.join(dbPath, 'places.db'),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, latitude REAL, longitude REAL, address TEXT)');
  },
      version:
          1 //? best practice is to change the version everytime we edit the table
      );
  return db;
}

class UserPlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() {
    return [];
  }

  Future<void> loadPlaces() async {
    final Database db = await _getDatabase();
    final data = await db.query('user_places');

    final List<Place> places = data
        .map((row) => Place(
              id: row['id'] as String,
              title: row['title'] as String,
              image: File(row['image'] as String),
              location: PlaceLocation(
                latitude: row['latitude'] as double,
                longitude: row['longitude'] as double,
                address: row['address'] as String,
              ),
            ))
        .toList();
    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    //* directory shenanigans below are basically for saving the image locally on the device

    final Directory appDir = await syspaths
        .getApplicationDocumentsDirectory(); //* getting the device user save folder
    final String filename = p.basename(image.path); //* getting the file name
    final File copiedImage = await image.copy(
        "${appDir.path}/$filename"); //* copy the OG file into the device folder which we got previously

    final newPlace =
        Place(title: title, image: copiedImage, location: location);

    final db =
        await _getDatabase(); //? making the database / or rather getting it

    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'latitude': newPlace.location.latitude,
      'longitude': newPlace.location.longitude,
      'address': newPlace.location.address
    });

    state = [
      newPlace,
      ...state
    ]; //? ORDER MATTERS, <- this version put the new place as the first of the list
    // state = [
    //   ...state,
    //   newPlace
    // ]; //? <- this version put the new place as the last of the list
  }
}

final userPlacesNotifierProvider =
    NotifierProvider<UserPlacesNotifier, List<Place>>(
  () => UserPlacesNotifier(),
);
