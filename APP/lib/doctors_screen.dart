import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'helper.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  List<String> categories = [
    'All',
    'Cardiology',
    'Dentist',
    'Pediatrics',
    'Dermatology',
    'Neurology',
    'Orthopedics',
    'Gynecology',
    'ENT',
    'Psychiatry',
    'General Physician',
  ];
  String selectedCategory = 'All';

  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> filteredDoctors = [];
  bool isLoading = true;
  String searchQuery = '';


  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.doctors));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Check if doctors are inside jsonData['data']['doctors']
        final doctorsData = jsonData['data']?['doctors'] ?? [];

        setState(() {
          doctors = List<Map<String, dynamic>>.from(doctorsData);
          filteredDoctors = doctors;
          isLoading = false;
        });

        print("Doctors fetched: ${doctors.length}");
      } else {
        print("Failed to fetch doctors. Status: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching doctors: $e");
      setState(() => isLoading = false);
    }
  }

  void filterDoctors() {
    List<Map<String, dynamic>> temp = doctors.where((doc) {
      final name = (doc['name'] ?? '').toString().toLowerCase();
      final speciality = (doc['speciality'] ?? '').toString().toLowerCase();

      final searchMatch = name.contains(searchQuery.toLowerCase()) ||
          speciality.contains(searchQuery.toLowerCase());

      final categoryMatch = selectedCategory == 'All' ||
          speciality == selectedCategory.toLowerCase();

      return searchMatch && categoryMatch;
    }).toList();

    setState(() {
      filteredDoctors = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(6.0),
              child: Text(
                "Our Doctors",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String category = categories[index];
                bool isSelected = category == selectedCategory;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isSelected ? Colors.white : Colors.grey.shade200,
                      foregroundColor:
                      isSelected ? AppColors.primary : Colors.black,
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade400,
                        width: 1.2,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategory = category;
                        filterDoctors();
                      });
                    },
                    child: Text(
                      category,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredDoctors.isEmpty
                ? const Center(child: Text("No doctors found."))
                : ListView.builder(
              itemCount: filteredDoctors.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                return DoctorCard(doctor: doctor);
              },
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor['name'] ?? '',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(doctor['speciality'] ?? 'N/A',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      // Row(
                      //   children: [
                      //     Icon(Icons.local_hospital,
                      //         size: 16, color: AppColors.primary),
                      //     const SizedBox(width: 4),
                      //     Expanded(
                      //       child: Text(doctor['profile'] ?? '',
                      //           style: const TextStyle(
                      //               fontSize: 13, color: Colors.black87)),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Icon(Icons.email, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              doctor['email'] ?? '',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Icon(Icons.location_on,
                      //         size: 16, color: AppColors.primary),
                      //     const SizedBox(width: 4),
                      //     Expanded(
                      //       child: Text(
                      //         doctor['hospitalName'] ?? '',
                      //         style: const TextStyle(
                      //             fontSize: 12, color: Colors.black87),
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Icon(Icons.work, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text('${doctor['experience'] ?? 'N/A'} experience',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
