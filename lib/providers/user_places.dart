import 'package:favy_place/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class UserPlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() {
    return [];
  }

  void addPlace(String title, File image, PlaceLocation location) {
    final newPlace = Place(title: title, image: image, location: location);
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
