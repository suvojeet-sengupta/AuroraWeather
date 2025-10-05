import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../screens/daily_detail_screen.dart';
import '../services/settings_service.dart';

class DailyForecastWidget extends StatefulWidget {
  final List<DailyForecast> dailyForecast;

  const DailyForecastWidget({super.key, required this.dailyForecast});

  @override
  State<DailyForecastWidget> createState() => _DailyForecastWidgetState();
}

class _DailyForecastWidgetState extends State<DailyForecastWidget> {
  final SettingsService _settingsService = SettingsService();
  bool _isFahrenheit = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _isFahrenheit = await _settingsService.isFahrenheit();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final fiveDayForecast = widget.dailyForecast.take(5).toList();

    return Card(
      color: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '5-DAY FORECAST',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: fiveDayForecast.length,
              itemBuilder: (context, index) {
                final forecast = fiveDayForecast[index];
                return _buildForecastItem(context, forecast);
              },
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 300.ms);
  }

  Widget _buildForecastItem(BuildContext context, DailyForecast forecast) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DailyDetailScreen(dailyForecast: forecast, isFahrenheit: _isFahrenheit),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  DateFormat.E().format(DateTime.parse(forecast.date)),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
              Image.network(
                forecast.iconUrl,
                height: 32,
                width: 32,
              ),
              SizedBox(
                width: 50,
                child: Text(
                  _isFahrenheit ? '${forecast.maxTempF.round()}°F' : '${forecast.maxTemp.round()}°C',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  _isFahrenheit ? '${forecast.minTempF.round()}°F' : '${forecast.minTemp.round()}°C',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 300.ms);
  }
}
