import 'package:flutter/material.dart';
import 'main.dart';
import 'login_page.dart';

class OtpLoginPage extends StatefulWidget {
  const OtpLoginPage({super.key});

  @override
  State<OtpLoginPage> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: SingleChildScrollView(
            child: Padding(
              padding:EdgeInsets.symmetric(horizontal: 24,vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter Phone No", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
                  SizedBox(height: 8),
                  Text("For LogIn", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w700)),
                  SizedBox(height: 32),

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

                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index){
                      return Container(
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                        ),
                      );
                  }),
                  ),

                  SizedBox(height: 20,),
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


                  SizedBox(height: 20,),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Prefer Password Login? ",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Password Login",
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

                  SizedBox(height: 20,),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't Have an Account? ",
                          style: TextStyle(color: Colors.black),
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
