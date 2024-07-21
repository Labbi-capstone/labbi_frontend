import 'package:flutter/material.dart';

class UserDevice{
  final String name;
  final String id;
  final String type;
  final String status;

  UserDevice({required this.name, required this.id, required this.type, required this.status});
}

List<UserDevice> getUserDevices() {
  return [
    UserDevice(name: 'Device 1', id: '001', type: 'Sensor', status: 'Active'),
    UserDevice(name: 'Device 2', id: '002', type: 'Camera', status: 'Inactive'),
    UserDevice(name: 'Device 3', id: '003', type: 'Thermostat', status: 'Active'),
    UserDevice(name: 'Device 4', id: '004', type: 'Light', status: 'Active'),
    UserDevice(name: 'Device 5', id: '005', type: 'Lock', status: 'Inactive'),
    UserDevice(name: 'Device 6', id: '005', type: 'Lock', status: 'Inactive'),
  ];
}