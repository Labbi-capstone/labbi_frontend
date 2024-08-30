import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/org_search_bar.dart';
import 'package:labbi_frontend/app/controllers/org_controller.dart';
import 'package:labbi_frontend/app/components/org_container.dart';
import 'package:labbi_frontend/app/components/buttons/add_button.dart';
import 'package:labbi_frontend/app/screens/admin_system/create_org_page.dart';
import 'package:labbi_frontend/app/screens/admin_system/user_list_in_org_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListOrgPage extends ConsumerStatefulWidget {
  const ListOrgPage({super.key});

  @override
  ConsumerState<ListOrgPage> createState() => _ListOrgPageState();
}

class _ListOrgPageState extends ConsumerState<ListOrgPage> {
  String searchKeyWord = '';

  @override
  void initState() {
    super.initState();

    // Delaying the fetchOrganizations call to avoid modifying the provider during build
    Future.delayed(Duration.zero, () {
      final orgController = ref.read(orgControllerProvider.notifier);
      orgController.fetchOrganizations();
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
    final orgState = ref.watch(orgControllerProvider);

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage))
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
                            ...organizationList
                                .where((org) => org.name
                                    .toLowerCase()
                                    .contains(searchKeyWord.toLowerCase()))
                                .map((org) => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: screenHeight / 35),
                                      child: OrgContainer(
                                        organization: org,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserListInOrgPage(
                                                      orgId: org
                                                          .id), // Navigate to UserListPage
                                            ),
                                          );
                                        },
                                      ),
                                    )),
                          ],
                        ),
                      ),
                      AddButton(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        pageToNavigate: const CreateOrgPage(),
                      ),
                    ],
                  ),
                ),
    );
  }
}
