import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/org_search_bar.dart';
import 'package:labbi_frontend/app/controllers/org_controller.dart';
import 'package:labbi_frontend/app/components/org_container.dart';
import 'package:labbi_frontend/app/screens/admin_system/add_create_org_page.dart';
import 'package:provider/provider.dart';

class ListOrgPage extends StatefulWidget {
  const ListOrgPage({super.key});

  @override
  State<ListOrgPage> createState() => _ListOrgPageState();
}

class _ListOrgPageState extends State<ListOrgPage> {
  String searchKeyWord = '';

  @override
  void initState() {
    super.initState();
    // Fetch organizations when the page is loaded
    Provider.of<OrgController>(context, listen: false).fetchOrganizations();
  }

  void updateSearchKey(String newValue) {
    setState(() {
      searchKeyWord = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final orgController = Provider.of<OrgController>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff3ac7f9),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "List of Organizations",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenHeight / 35,
          ),
        ),
      ),
      body: orgController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orgController.errorMessage != null
              ? Center(child: Text(orgController.errorMessage!))
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(83, 206, 255, 1),
                        Color.fromRGBO(0, 174, 255, 1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            OrgSearchBar(callback: updateSearchKey),
                            ...orgController.organizationList
                                .where((org) => org.name
                                    .toLowerCase()
                                    .contains(searchKeyWord.toLowerCase()))
                                .map((org) => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: screenHeight / 35),
                                      child: OrgContainer(organization: org),
                                    ))
                                .toList(),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: screenHeight * 0.02,
                        right: screenWidth * 0.06,
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddCreateOrgPage(),
                            ),
                          ),
                          child: CircleAvatar(
                            radius: screenHeight / 25,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'assets/images/add.png',
                              height: screenHeight / 7,
                              width: screenWidth / 7,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
