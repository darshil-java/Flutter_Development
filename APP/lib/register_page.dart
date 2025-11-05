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
  bool _isGenderExpanded = false;
  String? selectedgender;
  bool _isLanguageExpanded = false;
  String? selectedLanguage;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final TextEditingController dobController = TextEditingController();


  // ================= REGISTER USER =================
  Future<void> registerUser() async {
    setState(() => isLoading = true);

    try {
      final url = Uri.parse(ApiConfig.register);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullname': fullNameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'birthdate': dobController.text.trim(),
          'gender': selectedgender,
          'language': selectedLanguage,
          'password': passwordController.text.trim(),
          'confirmPassword': confirmController.text.trim()
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Save user data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fullName', fullNameController.text.trim());
        await prefs.setString('email', emailController.text.trim());
        await prefs.setString('phone', phoneController.text.trim());
        await prefs.setString('dob', dobController.text.trim());
        await prefs.setString('gender', selectedgender ?? '');
        await prefs.setString('language', selectedLanguage ?? '');

        Helpers.showSnackBar(context, "Registered Successfully", bgColor: AppColors.primary);

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
      registerUser();
    }
  }

  // ================= VALIDATORS =================
  String? validatename(String? value) {
    if (value == null || value.isEmpty) return "Please enter your username";
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
    if (value.length < 8 || value.length > 12) return "Password must be 8–12 characters";
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) return "Include at least one letter";
    if (!RegExp(r'\d').hasMatch(value)) return "Include at least one digit";
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) return "Include at least one special character";
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
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700,color: AppColors.primary)),
                const SizedBox(height: 8),
                Text("Please Fill Your Details",
                    style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
                const SizedBox(height: 32),

                TextFormField(
                  maxLength: 29,
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    labelText: "Enter Full Name",
                    hintText: "eg. Xyz Abcd",
                    hintStyle: TextStyle(color: Colors.grey), // consistent grey
                    counterText: "",
                    border: OutlineInputBorder(),
                  ),
                  validator: validatename,
                  autovalidateMode: isSubmitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Enter Your Email",
                    hintText: "eg. xyz@gmail.com",
                    hintStyle: TextStyle(color: Colors.grey), // consistent grey
                    border: OutlineInputBorder(),
                  ),
                  validator: validateEmail,
                  autovalidateMode: isSubmitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    prefixText: "+91 ",
                    labelText: "Enter Your Phone Number",
                    hintStyle: TextStyle(color: Colors.grey), // consistent grey
                    border: OutlineInputBorder(),
                    counterText: "",
                  ),
                  validator: validatePhone,
                  autovalidateMode: isSubmitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: dobController,
                  decoration: InputDecoration(
                    labelText: "Enter Birth Date",
                    hintText: "DD/MM/YYYY",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          dobController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        }
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter your birth date";
                    try {
                      List<String> parts = value.split('/');
                      if (parts.length != 3) return "Enter date in DD/MM/YYYY format";
                      int day = int.parse(parts[0]);
                      int month = int.parse(parts[1]);
                      int year = int.parse(parts[2]);
                      DateTime dob = DateTime(year, month, day);
                      DateTime today = DateTime.now();
                      int age = today.year - dob.year;
                      if (today.month < dob.month ||
                          (today.month == dob.month && today.day < dob.day)) age--;
                      if (age < 18) return "You must be at least 18 years old";
                    } catch (e) {
                      return "Invalid date format";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Gender",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "Select your gender",
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                            errorText: state.hasError ? state.errorText : null,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              key: UniqueKey(),
                              tilePadding: EdgeInsets.zero,
                              childrenPadding: EdgeInsets.zero,
                              dense: true,
                              initiallyExpanded: _isGenderExpanded,
                              onExpansionChanged: (expanded) {
                                setState(() => _isGenderExpanded = expanded);
                              },
                              title: Text(
                                selectedgender ?? "Select Gender",
                                style: TextStyle(
                                  color: selectedgender == null ? Colors.black : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_drop_down, color: Colors.black),
                              children: [
                                Column(
                                  children: ["Male", "Female", "Other"]
                                      .map((g) => ListTile(
                                    dense: true,
                                    minVerticalPadding: 0,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                    title: Text(g, style: const TextStyle(fontSize: 16)),
                                    onTap: () {
                                      setState(() {
                                        selectedgender = g;
                                        _isGenderExpanded = false;
                                        state.didChange(g);
                                      });
                                    },
                                  ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),

                FormField<String>(

                  builder: (FormFieldState<String> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Language",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "Select your language",
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                            errorText: state.hasError ? state.errorText : null,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              key: UniqueKey(),
                              tilePadding: EdgeInsets.zero,
                              childrenPadding: EdgeInsets.zero,
                              dense: true,
                              initiallyExpanded: _isLanguageExpanded,
                              onExpansionChanged: (expanded) {
                                setState(() => _isLanguageExpanded = expanded);
                              },
                              title: Text(
                                selectedLanguage ?? "Select Language",
                                style: TextStyle(
                                  color: selectedLanguage == null ? Colors.black : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_drop_down, color: Colors.black),
                              children: [
                                Column(
                                  children: ["Hindi", "English", "Gujarati"]
                                      .map((lang) => ListTile(
                                    dense: true,
                                    minVerticalPadding: 0,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                    title: Text(lang, style: const TextStyle(fontSize: 16)),
                                    onTap: () {
                                      setState(() {
                                        selectedLanguage = lang;
                                        _isLanguageExpanded = false;
                                        state.didChange(lang);
                                      });
                                    },
                                  ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurepassword,
                  maxLength: 12,
                  decoration: InputDecoration(
                    counterText: "",
                    labelText: "Enter Password",
                    hintText: "Xyz@123",
                    hintStyle: TextStyle(color: Colors.grey), // consistent grey
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscurepassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurepassword = !_obscurepassword),
                    ),
                  ),
                  validator: validatePassword,
                  autovalidateMode: isSubmitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: confirmController,
                  obscureText: _obscureconfirm,
                  maxLength: 12,
                  decoration: InputDecoration(
                    counterText: "",
                    labelText: "Confirm Password",
                    hintText: "Xyz@123",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscureconfirm ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureconfirm = !_obscureconfirm),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please repeat password";
                    if (value != passwordController.text) return "Passwords do not match";
                    return null;
                  },
                  autovalidateMode: isSubmitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: isLoading ? null : submit,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Register",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: RichText(
                      text: const TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
