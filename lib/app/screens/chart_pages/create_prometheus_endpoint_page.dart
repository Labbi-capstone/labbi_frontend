import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Prometheus Endpoint'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Base URL'),
                onSaved: (value) => _baseUrl = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a base URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Path'),
                onSaved: (value) => _path = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a path';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Query'),
                onSaved: (value) => _query = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a query';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Endpoint'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
