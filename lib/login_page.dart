import 'package:flutter/material.dart';
import 'main.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Padding(
          padding:EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
              SizedBox(height: 8),
              Text("Login to continue", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w700)),
        
              SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email or Phone",
                  border: OutlineInputBorder(),
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
              SizedBox(height: 24),
        
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xFF0D4F45),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                  ),
                  child: Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold ),),
                ),
              ),
              SizedBox(height: 12),
        
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context,'/otp_page');
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                  ),
                  child: Text("Login with OTP",style: TextStyle(color: Color(0xFF0D4F45),fontWeight: FontWeight.bold ),),
                ),
              ),
        
              SizedBox(height: 16),
              Center(
                child: Text("Forgot Password?", style: TextStyle(color: Colors.grey[600])),
              ),
              SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color:
                      Colors.black),
                      children: [
                        TextSpan(
                          text: "Register",
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
            ],
          ),
        ),
      ),
    );
  }
}
