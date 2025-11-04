import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/weather_model.dart';
import '../screens/weather_detail_screen.dart';
import '../services/settings_service.dart';

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

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeatherDetailScreen(weather: weather),
                ),
              );
            },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surfaceContainerLow,
                colorScheme.surfaceContainer.withOpacity(0.3),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showDragHandle)
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(
                      Icons.drag_handle_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.locationName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                              color: colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        weather.condition,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              color: colorScheme.onSurfaceVariant,
                              letterSpacing: 0.1,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (isOffline)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: colorScheme.tertiaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.cloud_off_rounded,
                                    size: 12,
                                    color: colorScheme.onTertiaryContainer,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Offline',
                                    style: TextStyle(
                                      color: colorScheme.onTertiaryContainer,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (isOffline) const SizedBox(width: 8),
                          Icon(
                            Icons.access_time_rounded,
                            size: 12,
                            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM d, h:mm a').format(lastUpdated),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                                  letterSpacing: 0.2,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_upward_rounded,
                              size: 14,
                              color: colorScheme.onSecondaryContainer,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${maxTemp.round()}$tempUnitSymbol',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_downward_rounded,
                              size: 14,
                              color: colorScheme.onSecondaryContainer,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${minTemp.round()}$tempUnitSymbol',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      (weather.iconUrl.startsWith('https://cdn.weatherapi.com')
                          ? Image.network(
                              weather.iconUrl,
                              height: 48,
                              width: 48,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.wb_sunny_rounded,
                                size: 48,
                                color: colorScheme.primary,
                              ),
                            )
                          : Icon(
                              Icons.wb_sunny_rounded,
                              size: 48,
                              color: colorScheme.primary,
                            )),
                      const SizedBox(width: 12),
                      Text(
                        '${currentTemp.round()}$tempUnitSymbol',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: 52,
                              fontWeight: FontWeight.w300,
                              letterSpacing: -2,
                              color: colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fade(duration: 300.ms).slideY();
  }
}