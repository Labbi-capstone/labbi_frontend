import 'package:flutter/material.dart';

class CreateDashboardPage extends StatefulWidget {
  const CreateDashboardPage({super.key});
  @override
  State<StatefulWidget> createState() => _CreateDashboardPageState();
}

class _CreateDashboardPageState extends State<CreateDashboardPage> {
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
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
            "Create Dashboard",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: screenHeight / 35),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          height: null,
          width: screenWidth,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/images/create-dashboard-background.jpg"),
                  fit: BoxFit.fill)),
          child: Padding(
            padding: EdgeInsets.only(
                top: 0.3 * screenHeight,
                bottom: 0.05 * screenHeight,
                left: 0.05 * screenWidth,
                right: 0.05 * screenWidth),
            child: Container(
              height: 480,
              width: (9 / 10) * screenWidth,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 0.07 * screenWidth,
                        right: 0.07 * screenWidth,
                        top: 0.03 * screenHeight),
                    child: Text('Dashboard \'s Information',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * 0.028)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.07 * screenWidth,
                        vertical: 0.03 * screenHeight),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter dashboard name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 0.07 * screenWidth,
                        right: 0.07 * screenWidth,
                        top: 0.03 * screenHeight,
                        bottom: 0.01 * screenHeight),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Devices: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 0.02 * screenHeight)),
                        Padding(
                          padding: EdgeInsets.only(left: 0.06 * screenWidth),
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              '+ Add devices to dashboard',
                              style: TextStyle(
                                  fontSize: 0.02 * screenHeight,
                                  color: Colors.blue),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 0.07 * screenWidth,
                        right: 0.07 * screenWidth,
                        bottom: 0.03 * screenHeight),
                    child: const Divider(color: Colors.grey),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 0.07 * screenWidth,
                        right: 0.07 * screenWidth,
                        top: 0.03 * screenHeight,
                        bottom: 0.01 * screenHeight),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Users: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 0.02 * screenHeight)),
                        Padding(
                          padding: EdgeInsets.only(left: 0.06 * screenWidth),
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              '+ Add users to dashboard',
                              style: TextStyle(
                                  fontSize: 0.02 * screenHeight,
                                  color: Colors.blue),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 0.07 * screenWidth,
                        right: 0.07 * screenWidth,
                        bottom: 0.03 * screenHeight),
                    child: const Divider(color: Colors.grey),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 0.07 * screenWidth,
                        right: 0.07 * screenWidth,
                        top: 0.03 * screenHeight,
                        bottom: 0.03 * screenHeight),
                    child: Container(
                      height: 0.07 * screenHeight,
                      width: (5 / 10) * screenWidth,
                      decoration: BoxDecoration(
                          color: const Color(0xff3ac7f9),
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff3ac7f9),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Create',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 0.025 * screenHeight,
                                color: Colors.white),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        )));
  }
}
