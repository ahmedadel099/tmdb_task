// lib/main.dart

import 'package:flutter/material.dart';
import 'core/di/injection_container.dart';
import 'presentation/pages/popular_people_page.dart';

void main() {
  setupDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB Popular People',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PopularPeoplePage(),
    );
  }
}
