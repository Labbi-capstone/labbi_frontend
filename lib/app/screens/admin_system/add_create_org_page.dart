import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/controllers/org_controller.dart';
import 'package:provider/provider.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';

class AddCreateOrgPage extends StatefulWidget {
  const AddCreateOrgPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddCreateOrgPageState();
}

class _AddCreateOrgPageState extends State<AddCreateOrgPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _orgNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    final orgController = Provider.of<OrgController>(context);

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
          "Create Organization",
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
                      image: AssetImage("assets/images/company-logo-white.png"),
                      fit: BoxFit.fill)),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: 0.3 * screenHeight,
                bottom: 0.05 * screenHeight,
                left: 0.05 * screenWidth,
                right: 0.05 * screenWidth,
              ),
              child: Form(
                key: _formKey,
                child: Container(
                  height: null,
                  width: (9 / 10) * screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0.03 * screenHeight,
                            left: 0.07 * screenWidth,
                            right: 0.07 * screenWidth),
                        child: Text(
                          'Organization\'s Information',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeight * 0.028),
                        ),
                      ),
                      // Organization Name Input
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.07 * screenWidth,
                            vertical: 0.02 * screenHeight),
                        child: TextFormField(
                          controller: _orgNameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter organization name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the organization name';
                            }
                            return null;
                          },
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                      ),
                      // Error Message (if any)
                      if (orgController.errorMessage != null)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.01 * screenHeight,
                              horizontal: 0.07 * screenWidth),
                          child: Text(
                            orgController.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      // Create Button
                      Padding(
                        padding: EdgeInsets.only(
                          top: 0.03 * screenHeight, bottom: 0.03 * screenHeight
                        ),
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
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                            ),
                            onPressed: orgController.isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      orgController.createOrganization(
                                        _orgNameController.text,
                                        context,
                                      );
                                    }
                                  },
                            child: orgController.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Create',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 0.025 * screenHeight,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
