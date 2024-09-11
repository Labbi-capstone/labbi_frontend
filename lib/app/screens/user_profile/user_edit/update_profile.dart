import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labbi_frontend/app/providers.dart';
import 'package:labbi_frontend/app/utils/user_info_helper.dart';
import 'package:labbi_frontend/app/components/text_fields/edit_text_field.dart';
import 'package:labbi_frontend/app/screens/user_profile/change_password/change_password.dart';

class UpdateProfile extends ConsumerStatefulWidget {
  const UpdateProfile({
    super.key,
  });

  @override
  UpdateProfileState createState() => UpdateProfileState();
}

class UpdateProfileState extends ConsumerState<UpdateProfile> {
  final String imagePath = "assets/images/man.png";
  final ImagePicker picker = ImagePicker();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  XFile? _profileImage;
  String userName = '';
  String userEmail = '';
  String userRole = '';
  String newUserName = '';
  String newUserEmail = '';
  String newUserPhone = '';
  String userId = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    // newUserName = userNameController.text;
    // newUserEmail = emailController.text;
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await UserInfoHelper.loadUserInfo();
    setState(() {
      userName = userInfo['userName']!;
      userId = userInfo['userId']!;
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

  updateName() {
    if (userNameController.text != "") {
      setState(() {
        newUserName = userNameController.text;
      });
    } else {
      setState(() {
        newUserName = userName;
      });
    }
  }

  updateEmail() {
    if (emailController.text != "") {
      setState(() {
        newUserEmail = emailController.text;
      });
    } else {
      setState(() {
        newUserEmail = userEmail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = ref.watch(userControllerProvider.notifier);
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
                      padding: EdgeInsets.only(top: 0.002 * screenHeight),
                      child: Text(
                        userRole,
                        style: TextStyle(
                            fontSize: screenHeight / 45, color: Colors.grey),
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 0.01 * screenHeight,
                        horizontal: 0.08 * screenWidth),
                    child: const Divider(
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: 0.02 * screenWidth,
                        left: 0.02 * screenWidth,
                        bottom: 0.03 * screenHeight),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: screenHeight / 40,
                            width: screenHeight / 40,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/lock.png'))),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0.1 * screenWidth),
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 0.023 * screenHeight),
                            ),
                          ),
                          Container(
                            height: screenHeight / 40,
                            width: screenHeight / 40,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/right-chevron.png'))),
                          ),
                        ],
                      ),
                    ),
                  )
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
                    controller: userNameController,
                  ),
                  EditTextField(
                    label: "Email",
                    userData: userEmail,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    controller: emailController,
                  ),
                  EditTextField(
                    label: "Phone",
                    userData: "*To be updated*",
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    controller: phoneController,
                  ),
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
                            updateName();
                            updateEmail();
                            changeCurrentName(newUserName);
                            updateUserInfo();
                            userController.updateUserInfo(
                                userId, newUserName, newUserEmail);
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
                    ? Image.file(File(_profileImage!.path))
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
