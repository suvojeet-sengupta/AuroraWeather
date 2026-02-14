import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/weather_model.dart';
import '../screens/weather_detail_screen.dart';
import '../services/settings_service.dart';
import 'glass_card.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final TemperatureUnit temperatureUnit;
  final VoidCallback? onTap;
  final bool showDragHandle;
  final bool isOffline;
  final DateTime lastUpdated;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.temperatureUnit,
    this.onTap,
    this.showDragHandle = false,
    this.isOffline = false,
    required this.lastUpdated,
  });

  double _celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tempUnitSymbol = temperatureUnit == TemperatureUnit.fahrenheit ? '°F' : '°C';

    final currentTemp = temperatureUnit == TemperatureUnit.fahrenheit
        ? _celsiusToFahrenheit(weather.temperature)
        : weather.temperature;

    final maxTemp = temperatureUnit == TemperatureUnit.fahrenheit
        ? _celsiusToFahrenheit(weather.dailyForecast.first.maxTemp)
        : weather.dailyForecast.first.maxTemp;

    final minTemp = temperatureUnit == TemperatureUnit.fahrenheit
        ? _celsiusToFahrenheit(weather.dailyForecast.first.minTemp)
        : weather.dailyForecast.first.minTemp;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GlassCard(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherDetailScreen(weather: weather),
                  ),
                );
              },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                if (showDragHandle)
                  Icon(Icons.drag_handle, color: colorScheme.onSurface.withOpacity(0.3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.locationName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            weather.condition,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          if (isOffline) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.cloud_off, size: 14, color: colorScheme.error),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildTempBadge(context, Icons.arrow_upward, '${maxTemp.round()}°', Colors.orange),
                          const SizedBox(width: 8),
                          _buildTempBadge(context, Icons.arrow_downward, '${minTemp.round()}°', Colors.blue),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        if (weather.iconUrl.isNotEmpty)
                          Image.network(
                            weather.iconUrl,
                            height: 40,
                            width: 40,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          '${currentTemp.round()}$tempUnitSymbol',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('h:mm a').format(lastUpdated),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildTempBadge(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
  }
}