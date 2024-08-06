import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:labbi_frontend/app/components/charts/two_line_chart_component.dart';

class ControlPanelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Panel'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          DeviceCard(
            deviceName: 'MFZWI3D',
            status: 'online',
            version: '1.3.4',
            humidityData: [5.0, 4.0, 6.0, 5.0, 7.0, 6.5, 7.5],
            temperatureData: [6.0, 7.0, 5.0, 6.5, 5.0, 4.0, 3.0],
            motorSpeed: 200,
            fanSpeed: 1000,
            isActive: true,
          ),
          SizedBox(height: 10),
          DeviceCard(
            deviceName: 'MSDFGW',
            status: 'offline',
            version: '1.1.2',
            humidityData: [],
            temperatureData: [],
            motorSpeed: 0,
            fanSpeed: 0,
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String status;
  final String version;
  final List<double> humidityData;
  final List<double> temperatureData;
  final int motorSpeed;
  final int fanSpeed;
  final bool isActive;

  DeviceCard({
    required this.deviceName,
    required this.status,
    required this.version,
    required this.humidityData,
    required this.temperatureData,
    required this.motorSpeed,
    required this.fanSpeed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Device: $deviceName',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text('Status: ', style: TextStyle(fontSize: 14)),
                        Text(status,
                            style: TextStyle(
                                fontSize: 14,
                                color: status == 'online'
                                    ? Colors.green
                                    : Colors.red)),
                      ],
                    ),
                    Text('Version: $version', style: TextStyle(fontSize: 14)),
                  ],
                ),
                FlutterSwitch(
                  width: 55.0,
                  height: 25.0,
                  value: isActive,
                  onToggle: (val) {
                    // Handle toggle
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            humidityData.isNotEmpty && temperatureData.isNotEmpty
                ? TwoLineChartComponent(
                    humidityData: humidityData,
                    temperatureData: temperatureData)
                : Center(child: Text('No data available')),
            SizedBox(height: 10),
            ControlSlider(
              icon: FontAwesomeIcons.cog,
              label: 'Motor speed: $motorSpeed RPM',
              value: motorSpeed.toDouble(),
              onChanged: (val) {
                // Handle motor speed change
              },
            ),
            ControlSlider(
              icon: FontAwesomeIcons.fan,
              label: 'Fan speed: $fanSpeed RPM',
              value: fanSpeed.toDouble(),
              onChanged: (val) {
                // Handle fan speed change
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ControlSlider extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  ControlSlider({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 30),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              Slider(
                value: value,
                min: 0,
                max: 1000,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
        Icon(Icons.arrow_forward, size: 30),
      ],
    );
  }
}
