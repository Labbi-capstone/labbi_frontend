import 'package:labbi_frontend/app/models/user.dart';

class UserViewModel {
  final User user;
  bool isSelected;

  UserViewModel(this.user, {this.isSelected = false});
}
