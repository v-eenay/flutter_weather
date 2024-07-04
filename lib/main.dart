import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart';
import 'screens/weather_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.transparent,
        ),
        home: WeatherScreen(),
      ),
    );
  }
}
