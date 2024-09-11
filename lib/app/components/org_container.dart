import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/organization.dart';

class OrgContainer extends StatelessWidget {
  final Organization organization;
  final VoidCallback onTap;

  const OrgContainer({
    super.key,
    required this.organization,
    required this.onTap, // Add this parameter for the onTap callback
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap, // Trigger the onTap callback when the container is tapped
      child: Container(
        height: null,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.04 * screenHeight),
                child: Container(
                  height: screenHeight / 15,
                  width: screenHeight / 15,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/organization.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.0005 * screenHeight),
                    child: Text(
                      organization.name,
                      style: TextStyle(
                        fontSize: screenHeight / 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.0005 * screenHeight),
                    child: Text(
                      "Organiztion's ID: ${organization.id}",
                      style: TextStyle(
                        fontSize: screenHeight / 50,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
