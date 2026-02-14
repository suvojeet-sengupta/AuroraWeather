import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/settings_service.dart';
import 'glass_card.dart';

class CurrentWeather extends StatelessWidget {
  final Weather weather;
  final TemperatureUnit temperatureUnit;

  const CurrentWeather({super.key, required this.weather, required this.temperatureUnit});

  double _celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  String _formatLastUpdated(String lastUpdated) {
    try {
      final dateTime = DateTime.parse(lastUpdated);
      return DateFormat.jm().format(dateTime);
    } catch (e) {
      return lastUpdated;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTemp = temperatureUnit == TemperatureUnit.fahrenheit
        ? _celsiusToFahrenheit(weather.temperature)
        : weather.temperature;
    final feelsLikeTemp = temperatureUnit == TemperatureUnit.fahrenheit
        ? _celsiusToFahrenheit(weather.feelsLike)
        : weather.feelsLike;
    final tempUnitSymbol = temperatureUnit == TemperatureUnit.fahrenheit ? '°F' : '°C';

    return GlassCard(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            weather.locationName,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatLastUpdated(weather.last_updated),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (weather.iconUrl.isNotEmpty)
                Image.network(
                  weather.iconUrl,
                  height: 120,
                  width: 120,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud, size: 80),
                ).animate().scale(duration: 600.ms, curve: Curves.backOut),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentTemp.round()}$tempUnitSymbol',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 84,
                          fontWeight: FontWeight.w200,
                          height: 1,
                        ),
                  ),
                  Text(
                    weather.condition,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem(context, Icons.thermostat, 'Feels like', '${feelsLikeTemp.round()}$tempUnitSymbol'),
              _buildVerticalDivider(context),
              _buildInfoItem(context, Icons.water_drop, 'Humidity', '${weather.humidity}%'),
              _buildVerticalDivider(context),
              _buildInfoItem(context, Icons.air, 'Wind', '${weather.wind.round()} km/h'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Container(
      height: 30,
      width: 1,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
  }
}
