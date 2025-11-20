import 'package:flutter/material.dart';

class WeatherDialog extends StatelessWidget {
  final String city;
  final double temp;
  final int humidity;
  final String description;

  const WeatherDialog({    //ใช้แสดงสภาพอากาศ
    super.key,
    required this.city,
    required this.temp,
    required this.humidity,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('สภาพอากาศที่ $city'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('อุณหภูมิ: ${temp.toStringAsFixed(1)} °C'),
          Text('ความชื้น: $humidity %'),
          Text('สภาพอากาศ: $description'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ปิด'),
        ),
      ],
    );
  }
}
