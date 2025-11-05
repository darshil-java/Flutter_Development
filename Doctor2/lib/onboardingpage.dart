// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'login_page.dart';
// // import 'home_page.dart';
// //
// // class OnboardingPage extends StatefulWidget {
// //   const OnboardingPage({super.key});
// //
// //   @override
// //   State<OnboardingPage> createState() => _OnboardingPageState();
// // }
// //
// // class _OnboardingPageState extends State<OnboardingPage> {
// //   final PageController _controller = PageController();
// //   int _currentPage = 0;
// //
// //   final List<Map<String, String>> _introPages = [
// //     {
// //       "image": "assets/images/intro1.jpg",
// //       // "title": "Welcome to VSG Logic",
// //       // "desc": "Your trusted health companion with clear and reliable advice.",
// //     },
// //     {
// //       "image": "assets/images/intro2.jpg",
// //       // "title": "Consult with Experts",
// //       // "desc": "Connect with top doctors and specialists anytime, anywhere.",
// //     },
// //     {
// //       "image": "assets/images/intro3.jpg",
// //       // "title": "Upload and Track Reports",
// //       // "desc": "Easily upload your health reports and manage them securely.",
// //     },
// //   ];
// //
// //   void _goToNext() {
// //     if (_currentPage == _introPages.length - 1) {
// //       _finishOnboarding();
// //     } else {
// //       _controller.nextPage(
// //           duration: Duration(milliseconds: 300), curve: Curves.easeIn);
// //     }
// //   }
// //
// //   void _skip() {
// //     _finishOnboarding();
// //   }
// //
// //   Future<void> _finishOnboarding() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
// //
// //     Navigator.pushReplacement(
// //       context,
// //       MaterialPageRoute(
// //           builder: (context) => isLoggedIn ? HomePage() : LoginPage()),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             Expanded(
// //               child: PageView.builder(
// //                 controller: _controller,
// //                 onPageChanged: (index) {
// //                   setState(() {
// //                     _currentPage = index;
// //                   });
// //                 },
// //                 itemCount: _introPages.length,
// //                 itemBuilder: (context, index) {
// //                   final page = _introPages[index];
// //                   return Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Image.asset(page["image"]!, height: 300),
// //                       SizedBox(height: 20),
// //                       Text(
// //                         page["title"]!,
// //                         style: TextStyle(
// //                             fontSize: 24, fontWeight: FontWeight.bold),
// //                       ),
// //                       SizedBox(height: 12),
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 24),
// //                         child: Text(
// //                           page["desc"]!,
// //                           textAlign: TextAlign.center,
// //                           style: TextStyle(fontSize: 16, color: Colors.grey[700]),
// //                         ),
// //                       ),
// //                     ],
// //                   );
// //                 },
// //               ),
// //             ),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: List.generate(
// //                 _introPages.length,
// //                     (index) => Container(
// //                   margin: EdgeInsets.all(4),
// //                   width: _currentPage == index ? 12 : 8,
// //                   height: _currentPage == index ? 12 : 8,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color: _currentPage == index
// //                         ? Colors.teal
// //                         : Colors.grey.shade400,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   TextButton(
// //                     onPressed: _skip,
// //                     child: Text("Skip",
// //                         style: TextStyle(color: Colors.grey, fontSize: 16)),
// //                   ),
// //                   ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Color(0xFF0D4F45),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                     ),
// //                     onPressed: _goToNext,
// //                     child: Text(
// //                       _currentPage == _introPages.length - 1
// //                           ? "Get Started"
// //                           : "Next",
// //                       style: TextStyle(color: Colors.white),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'login_page.dart';
// import 'home_page.dart';
//
// class OnboardingPage extends StatefulWidget {
//   const OnboardingPage({super.key});
//
//   @override
//   State<OnboardingPage> createState() => _OnboardingPageState();
// }
//
// class _OnboardingPageState extends State<OnboardingPage> {
//   final PageController _controller = PageController();
//   int _currentPage = 0;
//
//   final List<Map<String, String>> _introPages = [
//     {
//       "image": "assets/images/intro1.jpg",
//       "title": "Welcome to Health Buddy",
//       "desc": "Your trusted health companion with clear and reliable medical advice from certified doctors.",
//     },
//     {
//       "image": "assets/images/intro2.jpg",
//       "title": "Consult with Experts",
//       "desc": "Connect with top doctors and specialists anytime, anywhere for personalized healthcare.",
//     },
//     {
//       "image": "assets/images/intro3.jpg",
//       "title": "Secure & Confidential",
//       "desc": "Your health data is protected with enterprise-grade security and privacy measures.",
//     },
//   ];
//
//   void _goToNext() {
//     if (_currentPage == _introPages.length - 1) {
//       _finishOnboarding();
//     } else {
//       _controller.nextPage(
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void _skip() {
//     _finishOnboarding();
//   }
//
//   Future<void> _finishOnboarding() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('onboardingCompleted', true);
//
//     final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//
//     if (mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => isLoggedIn ? const HomePage() : const LoginPage(),
//         ),
//       );
//     }
//   }
//
//   // Simple image widget with error handling
//   Widget _buildImage(String imagePath, BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.8,
//       height: MediaQuery.of(context).size.height * 0.4,
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.grey[100],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: Image.asset(
//           imagePath,
//           fit: BoxFit.contain,
//           errorBuilder: (context, error, stackTrace) {
//             // Fallback UI if image fails to load
//             return Container(
//               color: Colors.grey[200],
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.medical_services,
//                     size: 80,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Health Buddy',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Size screenSize = MediaQuery.of(context).size;
//     final bool isSmallScreen = screenSize.height < 600;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Skip button at top
//             Align(
//               alignment: Alignment.topRight,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextButton(
//                   onPressed: _skip,
//                   child: Text(
//                     "Skip",
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // Main content area
//             Expanded(
//               flex: 3,
//               child: PageView.builder(
//                 controller: _controller,
//                 onPageChanged: (index) {
//                   setState(() {
//                     _currentPage = index;
//                   });
//                 },
//                 itemCount: _introPages.length,
//                 itemBuilder: (context, index) {
//                   final page = _introPages[index];
//                   return SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // Image with responsive sizing
//                           _buildImage(page["image"]!, context),
//
//                           SizedBox(height: isSmallScreen ? 20 : 40),
//
//                           // Title
//                           Text(
//                             page["title"]!,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 22 : 28,
//                               fontWeight: FontWeight.bold,
//                               color: const Color(0xFF0D4F45),
//                             ),
//                           ),
//
//                           SizedBox(height: isSmallScreen ? 12 : 20),
//
//                           // Description
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             child: Text(
//                               page["desc"]!,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: isSmallScreen ? 14 : 16,
//                                 color: Colors.grey[700],
//                                 height: 1.5,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // Bottom section with dots and button
//             Expanded(
//               flex: 1,
//               child: Column(
//                 children: [
//                   // Page indicator dots
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(
//                       _introPages.length,
//                           (index) => AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         margin: const EdgeInsets.all(4),
//                         width: _currentPage == index ? 24 : 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4),
//                           color: _currentPage == index
//                               ? const Color(0xFF0D4F45)
//                               : Colors.grey.shade300,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const Spacer(),
//
//                   // Next/Get Started button
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24,
//                       vertical: 16,
//                     ),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 56,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF0D4F45),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 2,
//                         ),
//                         onPressed: _goToNext,
//                         child: Text(
//                           _currentPage == _introPages.length - 1
//                               ? "Get Started"
//                               : "Next",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: isSmallScreen ? 8 : 16),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

//
//
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'login_page.dart';
// import 'welcome_screen.dart'; // New welcome screen
//
// class OnboardingPage extends StatefulWidget {
//   const OnboardingPage({super.key});
//
//   @override
//   State<OnboardingPage> createState() => _OnboardingPageState();
// }
//
// class _OnboardingPageState extends State<OnboardingPage> {
//   final PageController _controller = PageController();
//   int _currentPage = 0;
//
//   final List<Map<String, String>> _introPages = [
//     {
//       "image": "assets/images/intro1.jpg",
//       "title": "Welcome to Health Buddy",
//       "desc": "Your trusted health companion with clear and reliable medical advice from certified doctors.",
//     },
//     {
//       "image": "assets/images/intro2.jpg",
//       "title": "Consult with Experts",
//       "desc": "Connect with top doctors and specialists anytime, anywhere for personalized healthcare.",
//     },
//     {
//       "image": "assets/images/intro3.jpg",
//       "title": "Secure & Confidential",
//       "desc": "Your health data is protected with enterprise-grade security and privacy measures.",
//     },
//   ];
//
//   void _goToNext() {
//     if (_currentPage == _introPages.length - 1) {
//       _finishOnboarding();
//     } else {
//       _controller.nextPage(
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void _skip() {
//     _finishOnboarding();
//   }
//
//   Future<void> _finishOnboarding() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('onboardingCompleted', true);
//
//     if (mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const WelcomeScreen(),
//         ),
//       );
//     }
//   }
//
//   // Simple image widget with error handling
//   Widget _buildImage(String imagePath, BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.8,
//       height: MediaQuery.of(context).size.height * 0.4,
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.grey[100],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: Image.asset(
//           imagePath,
//           fit: BoxFit.contain,
//           errorBuilder: (context, error, stackTrace) {
//             // Fallback UI if image fails to load
//             return Container(
//               color: Colors.grey[200],
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.medical_services,
//                     size: 80,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Health Buddy',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Size screenSize = MediaQuery.of(context).size;
//     final bool isSmallScreen = screenSize.height < 600;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Skip button at top
//             Align(
//               alignment: Alignment.topRight,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextButton(
//                   onPressed: _skip,
//                   child: Text(
//                     "Skip",
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // Main content area
//             Expanded(
//               flex: 3,
//               child: PageView.builder(
//                 controller: _controller,
//                 onPageChanged: (index) {
//                   setState(() {
//                     _currentPage = index;
//                   });
//                 },
//                 itemCount: _introPages.length,
//                 itemBuilder: (context, index) {
//                   final page = _introPages[index];
//                   return SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // Image with responsive sizing
//                           _buildImage(page["image"]!, context),
//
//                           SizedBox(height: isSmallScreen ? 20 : 40),
//
//                           // Title
//                           Text(
//                             page["title"]!,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 22 : 28,
//                               fontWeight: FontWeight.bold,
//                               color: const Color(0xFF0D4F45),
//                             ),
//                           ),
//
//                           SizedBox(height: isSmallScreen ? 12 : 20),
//
//                           // Description
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             child: Text(
//                               page["desc"]!,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: isSmallScreen ? 14 : 16,
//                                 color: Colors.grey[700],
//                                 height: 1.5,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // Bottom section with dots and button
//             Expanded(
//               flex: 1,
//               child: Column(
//                 children: [
//                   // Page indicator dots
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(
//                       _introPages.length,
//                           (index) => AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         margin: const EdgeInsets.all(4),
//                         width: _currentPage == index ? 24 : 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4),
//                           color: _currentPage == index
//                               ? const Color(0xFF0D4F45)
//                               : Colors.grey.shade300,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const Spacer(),
//
//                   // Next/Get Started button
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24,
//                       vertical: 16,
//                     ),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 56,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF0D4F45),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 2,
//                         ),
//                         onPressed: _goToNext,
//                         child: Text(
//                           _currentPage == _introPages.length - 1
//                               ? "Get Started"
//                               : "Next",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: isSmallScreen ? 8 : 16),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }




import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'welcome_screen.dart'; // New welcome screen

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _introPages = [
    {
      "image": "assets/images/intro1.jpg",
      "title": "Welcome to Health Buddy",
      "desc": "Your trusted health companion with clear and reliable medical advice from certified doctors.",
    },
    {
      "image": "assets/images/intro2.jpg",
      "title": "Consult with Experts",
      "desc": "Connect with top doctors and specialists anytime, anywhere for personalized healthcare.",
    },
    {
      "image": "assets/images/intro3.jpg",
      "title": "Secure & Confidential",
      "desc": "Your health data is protected with enterprise-grade security and privacy measures.",
    },
  ];

  void _goToNext() {
    if (_currentPage == _introPages.length - 1) {
      _finishOnboarding();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _finishOnboarding();
  }

  Future<void> _finishOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    }
  }

  // Simple image widget with error handling
  Widget _buildImage(String imagePath, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.4,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback UI if image fails to load
            return Container(
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medical_services,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Health Buddy',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.height < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button at top
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Main content area - Removed SingleChildScrollView
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _introPages.length,
                itemBuilder: (context, index) {
                  final page = _introPages[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image with responsive sizing
                        _buildImage(page["image"]!, context),

                        SizedBox(height: isSmallScreen ? 10 : 20),

                        // Title
                        Text(
                          page["title"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 15 : 21,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D4F45),
                          ),
                        ),

                        SizedBox(height: isSmallScreen ? 12 : 20),

                        // Description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            page["desc"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom section with dots and button
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _introPages.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.all(4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentPage == index
                              ? const Color(0xFF0D4F45)
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Next/Get Started button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _goToNext,
                        child: Text(
                          _currentPage == _introPages.length - 1
                              ? "Get Started"
                              : "Next",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 8 : 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}