import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favy_place/providers/user_places.dart';
import 'package:favy_place/screens/add_place.dart';
import 'package:favy_place/widgets/places_list.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(userPlacesNotifierProvider);
    //todo implement .select for my provider???

    void addNewPlace() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const AddPlaceScreen(),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Places"),
          actions: [
            IconButton(
              onPressed: () {
                addNewPlace();
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: PlacesList(
            places: places, //? can do the riverpod here or in places list
          ),
        ));
  }
}
