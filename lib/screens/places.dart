import 'package:favy_place/screens/add_place.dart';
import 'package:favy_place/widgets/places_list.dart';
import 'package:flutter/material.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PlacesState();
  }
}

class _PlacesState extends State<PlacesScreen> {
  void _addPlace() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddPlaceScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        body: const PlacesList(places: [], ));
  }
}
