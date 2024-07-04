import 'package:flutter/material.dart';
import 'package:flutter_weather/models/weather_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_content.dart';
import '../widgets/search_input.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Weather App',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6,
                color: Theme.of(context).iconTheme.color),
            onPressed: () {
              Provider.of<WeatherProvider>(context, listen: false)
                  .toggleDarkMode();
            },
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          final weather = provider.weather;
          final isDarkMode = provider.isDarkMode;
          final backgroundColor = _getBackgroundColor(weather, isDarkMode);
          final textColor = backgroundColor.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: backgroundColor,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    SearchInput(
                        controller: _controller,
                        onPressed: () {
                          _handleSearch(context);
                        }),
                    const SizedBox(height: 60),
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: WeatherContent(
                            provider: provider, textColor: textColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getBackgroundColor(Weather? weather, bool isDarkMode) {
    if (weather == null) {
      return isDarkMode ? const Color(0xFF1A1A2E) : const Color(0xFFF0F0F5);
    }

    if (isDarkMode) {
      switch (weather.description.toLowerCase()) {
        case 'clear sky':
          return const Color(0xFF1A1A2E);
        case 'few clouds':
        case 'scattered clouds':
        case 'broken clouds':
          return const Color(0xFF16213E);
        case 'shower rain':
        case 'rain':
          return const Color(0xFF1A1A2C);
        case 'thunderstorm':
          return const Color(0xFF0F3460);
        case 'snow':
          return const Color(0xFF2C3E50);
        case 'mist':
          return const Color(0xFF34495E);
        default:
          return const Color(0xFF121212);
      }
    } else {
      switch (weather.description.toLowerCase()) {
        case 'clear sky':
          return const Color(0xFFF0F8FF);
        case 'few clouds':
        case 'scattered clouds':
        case 'broken clouds':
          return const Color(0xFFF5F5F5);
        case 'shower rain':
        case 'rain':
          return const Color(0xFFE3F2FD);
        case 'thunderstorm':
          return const Color(0xFFECEFF1);
        case 'snow':
          return const Color(0xFFFAFAFA);
        case 'mist':
          return const Color(0xFFF0F4F8);
        default:
          return const Color(0xFFF0F0F5);
      }
    }
  }

  void _handleSearch(BuildContext context) async {
    if (_controller.text.isNotEmpty) {
      _animationController.reset();
      _animationController.forward();
      try {
        await Provider.of<WeatherProvider>(context, listen: false)
            .fetchWeather(_controller.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching weather: $e')),
        );
      }
    }
  }
}
