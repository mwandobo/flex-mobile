import 'dart:convert';

import 'package:flex_mobile/core/constants/app.dart';
import 'package:flex_mobile/features/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final String apiUrl =
        '${AppConstants.baseUrl}employee/${await AuthService().getUserId()}';
    try {
      final url = Uri.parse(apiUrl);

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService().getToken()}'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _userData = data['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch data. Error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'An error occurred: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _userData != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Picture
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              _userData!['profile_picture'] ??
                                  'https://via.placeholder.com/150', // Placeholder image
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Full Name
                          Text(
                            _userData!['full_name'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Email
                          Text(
                            _userData!['email'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Details Card
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.phone,
                                        color: Colors.teal),
                                    title: const Text('Phone'),
                                    subtitle: Text(_userData!['phone']),
                                  ),
                                  const Divider(),
                                  ListTile(
                                    leading: const Icon(Icons.location_city,
                                        color: Colors.teal),
                                    title: const Text('Address'),
                                    subtitle: Text(_userData!['address'] ??
                                        'Not available'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: Text('No data found')),
    );
  }
}
