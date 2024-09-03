import 'dart:io';
import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labbi_frontend/app/utils/user_info_helper.dart';
import 'package:labbi_frontend/app/components/text_fields/edit_text_field.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final String imagePath = "assets/images/man.png";
  final ImagePicker picker = ImagePicker();
  XFile? _profileImage;
  String userName = '';
  String userEmail = '';
  String userRole = '';
  String newUserName = '';
  String newUserEmail = '';
  String newUserPhone = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await UserInfoHelper.loadUserInfo();
    setState(() {
      userName = userInfo['userName']!;
      userEmail = userInfo['userEmail']!;
      userRole = userInfo['userRole']!;
    });
  }

  Future<void> updateUserInfo() async {
    await UserInfoHelper.updateUserInfo(newUserName, newUserEmail);
  }

  changeCurrentName(newName) {
    setState(() {
      userName = newUserName;
    });
  }

  updateName(newName) {
    setState(() {
      newUserName = newName;
    });
  }

  updateEmail(newEmail) {
    setState(() {
      newUserEmail = newEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
            padding: EdgeInsets.only(
                top: 0.02 * screenHeight,
                bottom: 0.03 * screenHeight,
                left: 0.05 * screenWidth,
                right: 0.05 * screenWidth),
            child: Container(
              height: null,
              width: (9 / 10) * screenWidth,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.03 * screenHeight, bottom: 0.01 * screenHeight),
                    child: userProfileImage(context, screenHeight, screenWidth),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                        fontSize: screenHeight / 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: 0.002 * screenHeight,
                          bottom: 0.03 * screenHeight),
                      child: Text(
                        userRole,
                        style: TextStyle(
                            fontSize: screenHeight / 45, color: Colors.grey),
                      )),
                ],
              ),
            )),
        Padding(
            padding: EdgeInsets.only(
                top: 0.002 * screenHeight,
                bottom: 0.02 * screenHeight,
                left: 0.05 * screenWidth,
                right: 0.05 * screenWidth),
            child: Container(
              height: null,
              width: (9 / 10) * screenWidth,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  EditTextField(
                      label: "Name",
                      userData: userName,
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      updateName: updateName,
                      updateEmail: updateEmail,),
                  EditTextField(
                      label: "Email",
                      userData: userEmail,
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      updateName: updateName,
                      updateEmail: updateEmail,),
                  EditTextField(
                      label: "Phone",
                      userData: "*To be updated*",
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      updateName: updateName,
                      updateEmail: updateEmail,),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 0.07 * screenWidth,
                        right: 0.07 * screenWidth,
                        top: 0.02 * screenHeight,
                        bottom: 0.02 * screenHeight),
                    child: Container(
                      height: 0.07 * screenHeight,
                      width: (5 / 10) * screenWidth,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.secondary,
                            ],
                            begin: FractionalOffset(0.0, 0.0),
                            end: FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                            changeCurrentName(newUserName);
                            updateUserInfo();
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 0.025 * screenHeight,
                                color: Colors.white),
                          )),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }

  Widget userProfileImage(context, screenHeight, screenWidth) => Container(
        height: (screenHeight / 13) * 2,
        width: (screenHeight / 13) * 2,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                blurRadius: 8,
                color: AppColors.primary,
                spreadRadius: 0,
                offset: Offset(0, 2))
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: screenHeight / 13,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: screenHeight / 14,
                backgroundColor: Colors.white,
                child: (_profileImage != null)
                    ? Image.file(_profileImage as File)
                    : Image.asset('assets/images/man.png'),
              ),
            ),
            Container(
              height: (screenHeight / 13) * 2,
              width: (screenHeight / 13) * 2,
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () async {
                  final XFile? pickedImage =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _profileImage = pickedImage;
                    });
                  }
                },
                child: CircleAvatar(
                  radius: (1 / 42) * screenHeight,
                  backgroundColor: Colors.white,
                  child: const Image(
                      image: AssetImage('assets/images/camera.png')),
                ),
              ),
            )
          ],
        ),
      );
}