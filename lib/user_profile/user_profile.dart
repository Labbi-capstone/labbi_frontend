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
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            top: ((1 / 3) * screenHeight),
            child: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          "assets/images/user-profile-background.jpg"),
                      fit: BoxFit.cover)),
            ),
          ),
          userCoverImage(context, screenHeight, screenWidth),
          Positioned(
            top: ((1 / 3) * screenHeight) - (screenHeight / 9.7),
            child: userProfileImage(context, screenHeight, screenWidth),
          ),
          Positioned(
            top: ((1 / 3) * screenHeight) + (screenHeight / 8.6),
            child: userDetail(context, screenHeight, screenWidth),
          )
        ],
      ),
    );
  }

  /*Cover image*/
  Widget userCoverImage(context, screenHeight, screenWidth) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: (1 / 3) * screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/app-background.jpg"),
                    fit: BoxFit.cover)),
          ),
          /*Components in cover image */
          SizedBox(
            height: (1 / 3) * screenHeight,
            width: screenWidth,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Container(
                    height: (1 / 20) * screenHeight,
                    width: (1 / 12) * screenWidth,
                    decoration: const BoxDecoration(
                        // color: Colors.red,
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/hamburger-menu-white.png"),
                            fit: BoxFit.fill)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Container(
                    height: (1 / 3) * screenHeight,
                    width: (2 / 3) * screenWidth,
                    decoration: const BoxDecoration(
                        // color: Colors.red,
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/company-logo-white.png"),
                            fit: BoxFit.fill)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    alignment: Alignment.bottomRight,
                    height: (1 / 20) * screenHeight,
                    width: (1 / 12) * screenWidth,
                    decoration: const BoxDecoration(
                        // color: Colors.red,
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/notification-icon.png"),
                            fit: BoxFit.fill)),
                    child: Container(
                      alignment: Alignment.center,
                      height: (1 / 35) * screenHeight,
                      width: (1 / 35) * screenHeight,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: const Text(
                        "9+",
                        style: TextStyle(
                            color: Colors.white, overflow: TextOverflow.clip),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  /*Profile Image*/
  Widget userProfileImage(context, screenHeight, screenWidth) => Container(
        height: (screenHeight / 9.7) * 2,
        width: (screenHeight / 9.7) * 2,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                blurRadius: 8,
                color: Color(0xff0094ff),
                spreadRadius: 0,
                offset: Offset(0, 2))
          ],
        ),
        child: CircleAvatar(
          radius: screenHeight / 9.7,
          backgroundColor: Colors.white,
          child: ClipOval(
            child: Image(
              image: const AssetImage("assets/images/test-profile-image.jpg"),
              height: (screenHeight / 10.3) * 2,
              width: (screenHeight / 10.3) * 2,
              fit: BoxFit.fill,
            ),
          ),
        ),
      );

  /*User Information*/
  Widget userDetail(context, screenHeight, screenWidth) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            child: Text(
              "Username",
              style: TextStyle(
                  fontSize: screenHeight / 26, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
              top: 30,
              child: Text(
                "Administrator",
                style:
                    TextStyle(fontSize: screenHeight / 45, color: Colors.grey),
              )),
          Positioned(
            top: 80,
            child: Container(
              height: screenHeight * (2.9 / 7),
              width: (9 / 10) * screenWidth,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 12,
                        color: Colors.black,
                        spreadRadius: 0.2,
                        offset: Offset(0, 4))
                  ],
                  // border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 16.0),
                        child: Text(
                          "User's Information",
                          style: TextStyle(
                              fontSize: screenHeight / 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      /*Ribon button */
                      Expanded(
                        child: Container(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 30.0, bottom: 5.0),
                            child: Container(
                              height: screenHeight / 13,
                              width: screenWidth / 10,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage("assets/images/ribon.jpg"),
                                      fit: BoxFit.fill)),
                              child: Container(
                                height: screenHeight / 40,
                                width: screenHeight / 40,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/edit-icon.png"),
                                        fit: BoxFit.fill)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.only(left: 30.0, right: 30.0, bottom: 16.0),
                    child: Divider(),
                  ),
                  /*Detailed components */
                  /*1st Row */
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*Account's ID*/
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                "Account's ID",
                                style: TextStyle(
                                    fontSize: screenHeight / 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: SizedBox(
                                  height: screenHeight / 10,
                                  width: screenWidth / 4,
                                  child: Text(
                                    "admin012345",
                                    style: TextStyle(
                                        fontSize: screenHeight / 45,
                                        color: Colors.grey),
                                    overflow: TextOverflow.clip,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      /*Creation Date*/
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                "Creation Date",
                                style: TextStyle(
                                    fontSize: screenHeight / 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: SizedBox(
                                  height: screenHeight / 10,
                                  width: screenWidth / 4,
                                  child: Text(
                                    "11/06/2024",
                                    style: TextStyle(
                                        fontSize: screenHeight / 45,
                                        color: Colors.grey),
                                    overflow: TextOverflow.clip,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),

                  /*2nd Row*/
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*Email*/
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                "Email",
                                style: TextStyle(
                                    fontSize: screenHeight / 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: SizedBox(
                                  height: screenHeight / 10,
                                  width: screenWidth / 4,
                                  child: Text(
                                    "admin@bestlab.com",
                                    style: TextStyle(
                                        fontSize: screenHeight / 45,
                                        color: Colors.grey),
                                    overflow: TextOverflow.clip,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      /*Phone*/
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                "Phone",
                                style: TextStyle(
                                    fontSize: screenHeight / 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: SizedBox(
                                  height: screenHeight / 10,
                                  width: screenWidth / 4,
                                  child: Text(
                                    "09xxxxxxxx",
                                    style: TextStyle(
                                        fontSize: screenHeight / 45,
                                        color: Colors.grey),
                                    overflow: TextOverflow.clip,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
}
