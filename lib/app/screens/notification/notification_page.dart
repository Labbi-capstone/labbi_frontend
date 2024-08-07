import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/notification_message.dart';
import 'package:labbi_frontend/app/screens/notification/notification_container.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isChanged = false;
  int count = 0;
  // bool isTap = false;

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff3ac7f9),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Notification",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenHeight / 35),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              height: screenHeight,
              width: screenWidth,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/app-background.jpg"),
                      fit: BoxFit.fill)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight / 30, bottom: screenHeight / 30),
                    child: customTabBar(screenHeight, screenWidth)),
                if (isChanged == false)
                  for (var i = 0; i < notificationList.length; i++)
                    if (notificationList[i].status == 'unread')
                      Padding(
                          padding: EdgeInsets.only(bottom: screenHeight / 35),
                          child: NotificationContainer(
                            notification: notificationList[i],
                          ))
                    else
                      const SizedBox.shrink()
                else
                  for (var i = 0; i < notificationList.length; i++)
                    if (notificationList[i].status == 'read')
                      Padding(
                          padding: EdgeInsets.only(bottom: screenHeight / 35),
                          child: NotificationContainer(
                            notification: notificationList[i],
                          ))
                    else
                      const SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customTabBar(double screenHeight, double screenWidth) => Container(
        height: (1 / 18) * screenHeight,
        width: (4 / 5) * screenWidth,
        decoration: const BoxDecoration(
            color: Color(0xffeaeaea),
            borderRadius: BorderRadius.all(Radius.circular(40))),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                height: (1 / 18) * screenHeight,
                width: ((4 / 5) * screenWidth) / 2,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: isChanged
                            ? const Color(0xffeaeaea)
                            : const Color(0xFFFFFFFF)),
                    onPressed: () {
                      setState(() {
                        isChanged = false;
                      });
                    },
                    child: Text(
                      "Unread Messages",
                      style: TextStyle(
                          color: isChanged
                              ? const Color(0xffa8a8a8)
                              : const Color(0xff000000)),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                height: (1 / 18) * screenHeight,
                width: ((4 / 5) * screenWidth) / 2,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: isChanged
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xffeaeaea)),
                    onPressed: () {
                      setState(() {
                        isChanged = true;
                      });
                    },
                    child: Text(
                      "Read Messages",
                      style: TextStyle(
                          color: isChanged
                              ? const Color(0xff000000)
                              : const Color(0xffa8a8a8)),
                    )),
              ),
            )
          ],
        ),
      );
}
