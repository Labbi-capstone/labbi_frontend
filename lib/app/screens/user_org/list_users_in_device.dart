
import 'package:flutter/material.dart';

class ListUsersInDevice extends StatefulWidget{
  
  final List<UserDevice> devices;

  const ListUserDevice({super.key, required this.devices});

  @override
  // ignore: library_private_types_in_public_api
  _ListUserDeviceState createState() => _ListUserDeviceState();
}