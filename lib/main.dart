import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di/injection_container.dart';
import 'presentation/pages/popular_people_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await setupDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB Popular People',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PopularPeoplePage(),
    );
  }
}
