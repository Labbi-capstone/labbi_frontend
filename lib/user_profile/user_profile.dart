import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image:
                        AssetImage("assets/images/user-profile-background.jpg"),
                    fit: BoxFit.cover)),
          ),
          userCoverImage(context, screenHeight, screenWidth),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: ((0.8 / 3) * screenHeight) - (screenHeight / 10),
                child: userProfileImage(context, screenHeight, screenWidth),
              ),
              Positioned(
                top: ((0.8 / 3) * screenHeight) + (screenHeight / 8.6),
                child: userDetail(context, screenHeight, screenWidth),
              )
            ],
          ),
        ],
      ),
    );
  }

  /*Cover image*/
  Widget userCoverImage(context, screenHeight, screenWidth) => Container(
        height: (0.8 / 3) * screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/app-background.jpg"),
                fit: BoxFit.cover)),
      );

  /*Profile Image*/
  Widget userProfileImage(context, screenHeight, screenWidth) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                blurRadius: 8,
                color: Color(0xff0094ff),
                spreadRadius: 0,
                offset: Offset(0, 4))
          ],
        ),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: screenHeight / 9.7,
          child: CircleAvatar(
            radius: screenHeight / 10.3,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/user-profile.png"))),
            ),
          ),
        ),
      );

  /*User Information*/
  Widget userDetail(context, screenHeight, screenWidth) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const Positioned(
            child: Text(
              "Username",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const Positioned(
              top: 25,
              child: Text(
                "Administrator",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )),
          Positioned(
            top: 64,
            child: Container(
              height: screenHeight * (2 / 5),
              width: (9 / 10) * screenWidth,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(blurRadius: 8, color: Colors.black, spreadRadius: 0.5, offset: Offset(0, 4))
                  ],
                  // border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20)),
            ),
          )
        ],
      );
}
