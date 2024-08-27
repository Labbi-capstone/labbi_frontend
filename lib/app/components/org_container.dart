import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/organisation.dart';

class OrgContainer extends StatefulWidget {
  final Organisation organisation;
  const OrgContainer({super.key, required this.organisation});
  @override
  State<StatefulWidget> createState() => _OrgContainerState();
}

class _OrgContainerState extends State<OrgContainer> {
  late Organisation organisation;

  @override
  void initState() {
    super.initState();
    organisation = widget.organisation;
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: null,
      width: (9 / 10) * screenWidth,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.06 * screenHeight),
                child: Container(
                  height: screenHeight / 15,
                  width: screenHeight / 15,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/organisation.png'),
                          fit: BoxFit.contain)),
                ),
              )),
          Expanded(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.015 * screenHeight),
                    child: Text(
                      organisation.name,
                      style: TextStyle(
                          fontSize: screenHeight / 50,
                          fontWeight: FontWeight.bold),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.015 * screenHeight),
                  child: Text(
                    'Number of Dashboard: ${organisation.dashboardList.length}',
                    style: TextStyle(
                        fontSize: screenHeight / 50,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
