import 'package:flutter/material.dart';
import 'package:labbi_frontend/user_profile/notification_message.dart';

class NotificationContainer extends StatefulWidget {
  final NotificationMessage notification;
  const NotificationContainer({super.key, required this.notification});
  @override
  State<StatefulWidget> createState() => _NotificationContainerState();
}

class _NotificationContainerState extends State<NotificationContainer> {
  bool isTap = false;
  late NotificationMessage notification;

  // _UnreadMessageState({required this.notification});

  @override
  void initState() {
    super.initState();
    notification = widget.notification;
    //your code here
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        setState(() {
          isTap = !isTap;
        });
      },
      child: Container(
        height: null,
        width: (9 / 10) * screenWidth,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenHeight / 55, bottom: screenHeight / 55),
                child: Container(
                  height: screenHeight / 11,
                  width: screenHeight / 11,
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  child: CircleAvatar(
                    radius: (screenHeight / 11) / 2,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image(
                        image: AssetImage(notification.imagePath),
                        height: screenHeight / 11,
                        width: screenHeight / 11,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: screenHeight / 55),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              notification.sender.name,
                              style: TextStyle(
                                  fontSize: screenHeight / 50,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: screenWidth / 45),
                              child: isTap
                                  ? Text(
                                      '${notification.date} at ${notification.time}',
                                      style: TextStyle(
                                          fontSize: screenHeight / 65),
                                    )
                                  : Text(
                                      notification.date,
                                      style: TextStyle(
                                          fontSize: screenHeight / 65),
                                    ))
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      notification.sender.role,
                      style: TextStyle(
                          fontSize: screenHeight / 60,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight / 100, bottom: screenHeight / 55),
                    child: Text(notification.content,
                        style: TextStyle(fontSize: screenHeight / 50),
                        overflow: isTap
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight / 55, left: screenWidth / 60, right: screenWidth / 60),
                  child: RotatedBox(
                    quarterTurns: isTap ? 2 : 0,
                    child: const Image(
                        image: AssetImage("assets/images/chevron.png")),
                  )),
            )
          ],
        ),
      ),
    );
  }
}