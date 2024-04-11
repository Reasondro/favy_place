import 'dart:convert';

import 'package:favy_place/models/place.dart';
import 'package:favy_place/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onPickLocation});

  final void Function(PlaceLocation location) onPickLocation;
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;

  var _isGettingLocation = false;
  final String apiKey = "AIzaSyD0W-RcQ7FHd62Mz0qwOsSFyFSRroUgodA";

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lng=&zoom=16&size=700x900&maptype=roadmap&markers=color:yellow%7Clabel:X%7C$lat,$lng&key=$apiKey';
  }

  Future<void> _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey'); //* reverse geocoding
    final response =
        await http.get(url); //! need to put await here to get the body

    final resData = json.decode(response.body);

    final address = resData['results'][0]['formatted_address'];
    _pickedLocation = PlaceLocation(
        latitude: latitude, longitude: longitude, address: address);
    //* use ! ! here because we already know lat & lng won't be null
    setState(() {
      _isGettingLocation = false;
    });
    widget.onPickLocation(
        _pickedLocation!); //! needed for passing the location into the parent(not so parent) widget class PlacesScreen
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    //? easter egg, default location is Google HQ in SF
    // print(locationData.latitude);
    // print(locationData.longitude);
    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    if (latitude == null || longitude == null) {
      //todo show an error
      return;
    }
    _savePlace(
        latitude, longitude); //! final step needed to save the place itself
  }

  Future<void> _selectOnMap() async {
    //* void and Future<void> are basically the same, just to keep me mind that async always return a future
    final LatLng? selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );

    if (selectedLocation == null) {
      return;
    }
    print(
        "Latitude: ${selectedLocation.latitude} \nLongitude: ${selectedLocation.longitude}");
    _savePlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No location chosen",
      // textAlign: TextAlign.center, //? overwritten by container decoration
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(locationImage,
          fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.2))),
            height: 170,
            width: double.infinity,
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: () {
                  _getCurrentLocation();
                },
                icon: const Icon(Icons.location_on),
                label: const Text("Get Current Location")),
            TextButton.icon(
                onPressed: () {
                  _selectOnMap();
                },
                icon: const Icon(Icons.map),
                label: const Text("Select on Map"))
          ],
        )
      ],
    );
  }
}
