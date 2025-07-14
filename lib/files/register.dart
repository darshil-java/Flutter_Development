//
//
// import 'package:flutter/material.dart';
// import 'main.dart';
// import 'login_page.dart';
//
// class RegisterPage extends StatefulWidget {
//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }
//
// class _RegisterPageState extends State<RegisterPage> {
//   bool _obscureText = true;
//
//   final TextEditingController nameController=TextEditingController();
//   final TextEditingController emailController=TextEditingController();
//   final TextEditingController phoneController=TextEditingController();
//   final TextEditingController passwordController=TextEditingController();
//   final TextEditingController confirm_passwordController=TextEditingController();
//   final TextEditingController dateController=TextEditingController();
//
//
//   String?selectedGender;
//   String?selectedLanguage;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       body: ScrollConfiguration(
//         behavior: ScrollConfiguration.of(context).copyWith(
//           scrollbars: false,
//           overscroll: false,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 50),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Create Account",style: TextStyle(fontSize: 32,fontWeight: FontWeight.w700),),
//                 SizedBox(height: 8),
//                 Text("Please Fill Your Details",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey.shade600),),
//
//                 SizedBox(height: 32),
//                 Container(
//                   child: TextField(
//                     controller: nameController,
//                     decoration: InputDecoration(
//                       labelText: "Enter Full Name",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 16),
//                 Container(
//                   child: TextField(
//                     controller: emailController,
//                     decoration: InputDecoration(
//                       labelText: "Enter Your Email",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 16),
//                 Container(
//                   child: TextField(
//                     controller: phoneController,
//                     keyboardType: TextInputType.number,
//                     maxLength: 10,
//                     decoration: InputDecoration(
//                       labelText: "Enter Your Phone Number",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 16),
//                 Container(
//                   child: TextField(
//                     controller: dateController,
//                     decoration: InputDecoration(
//                       labelText: "Enter or pick date",
//                       border: const OutlineInputBorder(),
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.calendar_month),
//                         onPressed: () async {
//                           DateTime? pickedDate = await showDatePicker(
//                             context: context,
//                             firstDate: DateTime(1900),
//                             lastDate: DateTime(2100),
//                           );
//                           if (pickedDate != null) {
//                             String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//                             dateController.text=formattedDate;
//                           }
//                         },
//                       ),
//                     ),
//                     keyboardType: TextInputType.datetime,
//                   ),
//                 ),
//
//                 SizedBox(height: 16),
//                 Container(
//                   child: DropdownButtonFormField<String>(
//                     items: ['Male', 'Female', 'Other'].map((gender) => DropdownMenuItem(
//                       value: gender,
//                       child: Text(gender),
//                     ))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedGender=value!;
//                       });
//                     },
//                     decoration: const InputDecoration(
//                       labelText: "Select Gender",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//
//
//                 SizedBox(height: 16),
//                 Container(
//                   child: DropdownButtonFormField<String>(
//                     isExpanded: true,
//                     items: ['Hindi', 'English', 'Gujarati'].map((language) => DropdownMenuItem(
//                       value: language,
//                       child: Text(language),
//                     ))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedLanguage=value!;
//                       });
//                     },
//                     decoration: const InputDecoration(
//                       labelText: "Select Language",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: passwordController,
//                   obscureText: _obscureText, // hide/show password
//                   decoration: InputDecoration(
//                     labelText: "Enter Password",
//                     border: OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscureText ? Icons.visibility_off : Icons.visibility,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscureText = !_obscureText; // toggle
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 16),
//                 TextField(
//                   obscureText: _obscureText, //
//                   controller: confirm_passwordController,// hide/show password
//                   decoration: InputDecoration(
//                     labelText: "Confirm Password",
//                     border: OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscureText ? Icons.visibility_off : Icons.visibility,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscureText = !_obscureText; // toggle
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 16),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 48,
//                   child: OutlinedButton(
//                     onPressed: () {
//                       Navigator.pushReplacementNamed(context, '/home',
//                           arguments:{
//                             'name':nameController.text,
//                             'email':emailController.text,
//                             'phone':phoneController.text,
//                             'dob':dateController.text,
//                             'gender':selectedGender,
//                             'KnownLanguage':selectedLanguage,
//                             'password':passwordController.text,
//                             'confirmPassword':confirm_passwordController.text,
//                           }
//                       );
//                     },
//                     style: OutlinedButton.styleFrom(
//                       backgroundColor: Color(0xFF0D4F45),
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(7)),
//                       ),
//                     ),
//                     child: Text("Register",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold ),),
//                   ),
//                 ),
//
//                 SizedBox(height: 12),
//                 Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, '/login');
//                     },
//                     child: RichText(
//                       text: TextSpan(
//                         text: "already have an account? ",
//                         style: TextStyle(color: Colors.black),
//                         children: [
//                           TextSpan(
//                             text: "Login",
//                             style: TextStyle(
//                               color: Color(0xFF0D4F45),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
