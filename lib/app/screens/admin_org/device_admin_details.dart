import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/user_device_test.dart';

class DeviceDetailsPage extends StatefulWidget {
  final UserDevice device;
  final Function(UserDevice) onDelete;

  const DeviceDetailsPage({
    super.key,
    required this.device,
    required this.onDelete,
  });

  @override
  _DeviceDetailsPageState createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
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

  void _deleteDevice() {
    // Show confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Device'),
        content: const Text('Are you sure you want to delete this device?'),
        actions: [
          TextButton(
            onPressed: () {
              // Call the onDelete callback and pass the device
              widget.onDelete(widget.device);
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Close the details page
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteDevice,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Device Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(
                labelText: 'Device Status',
              ),
            ),
            const SizedBox(height: 16),
            Text('Device ID: ${widget.device.id}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Device Type: ${widget.device.type}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Set cancel button color
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
