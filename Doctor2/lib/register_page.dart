// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'helper.dart';
//
// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});
//
//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }
//
// class _RegisterPageState extends State<RegisterPage> {
//   bool _obscurepassword = true;
//   bool _obscureconfirm = true;
//   bool isSubmitted = false;
//   bool isLoading = false;
//
//   final ScrollController _scrollController = ScrollController();
//
//   // Dropdown states
//   String? selectedgender;
//   String? selectedType;
//   String? selectedSpeciality;
//
//   // Controllers
//   final GlobalKey<FormState> formkey = GlobalKey<FormState>();
//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController hospitalController = TextEditingController();
//   final TextEditingController feesController = TextEditingController();
//   final TextEditingController experienceController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmController = TextEditingController();
//
//   // ================= REGISTER USER =================
//   Future<void> registerUser() async {
//     setState(() => isLoading = true);
//
//     try {
//       final url = Uri.parse(ApiConfig.register);
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "name": fullNameController.text.trim(),
//           "email": emailController.text.trim(),
//           "phone": phoneController.text.trim(),
//           "gender": selectedgender ?? "",
//           "type": selectedType ?? "",
//           "speciality": selectedSpeciality ?? "",
//           "hospital": hospitalController.text.trim(),
//           "fees": feesController.text.trim(),
//           "experience": experienceController.text.trim(),
//           "password": passwordController.text.trim(),
//           "confirmPassword": confirmController.text.trim(),
//         }),
//       );
//
//       final responseData = jsonDecode(response.body);
//
//       if (response.statusCode == 201) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('fullName', fullNameController.text.trim());
//         await prefs.setString('email', emailController.text.trim());
//         await prefs.setString('phone', phoneController.text.trim());
//         await prefs.setString('gender', selectedgender ?? '');
//         await prefs.setString('type', selectedType ?? '');
//         await prefs.setString('speciality', selectedSpeciality ?? '');
//         await prefs.setString('hospital', hospitalController.text.trim());
//         await prefs.setString('fees', feesController.text.trim());
//         await prefs.setString('experience', experienceController.text.trim());
//
//         Helpers.showSnackBar(context, "Registered Successfully",
//             bgColor: AppColors.primary);
//
//         Navigator.pushReplacementNamed(context, '/login');
//       } else {
//         Helpers.showSnackBar(
//           context,
//           responseData['message'] ?? "Registration failed",
//           bgColor: Colors.redAccent,
//         );
//       }
//     } catch (e) {
//       Helpers.showSnackBar(context, "Error: $e", bgColor: Colors.redAccent);
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   void submit() {
//     setState(() => isSubmitted = true);
//
//     if (formkey.currentState!.validate()) {
//       if (selectedType == "Allopathy" &&
//           (selectedSpeciality == null || selectedSpeciality!.isEmpty)) {
//         Helpers.showSnackBar(
//             context, "Please select a Speciality for Allopathy doctors",
//             bgColor: Colors.redAccent);
//         return;
//       }
//
//       if (selectedType != "Allopathy") selectedSpeciality = "";
//
//       registerUser();
//     } else {
//       // Show generic error if form fields are empty
//       Helpers.showSnackBar(
//           context, "All fields are required", bgColor: Colors.redAccent);
//     }
//   }
//
//   // ================= VALIDATORS =================
//   String? validatename(String? value) {
//     if (value == null || value.isEmpty) return "Please enter your name";
//     if (!RegExp(r'^[A-Za-z_ ]+$').hasMatch(value)) return "Use letters only";
//     return null;
//   }
//
//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) return "Please enter email";
//     if (!Helpers.isValidEmail(value)) return "Enter a valid email";
//     return null;
//   }
//
//   String? validatePhone(String? value) {
//     if (value == null || value.isEmpty) return "Please enter phone number";
//     if (!Helpers.isValidPhone(value)) return "Enter a valid phone number";
//     return null;
//   }
//
//   String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) return "Please enter password";
//     if (value.length < 8 || value.length > 12) {
//       return "Password must be 8–12 characters";
//     }
//     if (!RegExp(r'[A-Za-z]').hasMatch(value)) return "Include at least one letter";
//     if (!RegExp(r'\d').hasMatch(value)) return "Include at least one digit";
//     if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
//       return "Include at least one special character";
//     }
//     return null;
//   }
//
//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
//         child: Scrollbar(
//           controller: _scrollController,
//           // thumbVisibility: true,
//           thumbVisibility: false, // Hide by default
//           trackVisibility: false, // Hide track
//           child: SingleChildScrollView(
//             controller: _scrollController,
//             child: Form(
//               key: formkey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Create Account",
//                       style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.primary)),
//                   const SizedBox(height: 8),
//                   Text("Please Fill Your Details",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           color: Colors.grey.shade600)),
//                   const SizedBox(height: 32),
//
//                   // Full Name
//                   TextFormField(
//                     controller: fullNameController,
//                     decoration: const InputDecoration(
//                       labelText: "Full Name",
//                       hintText: "eg. Darshil Agrawal",
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: validatename,
//                     autovalidateMode: isSubmitted
//                         ? AutovalidateMode.onUserInteraction
//                         : AutovalidateMode.disabled,
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Email
//                   TextFormField(
//                     controller: emailController,
//                     decoration: const InputDecoration(
//                       labelText: "Email",
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: validateEmail,
//                     autovalidateMode: isSubmitted
//                         ? AutovalidateMode.onUserInteraction
//                         : AutovalidateMode.disabled,
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Phone
//                   TextFormField(
//                     controller: phoneController,
//                     keyboardType: TextInputType.phone,
//                     maxLength: 10,
//                     decoration: const InputDecoration(
//                       prefixText: "+91 ",
//                       labelText: "Phone Number",
//                       counterText: "",
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: validatePhone,
//                     autovalidateMode: isSubmitted
//                         ? AutovalidateMode.onUserInteraction
//                         : AutovalidateMode.disabled,
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Gender Dropdown
//                   buildDropdown(
//                       "Gender", ["Male", "Female", "Other"], selectedgender,
//                           (val) => setState(() => selectedgender = val)),
//                   const SizedBox(height: 16),
//
//                   // Type Dropdown
//                   buildDropdown(
//                       "Type", ["Allopathy", "Ayurvedic", "Homeopathy"], selectedType,
//                           (val) => setState(() {
//                         selectedType = val;
//                         selectedSpeciality = null;
//                       })),
//                   const SizedBox(height: 16),
//
//                   // Speciality Dropdown (Only for Allopathy)
//                   if (selectedType == "Allopathy")
//                     Column(
//                       children: [
//                         buildDropdown(
//                             "Speciality",
//                             ["MBBS", "MD", "Dentist", "Cardiologist"],
//                             selectedSpeciality,
//                                 (val) => setState(() => selectedSpeciality = val)),
//                         const SizedBox(height: 16),
//                       ],
//                     ),
//
//                   // Hospital Name
//                   TextFormField(
//                     controller: hospitalController,
//                     decoration: const InputDecoration(
//                       labelText: "Hospital Name",
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (val) =>
//                     val == null || val.isEmpty ? "Please enter hospital name" : null,
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Fees
//                   TextFormField(
//                     controller: feesController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: "Fees (₹)",
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (val) =>
//                     val == null || val.isEmpty ? "Please enter fees" : null,
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Experience
//                   TextFormField(
//                     controller: experienceController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: "Experience (Years)",
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (val) =>
//                     val == null || val.isEmpty ? "Please enter experience" : null,
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Password
//                   TextFormField(
//                     controller: passwordController,
//                     obscureText: _obscurepassword,
//                     decoration: InputDecoration(
//                       labelText: "Password",
//                       border: const OutlineInputBorder(),
//                       suffixIcon: IconButton(
//                         icon: Icon(_obscurepassword
//                             ? Icons.visibility_off
//                             : Icons.visibility),
//                         onPressed: () =>
//                             setState(() => _obscurepassword = !_obscurepassword),
//                       ),
//                     ),
//                     validator: validatePassword,
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Confirm Password
//                   TextFormField(
//                     controller: confirmController,
//                     obscureText: _obscureconfirm,
//                     decoration: InputDecoration(
//                       labelText: "Confirm Password",
//                       border: const OutlineInputBorder(),
//                       suffixIcon: IconButton(
//                         icon: Icon(_obscureconfirm
//                             ? Icons.visibility_off
//                             : Icons.visibility),
//                         onPressed: () =>
//                             setState(() => _obscureconfirm = !_obscureconfirm),
//                       ),
//                     ),
//                     validator: (val) {
//                       if (val == null || val.isEmpty) {
//                         return "Please confirm password";
//                       }
//                       if (val != passwordController.text) {
//                         return "Passwords do not match";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Register Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 48,
//                     child: ElevatedButton(
//                       onPressed: isLoading ? null : submit,
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary),
//                       child: isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text("Register",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Reusable dropdown
//   Widget buildDropdown(
//       String label, List<String> items, String? selectedValue, Function(String) onSelected) {
//     return InputDecorator(
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       ),
//       child: ExpansionTile(
//         key: UniqueKey(),
//         tilePadding: EdgeInsets.zero,
//         dense: true,
//         title: Text(selectedValue ?? "Select $label",
//             style: const TextStyle(fontSize: 16)),
//         trailing: const Icon(Icons.arrow_drop_down),
//         children: items
//             .map((item) => ListTile(
//           title: Text(item),
//           onTap: () => onSelected(item),
//         ))
//             .toList(),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurepassword = true;
  bool _obscureconfirm = true;
  bool isSubmitted = false;
  bool isLoading = false;

  // Dropdown states
  String? selectedgender;
  String? selectedType;
  String? selectedSpeciality;

  // Controllers
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController feesController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  // ================= REGISTER USER =================
  Future<void> registerUser() async {
    setState(() => isLoading = true);

    try {
      final url = Uri.parse(ApiConfig.register);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": fullNameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "gender": selectedgender ?? "",
          "type": selectedType ?? "",
          "speciality": selectedSpeciality ?? "",
          "hospital": hospitalController.text.trim(),
          "fees": feesController.text.trim(),
          "experience": experienceController.text.trim(),
          "password": passwordController.text.trim(),
          "confirmPassword": confirmController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fullName', fullNameController.text.trim());
        await prefs.setString('email', emailController.text.trim());
        await prefs.setString('phone', phoneController.text.trim());
        await prefs.setString('gender', selectedgender ?? '');
        await prefs.setString('type', selectedType ?? '');
        await prefs.setString('speciality', selectedSpeciality ?? '');
        await prefs.setString('hospital', hospitalController.text.trim());
        await prefs.setString('fees', feesController.text.trim());
        await prefs.setString('experience', experienceController.text.trim());

        Helpers.showSnackBar(context, "Registered Successfully",
            bgColor: AppColors.primary);

        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Helpers.showSnackBar(
          context,
          responseData['message'] ?? "Registration failed",
          bgColor: Colors.redAccent,
        );
      }
    } catch (e) {
      Helpers.showSnackBar(context, "Error: $e", bgColor: Colors.redAccent);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void submit() {
    setState(() => isSubmitted = true);

    if (formkey.currentState!.validate()) {
      if (selectedType == "Allopathy" &&
          (selectedSpeciality == null || selectedSpeciality!.isEmpty)) {
        Helpers.showSnackBar(
            context, "Please select a Speciality for Allopathy doctors",
            bgColor: Colors.redAccent);
        return;
      }

      if (selectedType != "Allopathy") selectedSpeciality = "";

      registerUser();
    } else {
      // Show generic error if form fields are empty
      Helpers.showSnackBar(
          context, "All fields are required", bgColor: Colors.redAccent);
    }
  }

  // ================= VALIDATORS =================
  String? validatename(String? value) {
    if (value == null || value.isEmpty) return "Please enter your name";
    if (!RegExp(r'^[A-Za-z_ ]+$').hasMatch(value)) return "Use letters only";
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Please enter email";
    if (!Helpers.isValidEmail(value)) return "Enter a valid email";
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Please enter phone number";
    if (!Helpers.isValidPhone(value)) return "Enter a valid phone number";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Please enter password";
    if (value.length < 8 || value.length > 12) {
      return "Password must be 8–12 characters";
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) return "Include at least one letter";
    if (!RegExp(r'\d').hasMatch(value)) return "Include at least one digit";
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Include at least one special character";
    }
    return null;
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Create Account",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
                const SizedBox(height: 8),
                Text("Please Fill Your Details",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600)),
                const SizedBox(height: 32),

                // Full Name
                TextFormField(
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    hintText: "eg. Xyz Abcd",
                    border: OutlineInputBorder(),
                  ),
                  validator: validatename,
                  autovalidateMode: isSubmitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: validateEmail,
                  autovalidateMode: isSubmitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    prefixText: "+91 ",
                    labelText: "Phone Number",
                    counterText: "",
                    border: OutlineInputBorder(),
                  ),
                  validator: validatePhone,
                  autovalidateMode: isSubmitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                ),
                const SizedBox(height: 16),

                // Gender Dropdown
                buildDropdown(
                    "Gender", ["Male", "Female", "Other"], selectedgender,
                        (val) => setState(() => selectedgender = val)),
                const SizedBox(height: 16),

                // Type Dropdown
                buildDropdown(
                    "Type", ["Allopathy", "Ayurvedic", "Homeopathy"], selectedType,
                        (val) => setState(() {
                      selectedType = val;
                      selectedSpeciality = null;
                    })),
                const SizedBox(height: 16),

                // Speciality Dropdown (Only for Allopathy)
                if (selectedType == "Allopathy")
                  Column(
                    children: [
                      buildDropdown(
                          "Speciality",
                          ["MBBS", "MD", "Dentist", "Cardiologist"],
                          selectedSpeciality,
                              (val) => setState(() => selectedSpeciality = val)),
                      const SizedBox(height: 16),
                    ],
                  ),

                // Hospital Name
                TextFormField(
                  controller: hospitalController,
                  decoration: const InputDecoration(
                    labelText: "Hospital Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Please enter hospital name" : null,
                ),
                const SizedBox(height: 16),

                // Fees
                TextFormField(
                  controller: feesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Fees (₹)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Please enter fees" : null,
                ),
                const SizedBox(height: 16),

                // Experience
                TextFormField(
                  controller: experienceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Experience (Years)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Please enter experience" : null,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurepassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurepassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscurepassword = !_obscurepassword),
                    ),
                  ),
                  validator: validatePassword,
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: confirmController,
                  obscureText: _obscureconfirm,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureconfirm
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscureconfirm = !_obscureconfirm),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please confirm password";
                    }
                    if (val != passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : submit,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Register",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable dropdown
  Widget buildDropdown(
      String label, List<String> items, String? selectedValue, Function(String) onSelected) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      child: ExpansionTile(
        key: UniqueKey(),
        tilePadding: EdgeInsets.zero,
        dense: true,
        title: Text(selectedValue ?? "Select $label",
            style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_drop_down),
        children: items
            .map((item) => ListTile(
          title: Text(item),
          onTap: () => onSelected(item),
        ))
            .toList(),
      ),
    );
  }
}