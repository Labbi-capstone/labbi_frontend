import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labbi_frontend/views/authentication/login/login_page.dart';
import 'package:labbi_frontend/views/user_management/devices_section.dart';
import 'package:labbi_frontend/views/user_management/users_section.dart';


class ManagementPage extends StatefulWidget {
  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  bool isDevice = true;

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.barlowSemiCondensedTextTheme(),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(175, 216, 237, 100),
                        Color.fromRGBO(0, 184, 237, 100),
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      Image.asset(
                        '/Users/hagiangnguyen/Desktop/Labbi-Frontend/lib/images/logo.png',
                        height: 50,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Material(
                              color: isDevice ? Colors.white : Colors.black26,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isDevice = true;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                                  child: Row(children: [
                                    Image.asset(
                                      '/Users/hagiangnguyen/Desktop/Labbi-Frontend/lib/images/logo.png',
                                      height: 10,
                                      color: Colors.black,
                                    ),

                                    const Column(
                                      children: [
                                        Text(
                                          "Thiết bị",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                          )
                                        ),

                                        SizedBox(height: 20),

                                        Text(
                                          "10",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                          )
                                        ),
                                      ],
                                    ),

                                  ])
                                )
                              )
                            ),

                            Material(
                              color: isDevice ? Colors.black26 : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isDevice = false;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                                  child: Row(children: [
                                    Image.asset(
                                      '/Users/hagiangnguyen/Desktop/Labbi-Frontend/lib/images/logo.png',
                                      height: 10,
                                      color: Colors.black,
                                    ),

                                    const Column(
                                      children: [
                                        Text(
                                          "Tài khoản",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                          )
                                        ),

                                        SizedBox(height: 20),

                                        Text(
                                          "20",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                          )
                                        ),
                                      ],
                                    ),

                                  ])
                                )
                              )
                            ),
                          ],
                        ),
                      ),
                    
                      const SizedBox(height: 10),
                      isDevice ? DevicesSection() : UsersSection(),
                    ],
                  ),
                )
            ),
          ),
        )
    );
  }
}