class DeviceData {
  final String deviceName;
  final String status;
  final String version;
  final List<double> humidityData;
  final List<double> temperatureData;
  final int motorSpeed;
  final int fanSpeed;
  final bool isActive;

  DeviceData({
    required this.deviceName,
    required this.status,
    required this.version,
    required this.humidityData,
    required this.temperatureData,
    required this.motorSpeed,
    required this.fanSpeed,
    required this.isActive,
  });
}

List<DeviceData> devices = [
  DeviceData(
    deviceName: 'MFZWI3D',
    status: 'online',
    version: '1.3.4',
    humidityData: [5.0, 4.0, 6.0, 5.0, 7.0, 6.5, 7.5],
    temperatureData: [6.0, 7.0, 5.0, 6.5, 5.0, 4.0, 3.0],
    motorSpeed: 200,
    fanSpeed: 1000,
    isActive: true,
  ),
  DeviceData(
    deviceName: 'MSDFGW',
    status: 'offline',
    version: '1.1.2',
    humidityData: [],
    temperatureData: [],
    motorSpeed: 0,
    fanSpeed: 0,
    isActive: false,
  ),
  DeviceData(
    deviceName: 'ABC1234',
    status: 'online',
    version: '2.0.1',
    humidityData: [3.0, 5.0, 4.0, 6.0, 7.0, 5.5, 4.5],
    temperatureData: [8.0, 7.5, 6.0, 5.5, 6.0, 7.0, 6.5],
    motorSpeed: 250,
    fanSpeed: 750,
    isActive: true,
  ),
  DeviceData(
    deviceName: 'XYZ7890',
    status: 'offline',
    version: '0.9.9',
    humidityData: [],
    temperatureData: [],
    motorSpeed: 0,
    fanSpeed: 0,
    isActive: false,
  ),
  DeviceData(
    deviceName: 'LMN4567',
    status: 'online',
    version: '1.2.0',
    humidityData: [6.0, 7.5, 8.0, 7.0, 6.5, 7.5, 8.0],
    temperatureData: [4.0, 4.5, 5.0, 4.5, 5.0, 5.5, 5.0],
    motorSpeed: 300,
    fanSpeed: 900,
    isActive: true,
  ),
  DeviceData(
    deviceName: 'PQR1122',
    status: 'online',
    version: '1.0.0',
    humidityData: [5.0, 5.5, 6.0, 6.5, 7.0, 6.0, 5.5],
    temperatureData: [3.0, 3.5, 4.0, 3.5, 4.0, 4.5, 4.0],
    motorSpeed: 350,
    fanSpeed: 999,
    isActive: true,
  ),
  DeviceData(
    deviceName: 'UVW3344',
    status: 'offline',
    version: '2.1.1',
    humidityData: [],
    temperatureData: [],
    motorSpeed: 0,
    fanSpeed: 0,
    isActive: false,
  ),
  DeviceData(
    deviceName: 'JKL5566',
    status: 'online',
    version: '1.4.2',
    humidityData: [6.0, 5.5, 6.0, 5.5, 6.0, 6.5, 6.0],
    temperatureData: [7.0, 6.5, 7.0, 6.5, 7.0, 7.5, 7.0],
    motorSpeed: 280,
    fanSpeed: 100,
    isActive: true,
  ),
];
