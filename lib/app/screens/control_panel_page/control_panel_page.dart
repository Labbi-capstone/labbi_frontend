import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/components/charts/two_line_chart_component.dart';
import 'package:labbi_frontend/app/components/control_sliders/control_slider_component.dart';
import 'package:labbi_frontend/app/mockDatas/device_data.dart'; // Import the device data
import 'package:http/http.dart' as http;
import 'dart:convert';

class ControlPanelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.secondary,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text('Control Panel', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: ListView.builder(
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

      ),
    );
  }
}

class DeviceCard extends StatefulWidget {
  final String deviceName;
  final String status;
  final String version;
  final List<double> humidityData;
  final List<double> temperatureData;
  final int motorSpeed;
  final int fanSpeed;
  bool isActive; // This needs to be mutable
  final String deviceId;

  DeviceCard({
    required this.deviceName,
    required this.status,
    required this.version,
    required this.humidityData,
    required this.temperatureData,
    required this.motorSpeed,
    required this.fanSpeed,
    required this.isActive,
    required this.deviceId,
  });

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late bool _isActive;
  bool _isLoading = false; // Show a loader while making an API call

  @override
  void initState() {
    super.initState();
    _isActive = widget.isActive;
  }

  Future<void> _toggleDeviceStatus(bool newStatus) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final url = Uri.parse(
        'http://your-backend-api-url.com/devices/${widget.deviceId}/toggle'); // Replace with your API endpoint

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"isActive": newStatus}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isActive = newStatus;
          widget.isActive = newStatus;
        });
      } else {
        // Handle error response
        print('Failed to update status: ${response.body}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

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
                    Text('Device: ${widget.deviceName}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text('Status: ', style: TextStyle(fontSize: 14)),
                        Text(widget.status,
                            style: TextStyle(
                                fontSize: 14,
                                color: widget.status == 'online'
                                    ? Colors.green
                                    : Colors.red)),
                      ],
                    ),
                    Text('Version: ${widget.version}',
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
                _isLoading
                    ? CircularProgressIndicator() // Show loading indicator when making API call
                    : FlutterSwitch(
                        width: 55.0,
                        height: 25.0,
                        value: _isActive,
                        onToggle: (val) {
                          _toggleDeviceStatus(val);
                        },
                      ),
              ],
            ),
            SizedBox(height: 10),
            widget.humidityData.isNotEmpty && widget.temperatureData.isNotEmpty
                ? TwoLineChartComponent(
                    humidityData: widget.humidityData,
                    temperatureData: widget.temperatureData)
                : Center(child: Text('No data available')),
            SizedBox(height: 10),
            ControlSliderComponent(
              icon: FontAwesomeIcons.cog,
              label: 'Motor speed: ${widget.motorSpeed} RPM',
              value: widget.motorSpeed.toDouble(),
              onChanged: (val) {
                // Handle motor speed change
              },
            ),
            ControlSliderComponent(
              icon: FontAwesomeIcons.fan,
              label: 'Fan speed: ${widget.fanSpeed} RPM',
              value: widget.fanSpeed.toDouble(),
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
