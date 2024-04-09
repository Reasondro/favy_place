import 'package:favy_place/providers/user_places.dart';
import 'package:favy_place/screens/add_place.dart';
import 'package:favy_place/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget
//TODO change to ConsumerWidget
{
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesState();
  }
}

class _PlacesState extends ConsumerState<PlacesScreen> {
  void _addPlace() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddPlaceScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(userPlacesNotifierProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Places"),
          actions: [
            IconButton(
              onPressed: () {
                _addPlace();
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: PlacesList(
          places: places, //? can do the riverpod here or in places list
        ));
  }
}
