class UserDeviceHistory {
  final String username;
  final DateTime addedOn;

  UserDeviceHistory({required this.username, required this.addedOn});
}

List<UserDeviceHistory> getUserDeviceHistory() {
  // Mock data for demonstration
  return [
    UserDeviceHistory(
        username: 'User 1',
        addedOn: DateTime.now().subtract(const Duration(days: 1))),
    UserDeviceHistory(
        username: 'User 2',
        addedOn: DateTime.now().subtract(const Duration(days: 3))),
    UserDeviceHistory(
        username: 'User 3',
        addedOn: DateTime.now().subtract(const Duration(days: 5))),
    UserDeviceHistory(
        username: 'User 4',
        addedOn: DateTime.now().subtract(const Duration(days: 8))),
    UserDeviceHistory(
        username: 'User 5',
        addedOn: DateTime.now().subtract(const Duration(days: 7))),
    UserDeviceHistory(
        username: 'User 6',
        addedOn: DateTime.now().subtract(const Duration(days: 11))),
  ];
}
