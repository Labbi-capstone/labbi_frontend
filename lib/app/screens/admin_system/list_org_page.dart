import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/components/buttons/menu_button.dart';
import 'package:labbi_frontend/app/components/org_search_bar.dart';
import 'package:labbi_frontend/app/controllers/org_controller.dart';
import 'package:labbi_frontend/app/components/org_container.dart';
import 'package:labbi_frontend/app/components/buttons/add_button.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_home_page.dart';
import 'package:labbi_frontend/app/screens/admin_system/create_org_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListOrgPage extends ConsumerStatefulWidget {
  const ListOrgPage({super.key});

  @override
  ConsumerState<ListOrgPage> createState() => _ListOrgPageState();
}

class _ListOrgPageState extends ConsumerState<ListOrgPage> {
  String searchKeyWord = '';
  String? userRole; // To store the user role

  @override
  void initState() {
    super.initState();

    // Delaying the fetchOrganizations call to avoid modifying the provider during build
    Future.delayed(Duration.zero, () async {
      final orgController = ref.read(orgControllerProvider.notifier);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve user role and user ID from SharedPreferences
      userRole = prefs.getString('userRole');
      String? userId = prefs.getString('userId');

      if (userRole == 'admin') {
        // If the user is an admin, fetch all organizations
        orgController.fetchOrganizations();
      } else if (userRole == 'developer' && userId != null) {
        // If the user is an admin, fetch all organizations
        orgController.fetchOrganizations();
      } else if (userRole == 'user' && userId != null) {
        // If the user is a regular user, fetch organizations by user ID
        orgController.fetchOrganizationsByUserId(userId);
      } else {
        // Handle case when userRole is not set
        print('Error: User role is not recognized');
      }
    });
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
    final orgController = ref.watch(orgControllerProvider.notifier);
    final isLoading = ref.watch(orgControllerLoadingProvider);
    final errorMessage = ref.watch(orgControllerErrorMessageProvider);
    final organizationList = ref.watch(orgControllerProvider).organizationList;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return const MenuButton();
          },
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
      drawer: const MenuTaskbar(),
      body: Stack(
        children: [
          Container(
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
            child: Column(
              children: [
                // Search bar
                OrgSearchBar(callback: updateSearchKey),

                // Organization list
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.08),
                    itemCount: organizationList
                        .where((org) => org.name
                            .toLowerCase()
                            .contains(searchKeyWord.toLowerCase()))
                        .length,
                    itemBuilder: (context, index) {
                      final org = organizationList
                          .where((org) => org.name
                              .toLowerCase()
                              .contains(searchKeyWord.toLowerCase()))
                          .toList()[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              screenWidth * 0.04, // Add horizontal padding
                          vertical: screenHeight * 0.01, // Add vertical padding
                        ),
                        child: OrgContainer(
                          organization: org,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminOrgHomePage(
                                  orgId: org.id,
                                ), // Navigate to OrgPage
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Conditionally display the AddButton if userRole is 'admin'
          if (userRole == 'admin')
            Positioned(
              bottom: screenHeight * 0.02,
              right: screenWidth * 0.06,
              child: AddButton(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                pageToNavigate: const CreateOrgPage(),
              ),
            ),
        ],
      ),
    );
  }
}
