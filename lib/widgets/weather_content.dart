import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../models/weather_model.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherContent extends StatelessWidget {
  final WeatherProvider provider;
  final Color textColor;

  const WeatherContent({required this.provider, required this.textColor});

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading) {
      return _buildLoadingIndicator();
    } else if (provider.errorMessage.isNotEmpty) {
      return _buildErrorWidget(provider.errorMessage, textColor, context);
    } else if (provider.weather != null) {
      return _buildWeatherDetails(provider.weather!, textColor);
    } else {
      return _buildInitialText(textColor);
    }
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(
      String errorMessage, Color textColor, BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: textColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: textColor.withOpacity(0.7),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: GoogleFonts.playfairDisplay(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                color: textColor.withOpacity(0.7),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Retry fetching weather
                if (Provider.of<WeatherProvider>(context, listen: false)
                    .searchQuery
                    .isNotEmpty) {
                  Provider.of<WeatherProvider>(context, listen: false)
                      .fetchWeather(
                          Provider.of<WeatherProvider>(context, listen: false)
                              .searchQuery);
                }
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: textColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Try Again',
                style: GoogleFonts.lato(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialText(Color textColor) {
    return Center(
      child: Text(
        'Enter a city name to get weather information',
        style: GoogleFonts.lato(color: textColor, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildWeatherDetails(Weather weather, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          weather.cityName,
          style: GoogleFonts.playfairDisplay(
            color: textColor,
            fontSize: 42,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${weather.temperature.toStringAsFixed(1)}°',
          style: GoogleFonts.lato(
            color: textColor,
            fontSize: 84,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          weather.description,
          style: GoogleFonts.lato(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 60),
        _buildWeatherDetailsList(weather, textColor),
      ],
    );
  }

  Widget _buildWeatherDetailsList(Weather weather, Color textColor) {
    return Column(
      children: [
        _buildDetailRow('Feels like',
            '${weather.feelsLike.toStringAsFixed(1)}°', textColor),
        _buildDetailRow(
            'Min', '${weather.tempMin.toStringAsFixed(1)}°', textColor),
        _buildDetailRow(
            'Max', '${weather.tempMax.toStringAsFixed(1)}°', textColor),
        _buildDetailRow('Humidity', '${weather.humidity}%', textColor),
        _buildDetailRow('Wind', '${weather.windSpeed} m/s', textColor),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(
              color: textColor.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lato(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
