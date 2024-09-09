import 'package:flutter/material.dart';

class CreateChartPage extends StatefulWidget {
  const CreateChartPage({Key? key}) : super(key: key);

  @override
  _CreateChartPageState createState() => _CreateChartPageState();
}

class _CreateChartPageState extends State<CreateChartPage> {
  final _formKey = GlobalKey<FormState>();
  String? _chartName;
  String? _chartType = 'line'; // Default to 'line'
  String? _prometheusEndpointId;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Handle chart creation logic here
      print('Chart Name: $_chartName');
      print('Chart Type: $_chartType');
      print('Prometheus Endpoint ID: $_prometheusEndpointId');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chart created successfully!')),
      );

      // Optionally navigate back after chart creation
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Chart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Chart Name'),
                onSaved: (value) {
                  _chartName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a chart name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _chartType,
                decoration: const InputDecoration(labelText: 'Chart Type'),
                items: <String>['line', 'bar', 'pie'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _chartType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a chart type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Prometheus Endpoint ID'),
                onSaved: (value) {
                  _prometheusEndpointId = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Prometheus Endpoint ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Create Chart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
