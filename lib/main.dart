import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:favy_place/screens/places.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color.fromARGB(255, 135, 147, 255),
  // background: Color.fromARGB(255, 1, 11, 14),
);

final theme = ThemeData().copyWith(
    scaffoldBackgroundColor: colorScheme.background,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.zillaSlabTextTheme().copyWith(
      titleSmall: GoogleFonts.zillaSlab(
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.zillaSlab(
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.zillaSlab(
        fontWeight: FontWeight.bold,
      ),
    ),
    appBarTheme: AppBarTheme(
        color: colorScheme.primary, foregroundColor: colorScheme.onPrimary));

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Great Places',
      theme: theme,
      home: const PlacesScreen(),
    );
  }
}
