import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_weather/providers/weather_provider.dart';
import 'package:flutter_weather/screens/weather_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Weather App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Provider.of<WeatherProvider>(context).isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: WeatherScreen(),
    );
  }
}
