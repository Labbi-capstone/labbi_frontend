import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/screens/notification/notification_page.dart';
import 'package:labbi_frontend/app/models/notification_message.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_edit/edit_user_profile.dart';

class UserProfilePage extends StatefulWidget {
  final List<NotificationMessage> listOfNotification;
  const UserProfilePage({super.key, required this.listOfNotification});
  @override
  State<StatefulWidget> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late List<NotificationMessage> listOfNotification;
  int count = 0;

  @override
  void initState() {
    super.initState();
    listOfNotification = widget.listOfNotification;
    for (var i = 0; i < listOfNotification.length; i++) {
      if (listOfNotification[i].status == 'unread') {
        setState(() {
          count += 1;
        });
      } else {
        setState(() {
          count = count;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.045),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.045),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NotificationPage()));
                },
                child: Container(
                  alignment: Alignment.bottomRight,
                  height: 0.04 * screenHeight,
                  width: (1 / 12) * screenWidth,
                  decoration: const BoxDecoration(
                      // color: Colors.red,
                      image: DecorationImage(
                          image:
                              AssetImage("assets/images/notification-icon.png"),
                          fit: BoxFit.fill)),
                  child: Container(
                    alignment: Alignment.center,
                    height: (1 / 42) * screenHeight,
                    width: (1 / 42) * screenHeight,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      count < 9 ? '$count' : '9+',
                      style: const TextStyle(
                          color: Colors.white, overflow: TextOverflow.clip),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: null,
            width: screenWidth,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image:
                        AssetImage("assets/images/user-profile-background.jpg"),
                    fit: BoxFit.fill)),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: <Widget>[
                userCoverImage(context, screenHeight, screenWidth),
                Padding(
                  padding: EdgeInsets.only(
                      top: ((1 / 3) * screenHeight) - (screenHeight / 9.7)),
                  child: userProfileImage(context, screenHeight, screenWidth),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: ((1 / 3) * screenHeight) + (screenHeight / 8.6),
                      bottom: screenHeight * 0.05),
                  child: userDetail(context, screenHeight, screenWidth),
                )
              ],
            ),
          ),
        ));
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
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: null,
                  width: screenWidth,
                  decoration: const BoxDecoration(
                      // color: Colors.red,
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/company-logo-white.png"),
                          fit: BoxFit.fill)),
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
  Widget userDetail(context, screenHeight, screenWidth) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Text(
              "Username",
              style: TextStyle(
                  fontSize: screenHeight / 26, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.005),
              child: Text(
                "Administrator",
                style:
                    TextStyle(fontSize: screenHeight / 45, color: Colors.grey),
              )),
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.05,
            ),
            child: Container(
              height: null,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.08,
                            top: screenHeight * 0.028),
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
                                padding: EdgeInsets.only(
                                    right: screenWidth * 0.08,
                                    bottom: screenHeight * 0.008),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UserProfileUpdate()));
                                  },
                                  child: Container(
                                    height: screenHeight / 12,
                                    width: screenWidth / 10,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/edit-ribon.jpg"),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                              )))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.08,
                        right: screenWidth * 0.08,
                        bottom: screenHeight * 0.025),
                    child: const Divider(),
                  ),
                  /*Detailed components */
                  /*1st Row */
                  Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.08,
                          right: screenWidth * 0.08,
                          bottom: screenHeight * 0.025),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*Account's ID*/
                          Text(
                            "Account's ID:",
                            style: TextStyle(
                                fontSize: screenHeight / 50,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.02),
                            child: Text(
                              "admin012345",
                              style: TextStyle(
                                  fontSize: screenHeight / 50,
                                  color: Colors.grey),
                              overflow: TextOverflow.clip,
                            ),
                          )
                        ],
                      )),

                  /*2nd Row */
                  Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.08,
                          right: screenWidth * 0.08,
                          bottom: screenHeight * 0.025),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*Creation Date*/
                          Text(
                            "Creation Date:",
                            style: TextStyle(
                                fontSize: screenHeight / 50,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.02),
                            child: Text(
                              "11/06/2024",
                              style: TextStyle(
                                  fontSize: screenHeight / 50,
                                  color: Colors.grey),
                              overflow: TextOverflow.clip,
                            ),
                          )
                        ],
                      )),

                  /*3rd Row */
                  Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.08,
                          right: screenWidth * 0.08,
                          bottom: screenHeight * 0.025),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*Email*/
                          Text(
                            "Email:",
                            style: TextStyle(
                                fontSize: screenHeight / 50,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.02),
                            child: Text(
                              "admin@bestlab.com",
                              style: TextStyle(
                                  fontSize: screenHeight / 50,
                                  color: Colors.grey),
                              overflow: TextOverflow.clip,
                            ),
                          )
                        ],
                      )),

                  /*4th Row */
                  Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.08,
                          right: screenWidth * 0.08,
                          bottom: screenHeight * 0.025),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*Phone*/
                          Text(
                            "Phone:",
                            style: TextStyle(
                                fontSize: screenHeight / 50,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.02),
                            child: Text(
                              "09xxxxxxxx",
                              style: TextStyle(
                                  fontSize: screenHeight / 50,
                                  color: Colors.grey),
                              overflow: TextOverflow.clip,
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          )
        ],
      );
}
