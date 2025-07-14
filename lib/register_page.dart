import 'package:flutter/material.dart';
import 'main.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
          overscroll: false,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 50),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create Account",style: TextStyle(fontSize: 32,fontWeight: FontWeight.w700),),
                SizedBox(height: 8),
                Text("Please Fill Your Details",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey.shade600),),

                SizedBox(height: 32),
                Container(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Full Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                SizedBox(height: 16),
                Container(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Your Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                SizedBox(height: 16),
                Container(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      prefixText: "+91 ",
                      labelText: "Enter Your Phone Number",
                      counterText: "", //Remove the O to 10 which is bottom to this field
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                SizedBox(height: 16),
                Container(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Enter or pick date",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          }
                        },
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),

                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    items: ['Male', 'Female', 'Other'].map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                        .toList(),
                    onChanged: (value) {

                    },
                    decoration: const InputDecoration(
                      labelText: "Select Gender",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),


                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,                 // menu background
                    iconEnabledColor: Color(0xFF0D4F45),         // arrow color
                    style: TextStyle(                      // text inside field
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    isExpanded: true,
                    items: ['Hindi', 'English', 'Gujarati'].map((language) => DropdownMenuItem(
                      value: language,
                      child: Text(language),
                    ))
                        .toList(),
                    onChanged: (value) {

                    },
                    decoration: InputDecoration(
                      labelText: "Select Language",
                      border: OutlineInputBorder(),

                    ),
                  ),
                ),

                SizedBox(height: 16),
                TextField(
                  obscureText: _obscureText, // hide/show password
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText; // toggle
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 16),
                TextField(
                  obscureText: _obscureText, // hide/show password
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText; // toggle
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xFF0D4F45),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                    ),
                    child: Text("Register",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold ),),
                  ),
                ),

                SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "already have an account? ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: Color(0xFF0D4F45),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height:50),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

