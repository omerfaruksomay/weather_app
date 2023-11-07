import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  //api key
  final _weatherService = WeatherService('87e209b7ec3ab3881764f9f9bf62265a');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get current city
    String cityName = await _weatherService.getCurrentCity();
    //get weather
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json';
    }
    switch (mainCondition.toLowerCase()) {
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'clouds':
        return 'assets/cloudy.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetch weather
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // City name
            Column(
              children: [
                const Icon(
                  Icons.location_city,
                  color: Colors.white,
                  size: 40,
                ),
                Text(
                  _weather?.cityName ?? "Loading city...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            Spacer(),

            // Temperature
            Text(
              '${_weather?.temperature.round().toString()} °C',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
