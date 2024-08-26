import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/controllers/org_controller.dart';
import 'package:provider/provider.dart';


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
          "Create Organization",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenHeight / 35),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/images/create-dashboard-background.jpg"),
                  fit: BoxFit.fill)),
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
                height: 350,
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
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0.03 * screenHeight,
                          horizontal: 0.07 * screenWidth),
                      child: const Divider(color: Colors.grey),
                    ),
                    // Error Message (if any)
                    if (orgController.errorMessage != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.01 * screenHeight,
                            horizontal: 0.07 * screenWidth),
                        child: Text(
                          orgController.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    // Create Button
                    Padding(
                      padding: EdgeInsets.only(
                        top: 0.03 * screenHeight,
                      ),
                      child: Container(
                        height: 0.07 * screenHeight,
                        width: (5 / 10) * screenWidth,
                        decoration: BoxDecoration(
                          color: const Color(0xff3ac7f9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff3ac7f9),
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
                              ? CircularProgressIndicator(
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
      ),
    );
  }
}
