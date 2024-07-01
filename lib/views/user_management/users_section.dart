import 'package:flutter/material.dart';

class UsersSection extends StatelessWidget {
  List usersList = [
    'user 1',
    'user 2',
    'user 3',
    'user 4',
    'user 5',
  ];

  @override 
  Widget build(BuildContext context){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: const Text("Danh sách tài khoản",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
          ),

        const SizedBox(height: 10),

        ListView.builder(
          itemCount: usersList.length,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(children: [
                    Container(
                      height: 70,
                      width: 70,
                      margin: EdgeInsets.only(right: 15),
                      child: Image.asset("/Users/hagiangnguyen/Desktop/Labbi-Frontend/lib/images/logo.png")
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            usersList[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )
                          ),
                          Text(
                            usersList[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black26,
                            )
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.edit_document,
                            color: Colors.black,
                          ),
                          Text(
                            "Xoá",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        ],
                      )
                    ),
                  ],)
                )
              ],
            );
          },
        ),
      ]),
    );
  }
}