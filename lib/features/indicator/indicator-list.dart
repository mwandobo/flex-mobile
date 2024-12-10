import 'package:flex_mobile/core/constants/app.dart';
import 'package:flex_mobile/features/indicator/indicator-details-screen.dart';
import 'package:flex_mobile/features/indicator/indicator-item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/service/auth_service.dart';

class IndicatorList extends StatefulWidget {
  final dynamic from;
  final dynamic fromId;

  const IndicatorList({Key? key, required this.from, required this.fromId})
      : super(key: key);

  @override
  _IndicatorListState createState() => _IndicatorListState();
}

class _IndicatorListState extends State<IndicatorList> {
  List<dynamic> indicators = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchIndicators();
  }

  Future<void> _fetchIndicators() async {
    final queryParameters = {
      'from': widget.from.toString(), // Ensure it's a string
      'from_id': widget.fromId.toString(), // En/ Use `indicatorId` otherwise
    };

    final url = Uri.parse(
        '${AppConstants.baseUrl}indicator?${Uri(queryParameters: queryParameters).query}');

    // Adjust the URL
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService().getToken()}'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          indicators = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching indicators: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: indicators.length,
      itemBuilder: (context, index) {
        final indicator = indicators[index];
        return GestureDetector(
          onTap: () {
            // Navigate to the detail screen with the selected indicator.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    IndicatorDetailScreen(indicator: indicator),
              ),
            );
          },
          child: IndicatorListItem(
            name: indicator['name'] ?? 'N/A',
            formattedCode: indicator['formatted_code'] ?? 'N/A',
            status: indicator['status'] ?? 'N/A',
          ),
        );
      },
    );
  }
}
