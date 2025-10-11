import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';

class WeatherUnitsScreen extends StatelessWidget {
  const WeatherUnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = Provider.of<SettingsService>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Units'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your preferred units for weather measurements.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 24),
            _buildUnitSelector<TemperatureUnit>(
              context: context,
              title: 'Temperature',
              currentUnit: settingsService.temperatureUnit,
              units: TemperatureUnit.values,
              onSelected: (value) => settingsService.setTemperatureUnit(value.first),
              labels: {
                TemperatureUnit.celsius: '°C',
                TemperatureUnit.fahrenheit: '°F',
              },
              icons: {
                TemperatureUnit.celsius: Icons.thermostat,
                TemperatureUnit.fahrenheit: Icons.thermostat,
              },
            ),
            const SizedBox(height: 24),
            _buildUnitSelector<WindSpeedUnit>(
              context: context,
              title: 'Wind Speed',
              currentUnit: settingsService.windSpeedUnit,
              units: WindSpeedUnit.values,
              onSelected: (value) => settingsService.setWindSpeedUnit(value.first),
              labels: {
                WindSpeedUnit.kph: 'km/h',
                WindSpeedUnit.mph: 'mph',
                WindSpeedUnit.ms: 'm/s',
              },
              icons: {
                WindSpeedUnit.kph: Icons.air,
                WindSpeedUnit.mph: Icons.air,
                WindSpeedUnit.ms: Icons.air,
              },
            ),
            const SizedBox(height: 24),
            _buildUnitSelector<PressureUnit>(
              context: context,
              title: 'Pressure',
              currentUnit: settingsService.pressureUnit,
              units: PressureUnit.values,
              onSelected: (value) => settingsService.setPressureUnit(value.first),
              labels: {
                PressureUnit.hPa: 'hPa',
                PressureUnit.inHg: 'inHg',
                PressureUnit.mmHg: 'mmHg',
              },
              icons: {
                PressureUnit.hPa: Icons.speed,
                PressureUnit.inHg: Icons.speed,
                PressureUnit.mmHg: Icons.speed,
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitSelector<T extends Enum>({
    required BuildContext context,
    required String title,
    required T currentUnit,
    required List<T> units,
    required Function(Set<T>) onSelected,
    required Map<T, String> labels,
    required Map<T, IconData> icons,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<T>(
            segments: units.map((unit) {
              return ButtonSegment<T>(
                value: unit,
                label: Text(labels[unit]!),
                icon: Icon(icons[unit]),
              );
            }).toList(),
            selected: {currentUnit},
            onSelectionChanged: onSelected,
            style: SegmentedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondaryContainer.withOpacity(0.3),
              foregroundColor: theme.colorScheme.onSecondaryContainer,
              selectedBackgroundColor: theme.colorScheme.primary,
              selectedForegroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: theme.textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}
