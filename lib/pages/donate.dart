import 'package:flutter/material.dart';
import 'package:my_market/models/organization.dart';
import 'package:my_market/services/organization_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class Donate extends StatefulWidget {
  const Donate({super.key});

  @override
  State<Donate> createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  final OrganizationService _organizationService = OrganizationService();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  File? _image;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  String _selectedCategory = 'Education';

  final List<String> _categories = [
    'Education',
    'Healthcare',
    'Environment',
    'Social Welfare',
    'Arts & Culture',
    'Other'
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _submitOrganization() async {
    if (_formKey.currentState!.validate() && _image != null) {
      setState(() => _isSubmitting = true);
      
      String result = await _organizationService.submitOrganization(
        name: _nameController.text,
        description: _descriptionController.text,
        image: _image!,
        category: _selectedCategory,
        contactEmail: _contactEmailController.text,
        contactPhone: _contactPhoneController.text,
      );

      setState(() => _isSubmitting = false);

      if (result == "success") {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Organization submitted successfully!')),
          );
          _resetForm();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $result')),
          );
        }
      }
    }
  }

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    _contactEmailController.clear();
    _contactPhoneController.clear();
    setState(() {
      _image = null;
      _selectedCategory = 'Education';
    });
  }

  void _showDonationDialog(Organization organization) {
    final amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Donate to ${organization.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter donation amount:'),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'R',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (amountController.text.isNotEmpty) {
                double amount = double.parse(amountController.text);
                String result = await _organizationService.makeDonation(
                  organizationId: organization.id,
                  amount: amount,
                  donorId: FirebaseAuth.instance.currentUser!.uid,
                );

                Navigator.pop(context);

                if (result == "success") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thank you for your donation!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $result')),
                  );
                }
              }
            },
            child: Text('Donate'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.transparent),
        title: const Text(
          'Donate',
          style: TextStyle(
            fontFamily: 'Merriweather',
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFF95D6A4),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Help someone make their dreams come true!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Submit Organization'),
                      content: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(labelText: 'Organization Name'),
                                validator: (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(labelText: 'Description'),
                                maxLines: 3,
                                validator: (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                              ),
                              SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                decoration: InputDecoration(labelText: 'Category'),
                                items: _categories.map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _selectedCategory = value!);
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _contactEmailController,
                                decoration: InputDecoration(labelText: 'Contact Email'),
                                validator: (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _contactPhoneController,
                                decoration: InputDecoration(labelText: 'Contact Phone'),
                                validator: (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                              ),
                              SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: Icon(Icons.image),
                                label: Text(_image == null ? 'Select Image' : 'Change Image'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitOrganization,
                          child: _isSubmitting
                              ? CircularProgressIndicator()
                              : Text('Submit'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Submit Organization'),
              ),
            ),
            StreamBuilder<List<Organization>>(
              stream: _organizationService.getApprovedOrganizations(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final organizations = snapshot.data ?? [];

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: organizations.length,
                  itemBuilder: (context, index) {
                    final org = organizations[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(org.imageUrl),
                          radius: 30,
                        ),
                        title: Text(org.name),
                        subtitle: Text(org.description),
                        trailing: ElevatedButton(
                          onPressed: () => _showDonationDialog(org),
                          child: Text('Donate'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }
}
