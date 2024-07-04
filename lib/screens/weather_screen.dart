import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/weather_model.dart';
import '../providers/weather_provider.dart';

class WeatherScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  WeatherScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Weather App', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6, color: Colors.black),
            onPressed: () {
              Provider.of<WeatherProvider>(context, listen: false)
                  .toggleTheme();
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(context),
          Column(
            children: [
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSearchInput(context),
              ),
              Expanded(
                child: Consumer<WeatherProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return _buildLoadingIndicator();
                    } else if (provider.errorMessage.isNotEmpty) {
                      return _buildErrorText(provider.errorMessage);
                    } else if (provider.weather == null) {
                      return _buildInitialText();
                    } else {
                      return _buildWeatherInfo(provider.weather!);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    final isDarkMode = Provider.of<WeatherProvider>(context).isDarkMode;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [const Color(0xFF1A1A2E), const Color(0xFF34314C)]
              : [const Color(0xFF64B5F6), const Color(0xFFBBDEFB)],
        ),
      ),
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return TextField(
      controller: _controller,
      style: const TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        hintText: 'Enter City Name',
        hintStyle: TextStyle(color: Colors.grey.shade600),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () async {
            if (_controller.text.isNotEmpty) {
              await Provider.of<WeatherProvider>(context, listen: false)
                  .fetchWeather(_controller.text);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: SpinKitCircle(
        color: Colors.black,
        size: 50.0,
      ),
    );
  }

  Widget _buildErrorText(String errorMessage) {
    return Center(
      child: Text(
        errorMessage,
        style: const TextStyle(color: Colors.red, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInitialText() {
    return const Center(
      child: Text(
        'Search for a city to see the weather.',
        style: TextStyle(color: Colors.black, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildWeatherInfo(Weather weather) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weather.cityName,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              '${weather.temperature.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 48, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              weather.description,
              style: const TextStyle(fontSize: 24, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Image.network(
              'http://openweathermap.org/img/wn/${weather.icon}@2x.png',
              scale: 1.5,
            ),
            const SizedBox(height: 20),
            _buildWeatherDetails(weather),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetails(Weather weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem(
            'Feels Like', '${weather.feelsLike.toStringAsFixed(1)}°C'),
        _buildDetailItem('Min Temp', '${weather.tempMin.toStringAsFixed(1)}°C'),
        _buildDetailItem('Max Temp', '${weather.tempMax.toStringAsFixed(1)}°C'),
        _buildDetailItem('Pressure', '${weather.pressure} hPa'),
        _buildDetailItem('Humidity', '${weather.humidity}%'),
        _buildDetailItem('Wind Speed', '${weather.windSpeed} m/s'),
        _buildDetailItem(
          'Sunrise',
          DateTime.fromMillisecondsSinceEpoch(weather.sunrise * 1000)
              .toLocal()
              .toIso8601String()
              .substring(11, 16),
        ),
        _buildDetailItem(
          'Sunset',
          DateTime.fromMillisecondsSinceEpoch(weather.sunset * 1000)
              .toLocal()
              .toIso8601String()
              .substring(11, 16),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 16, color: Colors.black)),
          Text(value,
              style: const TextStyle(fontSize: 16, color: Colors.black)),
        ],
      ),
    );
  }
}
