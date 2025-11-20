import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {  //ดึงข้อมูลสภาพอากาศจาก APIจากเว็บ https://openweathermap.org/
  static const String apiKey = '1184be4aea8db4657d5be58e70606924';

  static Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=th';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final body = json.decode(response.body);
      throw Exception(
          'รหัส: ${response.statusCode}, ข้อความ: ${body['message']}');
    }
  }
}
