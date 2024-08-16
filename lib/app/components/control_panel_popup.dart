import 'package:flutter/material.dart';

class ControlPanelPopup extends StatefulWidget {
  final double currentValue;
  final IconData icon;
  final String label;
  const ControlPanelPopup(
      {super.key,
      required this.currentValue,
      required this.icon,
      required this.label});
  @override
  State<StatefulWidget> createState() => _ControlPanelPopupState();
}

class _ControlPanelPopupState extends State<ControlPanelPopup> {
  late int currentValue;
  late IconData icon;
  late String label;

  @override
  void initState() {
    super.initState();
    currentValue = widget.currentValue.toInt();
    icon = widget.icon;
    label = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
        backgroundColor: const Color(0xffbbdefa),
        title: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 0.05 * screenHeight,
              width: 0.09 * screenWidth,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/cross-white.png"),
                      fit: BoxFit.fill)),
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(icon, size: 30),
                  Padding(
                    padding: EdgeInsets.only(left: 0.02 * screenWidth),
                    child: Text(
                      label,
                      style: TextStyle(fontSize: 0.02 * screenHeight),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 0.01 * screenWidth,
                    right: 0.01 * screenWidth,
                    top: 0.025 * screenHeight,
                    bottom: 0.025 * screenHeight),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      filled: true,
                      hintText: "Enter custom value",
                      fillColor: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.01 * screenHeight),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(Color(0xff3a5afe)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)))),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
