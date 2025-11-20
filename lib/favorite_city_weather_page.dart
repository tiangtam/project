import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'weather_dialog.dart';

class FavoriteCityWeatherPage extends StatefulWidget {//ดึงชื่อเมืองจากTextFieldเช็คถ้าไม่ว่างและไม่ซ้ำเพิ่มลงในfavorite
  const FavoriteCityWeatherPage({super.key});

  @override
  State<FavoriteCityWeatherPage> createState() =>
      _FavoriteCityWeatherPageState();
}

class _FavoriteCityWeatherPageState extends State<FavoriteCityWeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  final List<String> _favoriteCities = [];

  void _addFavoriteCity() {                    
    final city = _cityController.text.trim();
    if (city.isNotEmpty && !_favoriteCities.contains(city)) {
      setState(() => _favoriteCities.add(city));
    }
  }

  Future<void> _showWeatherDialog() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) return;

    try {
      final data = await WeatherService.fetchWeather(city);
      final main = data['main'];
      final weather = data['weather'][0];

      showDialog(
        context: context,
        builder: (_) => WeatherDialog(
          city: city,
          temp: main['temp'].toDouble(),
          humidity: main['humidity'],
          description: weather['description'],
        ),
      );
    } catch (e) {
      _showError('$e');
    }
  }

  void _showError(String msg) { //method เวลาerror
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('เกิดข้อผิดพลาด'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _removeFavoriteCity(int index) {
    setState(() => _favoriteCities.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {  //UIหลัก appbar etc.
    return Scaffold(
      appBar: AppBar(title: const Text('สภาพอากาศเมืองโปรด')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputSection(),
            const SizedBox(height: 24),
            const Text(
              'เมืองโปรดและสภาพอากาศ:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildFavoriteList()),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {  //ส่วนรับinput
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'กรอกชื่อเมือง (ภาษาอังกฤษ เช่น Bangkok)',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _cityController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'ชื่อเมือง',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _showWeatherDialog,
                child: const Text('ดูสภาพอากาศ'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: _addFavoriteCity,
                child: const Text('บันทึกเมืองโปรด'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFavoriteList() {  //แสดงfavoriteพร้อมอากาศของแต่ละเมือง
    if (_favoriteCities.isEmpty) {
      return const Center(
        child: Text('ยังไม่มีเมืองโปรด', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      itemCount: _favoriteCities.length,
      itemBuilder: (context, index) {
        final city = _favoriteCities[index];

        return Dismissible(
          key: ValueKey(city),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => _removeFavoriteCity(index),
          child: Card(
            child: ListTile(
              title: Text(city),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeFavoriteCity(index),
              ),
              subtitle: FutureBuilder(
                future: WeatherService.fetchWeather(city),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('กำลังโหลด...');
                  }
                  if (snapshot.hasError) {
                    return Text('ผิดพลาด: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red));
                  }

                  final data = snapshot.data!;
                  final main = data['main'];
                  final weather = data['weather'][0];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'อุณหภูมิ: ${main['temp'].toStringAsFixed(1)} °C'),
                      Text('ความชื้น: ${main['humidity']} %'),
                      Text('สภาพอากาศ: ${weather['description']}'),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
