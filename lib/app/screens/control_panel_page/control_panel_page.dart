import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:labbi_frontend/app/components/charts/two_line_chart_component.dart';
import 'package:labbi_frontend/app/components/control_sliders/control_slider_component.dart';
import 'package:labbi_frontend/app/mock_datas/device_data.dart'; // Import the device data

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
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return DeviceCard(
            deviceName: device.deviceName,
            status: device.status,
            version: device.version,
            humidityData: device.humidityData,
            temperatureData: device.temperatureData,
            motorSpeed: device.motorSpeed,
            fanSpeed: device.fanSpeed,
            isActive: device.isActive,
          );
        },
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
            ControlSliderComponent(
              icon: FontAwesomeIcons.cog,
              label: 'Motor speed: $motorSpeed RPM',
              value: motorSpeed.toDouble(),
              onChanged: (val) {
                // Handle motor speed change
              },
            ),
            ControlSliderComponent(
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
