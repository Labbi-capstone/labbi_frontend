import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/models/user_device_test.dart';

class AdminOrgDeviceDetailsPage extends StatefulWidget {
  final UserDevice device;
  final Function(UserDevice) onDelete;

  const AdminOrgDeviceDetailsPage({
    super.key,
    required this.device,
    required this.onDelete,
  });

  @override
  _DeviceDetailsPageState createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<AdminOrgDeviceDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device.name);
    _statusController = TextEditingController(text: widget.device.status);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    setState(() {
      widget.device.updateDevice(_nameController.text, _statusController.text);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Color.fromRGBO(83, 206, 255, 0.801),
                // Color.fromRGBO(0, 174, 255, 0.959),
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
        title: Text(
          widget.device.name,
          style: TextStyle(
            fontSize: screenHeight * 0.037,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(83, 206, 255, 0.801),
              Color.fromRGBO(0, 174, 255, 0.959),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(screenHeight * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // First Box (Newly Added)
                Container(
                  height: screenHeight * 0.2,
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.01,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.device.status,
                          style: TextStyle(
                            fontSize: screenHeight * 0.023,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space between the two boxes

                // Second Box (Existing)
                Container(
                  height: screenHeight * 0.5,
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.01,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Device Name',
                            labelStyle:
                                TextStyle(fontSize: screenHeight * 0.02),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _statusController,
                          decoration: InputDecoration(
                            labelText: 'Device Status',
                            labelStyle:
                                TextStyle(fontSize: screenHeight * 0.02),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Device ID: ${widget.device.id}',
                          style: TextStyle(fontSize: screenHeight * 0.02),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Device Type: ${widget.device.type}',
                          style: TextStyle(fontSize: screenHeight * 0.02),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: screenHeight * 0.02),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: screenHeight * 0.02),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
