import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  bool _isDarkMode = false;
  String _errorMessage = '';

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  String get errorMessage => _errorMessage;

  get searchQuery => null;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Future<void> fetchWeather(String cityName) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      WeatherService weatherService = WeatherService();
      final weatherData = await weatherService.fetchWeather(cityName);
      if (weatherData.containsKey('cod') && weatherData['cod'] == 200) {
        _weather = Weather.fromJson(weatherData);
      } else {
        _errorMessage = 'Weather data not available for $cityName.';
      }
    } catch (e) {
      _errorMessage =
          'Failed to load weather data. Please check your connection and try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setErrorMessage(String s) {}
}
