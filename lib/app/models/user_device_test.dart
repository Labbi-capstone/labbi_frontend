// class UserDevice{
//   final String name;
//   final String id;
//   final String type;
//   final String status;

//   UserDevice({required this.name, required this.id, required this.type, required this.status});

//   void updateDevice(String text, String text2) {}
// }

// List<UserDevice> getUserDevices() {
//   return [
//     UserDevice(name: 'Device 1', id: '001', type: 'Sensor', status: 'Active'),
//     UserDevice(name: 'Device 2', id: '002', type: 'Camera', status: 'Inactive'),
//     UserDevice(name: 'Device 3', id: '003', type: 'Thermostat', status: 'Active'),
//     UserDevice(name: 'Device 4', id: '004', type: 'Light', status: 'Active'),
//     UserDevice(name: 'Device 5', id: '005', type: 'Lock', status: 'Inactive'),
//     UserDevice(name: 'Device 6', id: '005', type: 'Lock', status: 'Inactive'),
//   ];
// }
class UserDevice {
  String name;
  String id;
  String type;
  String status;

  UserDevice({
    required this.name,
    required this.id,
    required this.type,
    required this.status,
  });

  // Method to update the device details
  void updateDevice(String newName, String newStatus) {
    name = newName;
    status = newStatus;
  }

  // Factory constructor to create a UserDevice from a map (for future API integrations).
  factory UserDevice.fromMap(Map<String, dynamic> data) {
    return UserDevice(
      name: data['name'] as String,
      id: data['id'] as String,
      type: data['type'] as String,
      status: data['status'] as String,
    );
  }

  // Convert a UserDevice instance to a map (useful for saving data).
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'type': type,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'UserDevice(name: $name, id: $id, type: $type, status: $status)';
  }
}

// A method to return a list of UserDevice instances.
List<UserDevice> getUserDevices() {
  return [
    UserDevice(name: 'Device 1', id: '001', type: 'Sensor', status: 'Active'),
    UserDevice(name: 'Device 2', id: '002', type: 'Camera', status: 'Inactive'),
    UserDevice(
        name: 'Device 3', id: '003', type: 'Thermostat', status: 'Active'),
    UserDevice(name: 'Device 4', id: '004', type: 'Light', status: 'Active'),
    UserDevice(name: 'Device 5', id: '005', type: 'Lock', status: 'Inactive'),
    UserDevice(
        name: 'Device 6',
        id: '006',
        type: 'Lock',
        status: 'Inactive'), // Fixed duplicate ID
  ];
}

// Function to fetch a device by ID.
UserDevice getUserDeviceById(String id) {
  return getUserDevices().firstWhere(
    (device) => device.id == id,
    orElse: () => UserDevice(
      name: 'Unknown Device',
      id: '000',
      type: 'Unknown',
      status: 'Inactive',
    ), // Default device
  );
}
