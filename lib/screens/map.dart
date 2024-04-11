import 'package:favy_place/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      this.location = const PlaceLocation(
          latitude: 37.522, longitude: -122.084, address: ""),
      this.isSelecting = true});

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? "Pick your Location" : "Your Location"),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_pickedPosition);
                //TODO exercise passing the variable using the onPicked stuff
              },
            )
        ],
      ),
      body: GoogleMap(
        onTap: (!widget.isSelecting)
            ? null
            : (position) {
                setState(() {
                  _pickedPosition = position;
                });
              },
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.location.latitude, widget.location.longitude),
            zoom: 16),
        markers: (_pickedPosition == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId("m1"),
                  position: _pickedPosition ??
                      LatLng(
                          widget.location.latitude, widget.location.longitude),
                  //* ?? means the program will use the R.H. side if the L.H is null, otherwise the L.H is the default one (ternary operator on crack)
                )
              },
      ),
    );
  }
}
