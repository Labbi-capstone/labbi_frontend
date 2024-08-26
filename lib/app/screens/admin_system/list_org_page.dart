import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/org_search_bar.dart';
import 'package:labbi_frontend/app/models/organisation.dart';
import 'package:labbi_frontend/app/components/org_container.dart';

class ListOrgPage extends StatefulWidget {
  const ListOrgPage({super.key});

  @override
  State<StatefulWidget> createState() => _ListOrgPageState();
}

class _ListOrgPageState extends State<ListOrgPage> {
  String searchKeyWord = '';

  void callback(newValue) {
    setState(() {
      searchKeyWord = newValue;
    });
  }

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
          "List of Organisation",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenHeight / 35),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(83, 206, 255, 1),
              Color.fromRGBO(0, 174, 255, 1),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  OrgSearchBar(
                    callback: callback,
                  ),
                  if (searchKeyWord == '')
                    for (var i = 0; i < organisationList.length; i++)
                      Padding(
                          padding: EdgeInsets.only(bottom: screenHeight / 35),
                          child: OrgContainer(
                            organisation: organisationList[i],
                          ))
                  else
                    for (var i = 0; i < organisationList.length; i++)
                      if (organisationList[i]
                          .name
                          .toLowerCase()
                          .contains(searchKeyWord.toLowerCase()))
                        Padding(
                            padding: EdgeInsets.only(bottom: screenHeight / 35),
                            child: OrgContainer(
                              organisation: organisationList[i],
                            ))
                      else
                        const SizedBox.shrink()
                ],
              ),
            ),
            Container(
              height: screenHeight,
              width: screenWidth,
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0.06 * screenWidth,
                      vertical: 0.02 * screenHeight),
                  child: InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: (screenHeight / 12.5) / 2,
                      backgroundColor: Colors.white,
                      child: Container(
                        height: screenHeight / 7,
                        width: screenWidth / 7,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/add.png'),
                                fit: BoxFit.contain)),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
