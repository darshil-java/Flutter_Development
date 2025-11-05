import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'helper.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primary,
              AppColors.primary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header section - Flexible height
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo/Icon
                    Container(
                      width: 100, // Reduced size
                      height: 100, // Reduced size
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.medical_services,
                        size: 50, // Reduced size
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16), // Reduced spacing
                    const Text(
                      'Care Connect',
                      style: TextStyle(
                        fontSize: 28, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4), // Reduced spacing
                    Text(
                      'Your Trusted Health Companion',
                      style: TextStyle(
                        fontSize: 14, // Reduced font size
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),

              // Features section - Flexible with proper spacing
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.textLight,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        child: Column(
                          children: [
                            // Features list - Made scrollable if needed but constrained
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildFeature(
                                    icon: Icons.medical_services,
                                    title: 'Expert Doctors',
                                    subtitle: 'Consult with certified specialists',
                                  ),
                                  const SizedBox(height: 12), // Reduced spacing
                                  _buildFeature(
                                    icon: Icons.video_call,
                                    title: 'Online Consultations',
                                    subtitle: 'Get medical advice from home',
                                  ),
                                  const SizedBox(height: 12), // Reduced spacing
                                  _buildFeature(
                                    icon: Icons.security,
                                    title: 'Secure & Private',
                                    subtitle: 'Your health data is protected',
                                  ),
                                ],
                              ),
                            ),

                            // Spacer
                            const SizedBox(height: 16),

                            // Login Button - Fixed at bottom
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 5,
                                  shadowColor: const Color(0xFF0D4F45).withOpacity(0.3),
                                ),
                                onPressed: () => _navigateToLogin(context),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login, color: AppColors.textLight),
                                    SizedBox(width: 8), // Reduced spacing
                                    Text(
                                      'Get Started - Login',
                                      style: TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 16, // Reduced font size
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12), // Reduced radius
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 60, // Reduced size
            height: 60, // Reduced size
            decoration: BoxDecoration(
              color: const Color(0xFF0D4F45).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24, // Reduced size
            ),
          ),
          const SizedBox(width: 12), // Reduced spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16, // Reduced font size
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2), // Reduced spacing
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13, // Reduced font size
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}