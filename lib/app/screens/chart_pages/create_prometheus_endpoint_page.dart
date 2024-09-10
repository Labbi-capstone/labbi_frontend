import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart'; // Assuming you have custom colors defined
import 'package:labbi_frontend/app/providers.dart';

class CreatePrometheusEndpointPage extends ConsumerStatefulWidget {
  const CreatePrometheusEndpointPage({Key? key}) : super(key: key);

  @override
  _CreatePrometheusEndpointPageState createState() =>
      _CreatePrometheusEndpointPageState();
}

class _CreatePrometheusEndpointPageState
    extends ConsumerState<CreatePrometheusEndpointPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _baseUrl = '';
  String _path = '';
  String _query = '';
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        // Call the controller to create a new endpoint
        await ref.read(prometheusControllerProvider.notifier).createEndpoint(
              _name,
              _baseUrl,
              _path,
              _query,
            );
        Navigator.pop(context); // Navigate back on success
      } catch (e) {
        // Show error if endpoint creation fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create Prometheus endpoint: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // White back arrow
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Text(
          'Create Prometheus Endpoint',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: const TextStyle(color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                onSaved: (value) => _name = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Base URL Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Base URL',
                  labelStyle: const TextStyle(color: AppColors.primary),
                  hintText: 'e.g., http://example.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                onSaved: (value) => _baseUrl = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a base URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Path Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Path',
                  labelStyle: const TextStyle(color: AppColors.primary),
                  hintText: 'e.g., /api/v1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                onSaved: (value) => _path = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a path';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Query Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Query',
                  labelStyle: const TextStyle(color: AppColors.primary),
                  hintText: 'e.g., ?query=up',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                onSaved: (value) => _query = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a query';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button with Loading Indicator
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: AppColors.primary,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Create Endpoint',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
