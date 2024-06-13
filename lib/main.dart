import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glam Gas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFFFF), // Set the background color to white
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/Logo.jfif', height: 275), // Adjust the height as needed
            const SizedBox(height: 35),
            SizedBox(
              width: 250, // Set the width for all buttons
              child: ElevatedButton(
                onPressed: () async {
                  const url = 'https://company-website.com'; // Replace with actual URL
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Background color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                ),
                child: const Text('Buy Appliances'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250, // Set the width for all buttons
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterComplaintPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Background color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                ),
                child: const Text('Register Complaint'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250, // Set the width for all buttons
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterProductPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Background color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                ),
                child: const Text('Register Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterComplaintPage extends StatelessWidget {
  const RegisterComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Complaint'),
      ),
      body: const ComplaintForm(),
    );
  }
}

class RegisterProductPage extends StatelessWidget {
  const RegisterProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Product'),
      ),
      body: const ProductForm(),
    );
  }
}

class ComplaintForm extends StatefulWidget {
  const ComplaintForm({super.key});

  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contact1Controller = TextEditingController();
  final TextEditingController _contact2Controller = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedCategory = 'Hob (stove)';

  Future<void> _submitComplaint() async {
    final url = Uri.parse('https://your-api-endpoint.com/complaints'); // Replace with your API endpoint
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _nameController.text,
        'contact1': _contact1Controller.text,
        'contact2': _contact2Controller.text,
        'address': _addressController.text,
        'category': _selectedCategory,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully posted
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Complaint submitted successfully')));
    } else {
      // Error occurred
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit complaint')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Customer Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter customer name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _contact1Controller,
            decoration: const InputDecoration(labelText: 'Contact no1'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter contact number';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _contact2Controller,
            decoration: const InputDecoration(labelText: 'Contact no2'),
          ),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Address'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter address';
              }
              return null;
            },
          ),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            items: [
              'Hob (stove)',
              'Hood (Chimney/turbo)',
              'Cooking range',
              'Hot plate (Electric stove)',
              'Microwave',
              'Built in oven',
              'Water heater',
              'Sink',
              'Faucet (tab)',
              'Glass washer',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            },
            decoration: const InputDecoration(labelText: 'Product Category'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _submitComplaint();
                }
              },
              child: const Text('Submit Complaint'),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contact1Controller = TextEditingController();
  final TextEditingController _contact2Controller = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedCategory = 'Hob (stove)';
  final TextEditingController _barcodeController = TextEditingController();

  Future<void> _submitProduct() async {
    final url = Uri.parse('https://your-api-endpoint.com/products'); // Replace with your API endpoint
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _nameController.text,
        'contact1': _contact1Controller.text,
        'contact2': _contact2Controller.text,
        'address': _addressController.text,
        'category': _selectedCategory,
        'barcode': _barcodeController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully posted
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product registered successfully')));
    } else {
      // Error occurred
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to register product')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Customer Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter customer name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _contact1Controller,
            decoration: const InputDecoration(labelText: 'Contact no1'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter contact number';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _contact2Controller,
            decoration: const InputDecoration(labelText: 'Contact no2'),
          ),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Address'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter address';
              }
              return null;
            },
          ),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            items: [
              'Hob (stove)',
              'Hood (Chimney/turbo)',
              'Cooking range',
              'Hot plate (Electric stove)',
              'Microwave',
              'Built in oven',
              'Water heater',
              'Sink',
              'Faucet (tab)',
              'Glass washer',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            },
            decoration: const InputDecoration(labelText: 'Product Category'),
          ),
          TextFormField(
            controller: _barcodeController,
            decoration: const InputDecoration(labelText: 'Barcode'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter barcode';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _submitProduct();
                }
              },
              child: const Text('Register Product'),
            ),
          ),
        ],
      ),
    );
  }
}
