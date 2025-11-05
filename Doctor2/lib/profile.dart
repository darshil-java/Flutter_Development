// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'helper.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   String fullName = '';
//   String email = '';
//   String phone = '';
//   String dob = '';
//   String gender = '';
//   String language = '';
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }
//
//   Future<void> loadUserData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       email = prefs.getString('email') ?? '';
//       fullName = prefs.getString('fullName') ?? 'No Name';
//       phone = prefs.getString('phone') ?? 'No Phone';
//       dob = prefs.getString('dob') ?? 'No DOB';
//       gender = prefs.getString('gender') ?? 'Not specified';
//       language = prefs.getString('language') ?? 'Not specified';
//
//       if (email.isEmpty) {
//         Helpers.showSnackBar(
//           context,
//           "No user email found",
//           bgColor: AppColors.buttonPrimary,
//         );
//       }
//
//       setState(() => isLoading = false);
//     } catch (e) {
//       setState(() => isLoading = false);
//       Helpers.showSnackBar(
//         context,
//         "Error loading data: $e",
//         bgColor: Colors.red,
//       );
//     }
//   }
//
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     Navigator.pushReplacementNamed(context, '/login');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white), // Keep back arrow white
//         backgroundColor: AppColors.primary,
//         title: const Text(
//           "Profile",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Card(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12)),
//           elevation: 3,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 ProfileItem(
//                     icon: Icons.person,
//                     label: "Full Name",
//                     value: fullName),
//                 const Divider(),
//                 ProfileItem(icon: Icons.email, label: "Email", value: email),
//                 const Divider(),
//                 ProfileItem(icon: Icons.phone, label: "Phone", value: phone),
//                 const Divider(),
//                 ProfileItem(
//                     icon: Icons.cake, label: "Date of Birth", value: dob),
//                 const Divider(),
//                 ProfileItem(icon: Icons.male, label: "Gender", value: gender),
//                 const Divider(),
//                 ProfileItem(
//                     icon: Icons.language, label: "Language", value: language),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ProfileItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//
//   const ProfileItem(
//       {Key? key, required this.icon, required this.label, required this.value})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           // Use profileiconColor here
//           Icon(icon, color: AppColors.profileiconColor),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                       color: AppColors.textDark),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: TextStyle(
//                       fontSize: 14, color: AppColors.textDark.withOpacity(0.7)),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  Map<String, dynamic> doctor = {};

  @override
  void initState() {
    super.initState();
    fetchDoctorProfile();
  }

  Future<void> fetchDoctorProfile() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        Helpers.showSnackBar(context, "No token found, please login", bgColor: Colors.red);
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final url = Uri.parse(ApiConfig.profile); // your API endpoint
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          doctor = data['data']['doctor'] ?? {};
          isLoading = false;
        });
      } else {
        Helpers.showSnackBar(
            context, data['message'] ?? 'Failed to fetch profile', bgColor: Colors.red);
        setState(() => isLoading = false);
      }
    } catch (e) {
      Helpers.showSnackBar(context, "Error: $e", bgColor: Colors.red);
      setState(() => isLoading = false);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.iconColor),
        backgroundColor: AppColors.primary,
        centerTitle: true, // <-- this ensures proper centering
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),


      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ProfileItem(
                    icon: Icons.person,
                    label: "Full Name",
                    value: doctor['name'] ?? 'No Name'),
                const Divider(),
                ProfileItem(
                    icon: Icons.email, label: "Email", value: doctor['email'] ?? ''),
                const Divider(),
                ProfileItem(
                    icon: Icons.phone, label: "Phone", value: doctor['phone'] ?? ''),
                const Divider(),
                ProfileItem(
                    icon: Icons.male, label: "Gender", value: doctor['gender'] ?? ''),
                const Divider(),
                ProfileItem(
                    icon: Icons.star,
                    label: "Speciality",
                    value: doctor['speciality'] ?? ''),
                const Divider(),
                ProfileItem(
                    icon: Icons.local_hospital,
                    label: "Hospital",
                    value: doctor['hospital'] ?? ''),
                const Divider(),
                ProfileItem(
                    icon: Icons.currency_rupee,
                    label: "Fees",
                    value: doctor['fees']?.toString() ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileItem(
      {Key? key, required this.icon, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.profileiconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(value,
                    style: TextStyle(
                        fontSize: 14, color: AppColors.textDark.withOpacity(0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

