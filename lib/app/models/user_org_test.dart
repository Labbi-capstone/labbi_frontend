class UserOrg {
  final String name;
  final String id;
  final String pathImage;

  UserOrg({required this.name, required this.id, required this.pathImage});
}

List<UserOrg> getUserOrg() {
  return [
    UserOrg(name: 'user 1', id: '001', pathImage: 'assets/images/man.png'),
    UserOrg(
        name: 'user 2',
        id: '002',
        pathImage: 'assets/images/test-profile-image.jpg'),
    UserOrg(name: 'user 3', id: '003', pathImage: 'assets/images/man.png'),
    UserOrg(name: 'user 4', id: '004', pathImage: 'assets/images/man.png'),
  ];
}
