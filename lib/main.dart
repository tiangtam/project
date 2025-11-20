import 'package:flutter/material.dart';
import 'favorite_city_weather_page.dart';
//แสดงหน้า FavoriteCityWeatherPage เป็นหน้าแรกเมื่อเปิดเว็บ
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FavoriteCityWeatherPage(),
    );
  }
}
