import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '3573f68a46d124b31ee31103f60a07be';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    final response =
        await http.get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
