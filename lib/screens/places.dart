import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favy_place/providers/user_places.dart';
import 'package:favy_place/screens/add_place.dart';
import 'package:favy_place/widgets/places_list.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  //todo implement .select for my provider???

  late Future<void> _placesFuture;

  @override
  initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesNotifierProvider.notifier).loadPlaces();
  }

  void addNewPlace() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddPlaceScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesNotifierProvider);

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
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              (snapshot.connectionState == ConnectionState.waiting)
                  ? const Center(child: CircularProgressIndicator())
                  : PlacesList(
                      places:
                          userPlaces, //? can do the riverpod here or in places list
                    ),
        ),
      ),
    );
  }
}
