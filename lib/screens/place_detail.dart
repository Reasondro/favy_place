import 'package:favy_place/models/place.dart';
import 'package:favy_place/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});
  final Place place;

  final String apiKey = "AIzaSyD0W-RcQ7FHd62Mz0qwOsSFyFSRroUgodA";

  String get locationImage {
    final lat = place.location.latitude;
    final lng = place.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lng=&zoom=16&size=600x150&maptype=roadmap&markers=color:yellow%7Clabel:%7C$lat,$lng&key=$apiKey';
  }

  @override
  Widget build(BuildContext context) {
    void openMap() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => MapScreen(
            location: place.location,
            isSelecting: false,
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(place.title),
        ),
        body: Stack(
          children: [
            Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        openMap();
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(locationImage),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(90, 0, 0, 0),
                              Color.fromARGB(139, 0, 0, 0)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        place.location.address,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    )
                  ],
                ))
          ],
        ));
  }
}
