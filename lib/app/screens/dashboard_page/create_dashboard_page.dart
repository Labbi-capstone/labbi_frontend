import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';

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
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.secondary,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
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
        body: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: screenHeight,
              width: screenWidth,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
            /*Components in cover image */
            SizedBox(
              height: (1 / 3) * screenHeight,
              width: screenWidth,
              child: Container(
                height: null,
                width: screenWidth,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("assets/images/company-logo-white.png"),
                        fit: BoxFit.fill)),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 0.3 * screenHeight,
                    bottom: 0.05 * screenHeight,
                    left: 0.05 * screenWidth,
                    right: 0.05 * screenWidth),
                child: Container(
                  height: null,
                  width: (9 / 10) * screenWidth,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
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
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
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
                              padding:
                                  EdgeInsets.only(left: 0.03 * screenWidth),
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  '+ Add devices',
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
                              padding:
                                  EdgeInsets.only(left: 0.03 * screenWidth),
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  '+ Add users',
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
            ),
          ],
        ));
  }
}
