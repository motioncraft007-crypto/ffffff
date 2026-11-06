import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Open-Meteo Weather',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ob-havo (Open-Meteo)'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchWeather(41.2646, 69.2163), // Toshkent koordinatalari
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Xatolik yuz berdi: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Ma\'lumot topilmadi'));
          }

          final currentWeather = snapshot.data!['current_weather'];
          final temp = currentWeather['temperature'];
          final windSpeed = currentWeather['windspeed'];

          return Center(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wb_sunny_rounded,
                      size: 64,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Toshkent',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$temp °C',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.air, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Shamol: $windSpeed km/h',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
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

  // Open-Meteo API'dan ma'lumot olish funksiyasi
  Future fetchWeather(double lat, double lon) async {
    final dio = Dio();
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true';

    final response = await dio.get(url);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Ob-havo ma\'lumotlarini yuklab bo\'lmadi');
    }
  }

}