
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'helper.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  String termsText = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTerms();
  }

  Future<void> fetchTerms() async {
    setState(() => isLoading = true);
    try {
      final url = Uri.parse(ApiConfig.terms);
      final response = await http.get(url);

      print("Terms response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Adjust based on backend structure
        final content = data["content"] ?? data["data"]?["content"] ?? "No terms found.";
        final version = data["version"] ?? data["data"]?["version"] ?? "";

        setState(() {
          termsText = version.isNotEmpty
              ? "Version: $version\n\n$content"
              : content;
          isLoading = false;
        });
      } else {
        setState(() {
          termsText = "Failed to load terms.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        termsText = "Error: $e";
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
        title: const Text(
          "Terms & Privacy",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      )
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            termsText,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),

    );
  }

}
