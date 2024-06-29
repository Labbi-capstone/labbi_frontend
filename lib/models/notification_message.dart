class NotificationMessage {
  int id;
  String imagePath;
  Sender sender;
  String content;
  String date;
  String time;
  String status;

  NotificationMessage(
      {required this.id,
      required this.imagePath,
      required this.sender,
      required this.content,
      required this.date,
      required this.time,
      required this.status});

  String get isImagePath {
    return imagePath;
  }

  set setImageName(String imagePath) {
    imagePath = this.imagePath;
  }
}

class Sender {
  String name;
  String role;

  Sender({required this.name, required this.role});
}

List<NotificationMessage> notificationList = [
  NotificationMessage(
      id: 1,
      imagePath: 'assets/images/test-profile-image.jpg',
      sender: Sender(name: 'Tran Tuan Kiet', role: 'Adminstrator'),
      content: 'Tuan Kiet Tran has assigned you into an organisation.',
      date: '06/27/2024',
      time: '21:45',
      status: 'unread'),
  NotificationMessage(
      id: 2,
      imagePath: 'assets/images/system.png',
      sender: Sender(name: 'Auto-Generated', role: 'System'),
      content: 'Tuan Kiet Tran has modified the speed of rotor A.',
      date: '06/26/2024',
      time: '20:15',
      status: 'unread'),
  NotificationMessage(
      id: 3,
      imagePath: 'assets/images/man.png',
      sender: Sender(name: 'User244652', role: 'User'),
      content:
          'User244652 has add device 0x56223 into dashboard and modified the status of device 0x5413.',
      date: '06/23/2024',
      time: '19:16',
      status: 'read'),
  NotificationMessage(
      id: 4,
      imagePath: 'assets/images/system.png',
      sender: Sender(name: 'Auto-Generated', role: 'System'),
      content: 'User244652 has add device 0x56223 into dashboard.',
      date: '06/23/2024',
      time: '19:16',
      status: 'read'),
  NotificationMessage(
      id: 5,
      imagePath: 'assets/images/system.png',
      sender: Sender(name: 'Auto-Generated', role: 'System'),
      content: 'An error occurred with device 0x56223.',
      date: '06/24/2024',
      time: '19:16',
      status: 'unread'),
  NotificationMessage(
      id: 6,
      imagePath: 'assets/images/man.png',
      sender: Sender(name: 'Admin245136', role: 'Organisation Admin'),
      content: 'Admin245136 has invited you to join an organisation.',
      date: '06/23/2024',
      time: '09:18',
      status: 'unread'),
  NotificationMessage(
      id: 7,
      imagePath: 'assets/images/man.png',
      sender: Sender(name: 'Admin248412', role: 'Organisation Admin'),
      content: 'Admin248412 has invited you to join an organisation.',
      date: '06/21/2024',
      time: '12:36',
      status: 'unread'),
];
