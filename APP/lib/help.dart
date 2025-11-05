// // import 'package:flutter/material.dart';
// // import 'helper.dart';
// //
// // class HelpPage extends StatelessWidget {
// //   const HelpPage({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Help & Guidance'),
// //         backgroundColor: AppColors.primary,
// //         foregroundColor: Colors.white,
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             _buildWelcomeSection(),
// //             const SizedBox(height: 24),
// //             _buildHowItWorksSection(),
// //             const SizedBox(height: 24),
// //             _buildStepByStepGuide(),
// //             const SizedBox(height: 24),
// //             _buildFeaturesOverview(),
// //             const SizedBox(height: 24),
// //             _buildFaqSection(),
// //             const SizedBox(height: 24),
// //             _buildSupportSection(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildWelcomeSection() {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //           colors: [
// //             AppColors.primary.withOpacity(0.1),
// //             AppColors.accent.withOpacity(0.1),
// //           ],
// //         ),
// //         borderRadius: BorderRadius.circular(16),
// //       ),
// //       child: Column(
// //         children: [
// //           Icon(
// //             Icons.medical_services,
// //             size: 48,
// //             color: AppColors.primary,
// //           ),
// //           const SizedBox(height: 16),
// //           Text(
// //             'Welcome to Care Connect',
// //             style: TextStyle(
// //               fontSize: 24,
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.primary,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             'Your trusted partner for online medical consultations. This guide will help you navigate through all the features and make the most of your healthcare experience.',
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 16,
// //               color: Colors.grey[700],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildHowItWorksSection() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           'How Care Connect Works',
// //           style: TextStyle(
// //             fontSize: 20,
// //             fontWeight: FontWeight.bold,
// //             color: AppColors.primary,
// //           ),
// //         ),
// //         const SizedBox(height: 16),
// //         _buildProcessStep(
// //           step: 1,
// //           title: 'Choose Your Doctor',
// //           description: 'Select from Allopathy, Ayurvedic, or Homeopathy practitioners with various specializations',
// //           icon: Icons.person_search,
// //         ),
// //         _buildProcessStep(
// //           step: 2,
// //           title: 'Secure Payment',
// //           description: 'Make safe online payments with transparent pricing',
// //           icon: Icons.payment,
// //         ),
// //         _buildProcessStep(
// //           step: 3,
// //           title: 'Upload Medical Reports',
// //           description: 'Share your medical history and reports for better diagnosis',
// //           icon: Icons.upload_file,
// //         ),
// //         _buildProcessStep(
// //           step: 4,
// //           title: 'Consult with Doctor',
// //           description: 'Chat directly with your assigned specialist',
// //           icon: Icons.message,
// //         ),
// //         _buildProcessStep(
// //           step: 5,
// //           title: 'Session Completion',
// //           description: 'Doctor ends session when consultation is complete',
// //           icon: Icons.verified,
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildProcessStep({
// //     required int step,
// //     required String title,
// //     required String description,
// //     required IconData icon,
// //   }) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //         border: Border.all(color: Colors.grey.shade200),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 40,
// //             height: 40,
// //             decoration: BoxDecoration(
// //               color: AppColors.primary,
// //               shape: BoxShape.circle,
// //             ),
// //             child: Center(
// //               child: Text(
// //                 '$step',
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 16,
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 16),
// //           Icon(icon, color: AppColors.accent, size: 24),
// //           const SizedBox(width: 16),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   title,
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 16,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(
// //                   description,
// //                   style: TextStyle(
// //                     color: Colors.grey[600],
// //                     fontSize: 14,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStepByStepGuide() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           'Step-by-Step Guide',
// //           style: TextStyle(
// //             fontSize: 20,
// //             fontWeight: FontWeight.bold,
// //             color: AppColors.primary,
// //           ),
// //         ),
// //         const SizedBox(height: 16),
// //         _buildGuideStep(
// //           title: 'Starting a Consultation',
// //           steps: [
// //             'Open the Care Connect app and navigate to the home screen',
// //             'Read the welcome message and click "Yes" for second opinion',
// //             'Select your preferred doctor type (Allopathy/Ayurvedic/Homeopathy)',
// //             'Confirm your selection when prompted',
// //           ],
// //         ),
// //         _buildGuideStep(
// //           title: 'Specialization Selection',
// //           steps: [
// //             'For Allopathy: Choose from various specializations like Cardiology, Dermatology, etc.',
// //             'For Ayurvedic/Homeopathy: General consultation will be selected automatically',
// //             'Review the consultation fee displayed',
// //           ],
// //         ),
// //         _buildGuideStep(
// //           title: 'Payment Process',
// //           steps: [
// //             'Click the payment button with the displayed amount',
// //             'Complete the secure payment via Razorpay gateway',
// //             'Wait for payment verification (automatic)',
// //             'Receive confirmation of successful payment',
// //           ],
// //         ),
// //         _buildGuideStep(
// //           title: 'Report Upload (Optional)',
// //           steps: [
// //             'After payment, choose if you want to upload medical reports',
// //             'Click "Yes" to enable report upload feature',
// //             'Use the clip icon (📎) next to message input to upload files',
// //             'Select files from your device (PDF, images, documents)',
// //           ],
// //         ),
// //         _buildGuideStep(
// //           title: 'Chat with Doctor',
// //           steps: [
// //             'Start typing your medical concerns in the message box',
// //             'Send messages to communicate with your assigned doctor',
// //             'Wait for responses - our specialists typically reply promptly',
// //             'Share symptoms, ask questions, and discuss treatment options',
// //           ],
// //         ),
// //         _buildGuideStep(
// //           title: 'Session Management',
// //           steps: [
// //             'Consultation session continues until doctor marks it complete',
// //             'You\'ll receive a notification when session ends',
// //             'Chat automatically resets for new consultations',
// //             'Access previous consultations via Orders section',
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildGuideStep({required String title, required List<String> steps}) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 16),
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: Colors.grey.shade200),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             title,
// //             style: const TextStyle(
// //               fontWeight: FontWeight.bold,
// //               fontSize: 16,
// //               color: AppColors.primary,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           ...steps.asMap().entries.map((entry) {
// //             final index = entry.key;
// //             final step = entry.value;
// //             return Padding(
// //               padding: const EdgeInsets.only(bottom: 8),
// //               child: Row(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Container(
// //                     width: 24,
// //                     height: 24,
// //                     decoration: BoxDecoration(
// //                       color: AppColors.accent.withOpacity(0.2),
// //                       shape: BoxShape.circle,
// //                     ),
// //                     child: Center(
// //                       child: Text(
// //                         '${index + 1}',
// //                         style: TextStyle(
// //                           color: AppColors.accent,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 12,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 12),
// //                   Expanded(
// //                     child: Text(
// //                       step,
// //                       style: TextStyle(
// //                         color: Colors.grey[700],
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           }),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFeaturesOverview() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           'Key Features',
// //           style: TextStyle(
// //             fontSize: 20,
// //             fontWeight: FontWeight.bold,
// //             color: AppColors.primary,
// //           ),
// //         ),
// //         const SizedBox(height: 16),
// //         Wrap(
// //           spacing: 12,
// //           runSpacing: 12,
// //           children: [
// //             _buildFeatureChip(
// //               icon: Icons.medical_information,
// //               text: 'Multiple Doctor Types',
// //               color: Colors.blue,
// //             ),
// //             _buildFeatureChip(
// //               icon: Icons.security,
// //               text: 'Secure Payments',
// //               color: Colors.green,
// //             ),
// //             _buildFeatureChip(
// //               icon: Icons.cloud_upload,
// //               text: 'Report Upload',
// //               color: Colors.orange,
// //             ),
// //             _buildFeatureChip(
// //               icon: Icons.chat,
// //               text: 'Real-time Chat',
// //               color: Colors.purple,
// //             ),
// //             _buildFeatureChip(
// //               icon: Icons.assignment,
// //               text: 'Session Management',
// //               color: Colors.red,
// //             ),
// //             _buildFeatureChip(
// //               icon: Icons.history,
// //               text: 'Consultation History',
// //               color: Colors.teal,
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildFeatureChip({
// //     required IconData icon,
// //     required String text,
// //     required Color color,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: color.withOpacity(0.3)),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(icon, size: 16, color: color),
// //           const SizedBox(width: 6),
// //           Text(
// //             text,
// //             style: TextStyle(
// //               color: color,
// //               fontWeight: FontWeight.w500,
// //               fontSize: 12,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFaqSection() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           'Frequently Asked Questions',
// //           style: TextStyle(
// //             fontSize: 20,
// //             fontWeight: FontWeight.bold,
// //             color: AppColors.primary,
// //           ),
// //         ),
// //         const SizedBox(height: 16),
// //         _buildFaqItem(
// //           question: 'How do I choose the right doctor type?',
// //           answer: 'Allopathy for modern medicine, Ayurvedic for traditional Indian medicine, and Homeopathy for alternative medicine. Consider your health needs and preferences.',
// //         ),
// //         _buildFaqItem(
// //           question: 'Can I upload multiple medical reports?',
// //           answer: 'Yes, you can upload multiple reports including lab results, prescriptions, and medical images. However, upload is allowed only once per consultation.',
// //         ),
// //         _buildFaqItem(
// //           question: 'What happens after payment?',
// //           answer: 'After successful payment, a doctor is assigned to your case. You can then upload reports and start chatting with the doctor immediately.',
// //         ),
// //         _buildFaqItem(
// //           question: 'How long does a consultation last?',
// //           answer: 'Consultations continue until the doctor determines the session is complete. You\'ll be notified when the session ends.',
// //         ),
// //         _buildFaqItem(
// //           question: 'Is my medical information secure?',
// //           answer: 'Yes, we use end-to-end encryption and comply with medical data protection standards. Your information is confidential and secure.',
// //         ),
// //         _buildFaqItem(
// //           question: 'What if I need emergency care?',
// //           answer: 'Care Connect is for non-emergency consultations. In case of emergencies, please visit the nearest hospital or call emergency services.',
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildFaqItem({required String question, required String answer}) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 4,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(Icons.help_outline, color: AppColors.accent, size: 20),
// //               const SizedBox(width: 8),
// //               Expanded(
// //                 child: Text(
// //                   question,
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 15,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 8),
// //           Padding(
// //             padding: const EdgeInsets.only(left: 28),
// //             child: Text(
// //               answer,
// //               style: TextStyle(
// //                 color: Colors.grey[700],
// //                 fontSize: 14,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSupportSection() {
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: AppColors.primary.withOpacity(0.05),
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: AppColors.primary.withOpacity(0.2)),
// //       ),
// //       child: Column(
// //         children: [
// //           Icon(
// //             Icons.support_agent,
// //             size: 40,
// //             color: AppColors.primary,
// //           ),
// //           const SizedBox(height: 16),
// //           Text(
// //             'Need More Help?',
// //             style: TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.primary,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             'Our support team is here to assist you with any questions or technical issues.',
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               color: Colors.grey[700],
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //             children: [
// //               _buildSupportOption(
// //                 icon: Icons.email,
// //                 text: 'Email',
// //                 onTap: () {
// //                   // Implement email support
// //                 },
// //               ),
// //               _buildSupportOption(
// //                 icon: Icons.phone,
// //                 text: 'Call',
// //                 onTap: () {
// //                   // Implement phone support
// //                 },
// //               ),
// //               _buildSupportOption(
// //                 icon: Icons.chat,
// //                 text: 'Live Chat',
// //                 onTap: () {
// //                   // Implement live chat
// //                 },
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 16),
// //           Text(
// //             'Support Hours: 9:00 AM - 6:00 PM (Mon-Sat)',
// //             style: TextStyle(
// //               color: Colors.grey[600],
// //               fontSize: 12,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSupportOption({
// //     required IconData icon,
// //     required String text,
// //     required VoidCallback onTap,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Column(
// //         children: [
// //           Container(
// //             width: 50,
// //             height: 50,
// //             decoration: BoxDecoration(
// //               color: AppColors.primary,
// //               shape: BoxShape.circle,
// //             ),
// //             child: Icon(icon, color: Colors.white),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             text,
// //             style: TextStyle(
// //               color: AppColors.primary,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'helper.dart';
//
// class HelpPage extends StatelessWidget {
//   const HelpPage({super.key});
//
//   // ==================== LAUNCH PHONE CALL =====================
//   Future<void> _makePhoneCall() async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: '+91-9054605830');
//     if (await canLaunchUrl(phoneUri)) {
//       await launchUrl(phoneUri);
//     } else {
//       throw 'Could not launch $phoneUri';
//     }
//   }
//
//   // ==================== LAUNCH EMAIL =====================
//   Future<void> _sendEmail() async {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: 'adarshil438@gmail.com',
//       queryParameters: {
//         'subject': 'Care Connect Support Request',
//         'body': 'Hello Care Connect Team,\n\nI need assistance with:',
//       },
//     );
//
//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(emailUri);
//     } else {
//       throw 'Could not launch $emailUri';
//     }
//   }
//
//   // ==================== LAUNCH LIVE CHAT =====================
//   void _openLiveChat(BuildContext context) {
//     // For now, show a dialog. You can replace this with your actual chat implementation
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Live Chat Support'),
//         content: const Text('Live chat feature will be available soon. For now, please use email or phone support.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Help & Guidance'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildWelcomeSection(),
//               const SizedBox(height: 24),
//               _buildHowItWorksSection(),
//               const SizedBox(height: 24),
//               _buildStepByStepGuide(),
//               const SizedBox(height: 24),
//               _buildFeaturesOverview(),
//               const SizedBox(height: 24),
//               _buildFaqSection(),
//               const SizedBox(height: 24),
//               _buildSupportSection(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildWelcomeSection() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             AppColors.primary.withOpacity(0.1),
//             AppColors.accent.withOpacity(0.1),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           Icon(
//             Icons.medical_services,
//             size: 48,
//             color: AppColors.primary,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Welcome to Care Connect',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primary,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Your trusted partner for online medical consultations. This guide will help you navigate through all the features and make the most of your healthcare experience.',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHowItWorksSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'How Care Connect Works',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: AppColors.primary,
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildProcessStep(
//           step: 1,
//           title: 'Choose Your Doctor',
//           description: 'Select from Allopathy, Ayurvedic, or Homeopathy practitioners with various specializations',
//           icon: Icons.person_search,
//         ),
//         _buildProcessStep(
//           step: 2,
//           title: 'Secure Payment',
//           description: 'Make safe online payments with transparent pricing',
//           icon: Icons.payment,
//         ),
//         _buildProcessStep(
//           step: 3,
//           title: 'Upload Medical Reports',
//           description: 'Share your medical history and reports for better diagnosis',
//           icon: Icons.upload_file,
//         ),
//         _buildProcessStep(
//           step: 4,
//           title: 'Consult with Doctor',
//           description: 'Chat directly with your assigned specialist',
//           icon: Icons.message,
//         ),
//         _buildProcessStep(
//           step: 5,
//           title: 'Session Completion',
//           description: 'Doctor ends session when consultation is complete',
//           icon: Icons.verified,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildProcessStep({
//     required int step,
//     required String title,
//     required String description,
//     required IconData icon,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: AppColors.primary,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 '$step',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Icon(icon, color: AppColors.accent, size: 24),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStepByStepGuide() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Step-by-Step Guide',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: AppColors.primary,
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildGuideStep(
//           title: 'Starting a Consultation',
//           steps: [
//             'Open the Care Connect app and navigate to the home screen',
//             'Read the welcome message and click "Yes" for second opinion',
//             'Select your preferred doctor type (Allopathy/Ayurvedic/Homeopathy)',
//             'Confirm your selection when prompted',
//           ],
//         ),
//         _buildGuideStep(
//           title: 'Specialization Selection',
//           steps: [
//             'For Allopathy: Choose from various specializations like Cardiology, Dermatology, etc.',
//             'For Ayurvedic/Homeopathy: General consultation will be selected automatically',
//             'Review the consultation fee displayed',
//           ],
//         ),
//         _buildGuideStep(
//           title: 'Payment Process',
//           steps: [
//             'Click the payment button with the displayed amount',
//             'Complete the secure payment via Razorpay gateway',
//             'Wait for payment verification (automatic)',
//             'Receive confirmation of successful payment',
//           ],
//         ),
//         _buildGuideStep(
//           title: 'Report Upload (Optional)',
//           steps: [
//             'After payment, choose if you want to upload medical reports',
//             'Click "Yes" to enable report upload feature',
//             'Use the clip icon (📎) next to message input to upload files',
//             'Select files from your device (PDF, images, documents)',
//           ],
//         ),
//         _buildGuideStep(
//           title: 'Chat with Doctor',
//           steps: [
//             'Start typing your medical concerns in the message box',
//             'Send messages to communicate with your assigned doctor',
//             'Wait for responses - our specialists typically reply promptly',
//             'Share symptoms, ask questions, and discuss treatment options',
//           ],
//         ),
//         _buildGuideStep(
//           title: 'Session Management',
//           steps: [
//             'Consultation session continues until doctor marks it complete',
//             'You\'ll receive a notification when session ends',
//             'Chat automatically resets for new consultations',
//             'Access previous consultations via Orders section',
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildGuideStep({required String title, required List<String> steps}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               color: AppColors.primary,
//             ),
//           ),
//           const SizedBox(height: 8),
//           ...steps.asMap().entries.map((entry) {
//             final index = entry.key;
//             final step = entry.value;
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 8),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       color: AppColors.accent.withOpacity(0.2),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Center(
//                       child: Text(
//                         '${index + 1}',
//                         style: TextStyle(
//                           color: AppColors.accent,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       step,
//                       style: TextStyle(
//                         color: Colors.grey[700],
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFeaturesOverview() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Key Features',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: AppColors.primary,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children: [
//             _buildFeatureChip(
//               icon: Icons.medical_information,
//               text: 'Multiple Doctor Types',
//               color: Colors.blue,
//             ),
//             _buildFeatureChip(
//               icon: Icons.security,
//               text: 'Secure Payments',
//               color: Colors.blue,
//             ),
//             _buildFeatureChip(
//               icon: Icons.cloud_upload,
//               text: 'Report Upload',
//               color: Colors.blue,
//             ),
//             _buildFeatureChip(
//               icon: Icons.chat,
//               text: 'Real-time Chat',
//               color: Colors.blue,
//             ),
//             _buildFeatureChip(
//               icon: Icons.assignment,
//               text: 'Session Management',
//               color:Colors.blue,
//             ),
//             _buildFeatureChip(
//               icon: Icons.history,
//               text: 'Consultation History',
//               color: Colors.blue,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFeatureChip({
//     required IconData icon,
//     required String text,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: color),
//           const SizedBox(width: 6),
//           Text(
//             text,
//             style: TextStyle(
//               color: color,
//               fontWeight: FontWeight.w500,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFaqSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Frequently Asked Questions',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: AppColors.primary,
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildFaqItem(
//           question: 'How do I choose the right doctor type?',
//           answer: 'Allopathy for modern medicine, Ayurvedic for traditional Indian medicine, and Homeopathy for alternative medicine. Consider your health needs and preferences.',
//         ),
//         _buildFaqItem(
//           question: 'Can I upload multiple medical reports?',
//           answer: 'Yes, you can upload multiple reports including lab results, prescriptions, and medical images. However, upload is allowed only once per consultation.',
//         ),
//         _buildFaqItem(
//           question: 'What happens after payment?',
//           answer: 'After successful payment, a doctor is assigned to your case. You can then upload reports and start chatting with the doctor immediately.',
//         ),
//         _buildFaqItem(
//           question: 'How long does a consultation last?',
//           answer: 'Consultations continue until the doctor determines the session is complete. You\'ll be notified when the session ends.',
//         ),
//         _buildFaqItem(
//           question: 'Is my medical information secure?',
//           answer: 'Yes, we use end-to-end encryption and comply with medical data protection standards. Your information is confidential and secure.',
//         ),
//         _buildFaqItem(
//           question: 'What if I need emergency care?',
//           answer: 'Care Connect is for non-emergency consultations. In case of emergencies, please visit the nearest hospital or call emergency services.',
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFaqItem({required String question, required String answer}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.help_outline, color: AppColors.accent, size: 20),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   question,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.only(left: 28),
//             child: Text(
//               answer,
//               style: TextStyle(
//                 color: Colors.grey[700],
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget _buildSupportSection(BuildContext context) {
//   //   return Container(
//   //     padding: const EdgeInsets.all(20),
//   //     decoration: BoxDecoration(
//   //       color: AppColors.primary.withOpacity(0.05),
//   //       borderRadius: BorderRadius.circular(16),
//   //       border: Border.all(color: AppColors.primary.withOpacity(0.2)),
//   //     ),
//   //     child: Column(
//   //       children: [
//   //         Icon(
//   //           Icons.support_agent,
//   //           size: 40,
//   //           color: AppColors.primary,
//   //         ),
//   //         const SizedBox(height: 16),
//   //         Text(
//   //           'Need More Help?',
//   //           style: TextStyle(
//   //             fontSize: 18,
//   //             fontWeight: FontWeight.bold,
//   //             color: AppColors.primary,
//   //           ),
//   //         ),
//   //         const SizedBox(height: 8),
//   //         Text(
//   //           'Our support team is here to assist you with any questions or technical issues.',
//   //           textAlign: TextAlign.center,
//   //           style: TextStyle(
//   //             color: Colors.grey[700],
//   //           ),
//   //         ),
//   //         const SizedBox(height: 16),
//   //         Row(
//   //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   //           children: [
//   //             _buildSupportOption(
//   //               icon: Icons.email,
//   //               text: 'Email',
//   //               onTap: _sendEmail,
//   //             ),
//   //             _buildSupportOption(
//   //               icon: Icons.phone,
//   //               text: 'Call',
//   //               onTap: _makePhoneCall,
//   //             ),
//   //             // _buildSupportOption(
//   //             //   icon: Icons.chat,
//   //             //   text: 'Live Chat',
//   //             //   onTap: () => _openLiveChat(context),
//   //             // ),
//   //           ],
//   //         ),
//   //         const SizedBox(height: 16),
//   //         Text(
//   //           'Support Hours: 9:00 AM - 6:00 PM (Mon-Sat)',
//   //           style: TextStyle(
//   //             color: Colors.grey[600],
//   //             fontSize: 12,
//   //           ),
//   //         ),
//   //         // const SizedBox(height: 8),
//   //         // Text(
//   //         //   'Email: support@healthbuddy.com',
//   //         //   style: TextStyle(
//   //         //     color: Colors.grey[600],
//   //         //     fontSize: 12,
//   //         //   ),
//   //         // ),
//   //         // const SizedBox(height: 4),
//   //         // Text(
//   //         //   'Phone: +91-',
//   //         //   style: TextStyle(
//   //         //     color: Colors.grey[600],
//   //         //     fontSize: 12,
//   //         //   ),
//   //         // ),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//
//
//   Widget _buildSupportSection(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppColors.primary.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.primary.withOpacity(0.2)),
//       ),
//       child: Column(
//         children: [
//           Icon(
//             Icons.support_agent,
//             size: 40,
//             color: AppColors.primary,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Need More Help?',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primary,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Our support team is here to assist you with any questions or technical issues.',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.grey[700],
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildSupportOption(
//                 icon: Icons.email,
//                 text: 'Email',
//                 onTap: _sendEmail,
//               ),
//               _buildSupportOption(
//                 icon: Icons.video_library, // YouTube icon
//                 text: 'Watch Video',
//                 onTap: () async {
//                   const url = 'https://www.youtube.com/watch?v=n2dVFdqMYGA&list=RDMMn2dVFdqMYGA&start_radio=1'; // Replace with your YouTube link
//                   final Uri videoUri = Uri.parse(url);
//                   if (await canLaunchUrl(videoUri)) {
//                     await launchUrl(videoUri, mode: LaunchMode.externalApplication);
//                   } else {
//                     throw 'Could not launch $url';
//                   }
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Support Hours: 9:00 AM - 6:00 PM (Mon-Sat)',
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSupportOption({
//     required IconData icon,
//     required String text,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: AppColors.primary,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: Colors.white),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             text,
//             style: TextStyle(
//               color: AppColors.primary,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ==================== API CONFIGURATION ====================
class ApiConfig {
  // 🔗 Base URL (Update this as per your backend server IP/Port)
  static const String baseUrl = "http://192.168.1.13:3000/api";
}

// ==================== MODELS ====================
class HelpPageContent {
  final String version;
  final String title;
  final Map<String, dynamic> content;
  final bool isActive;

  HelpPageContent({
    required this.version,
    required this.title,
    required this.content,
    required this.isActive,
  });

  factory HelpPageContent.fromJson(Map<String, dynamic> json) {
    print('🎯 Parsing HelpPageContent from JSON');
    print('📦 JSON keys: ${json.keys.toList()}');
    print('📋 Content type: ${json['content']?.runtimeType}');

    return HelpPageContent(
      version: json['version'] ?? '1.0',
      title: json['title'] ?? 'Help & Support',
      content: json['content'] is Map ? Map<String, dynamic>.from(json['content']) : {},
      isActive: json['isActive'] ?? true,
    );
  }
}

// ==================== SERVICE ====================
class HelpPageService {
  static const String baseUrl = '${ApiConfig.baseUrl}/help-page';

  static Future<Map<String, dynamic>> getHelpPageContent() async {
    print('🚀 STARTING API CALL');
    print('📡 API URL: $baseUrl');
    print('⏰ Timestamp: ${DateTime.now()}');

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('📥 RESPONSE RECEIVED');
      print('🔢 Status Code: ${response.statusCode}');
      print('📄 Response Body Length: ${response.body.length}');

      if (response.statusCode == 200) {
        print('✅ SUCCESS: API call successful');
        final data = json.decode(response.body);
        print('📦 Response keys: ${data.keys.toList()}');
        print('🎯 Success flag: ${data['success']}');

        if (data['success'] == true && data['data'] != null) {
          print('📊 Data structure type: ${data['data'].runtimeType}');
          print('🔍 Data content keys: ${data['data']['content']?.keys?.toList()}');
          return data['data'];
        } else {
          print('❌ API returned false success or null data');
          throw Exception('API returned unsuccessful response: ${data['message']}');
        }
      } else {
        print('❌ HTTP ERROR: ${response.statusCode}');
        print('📄 Error Response: ${response.body}');
        throw Exception('HTTP ${response.statusCode}: Failed to load help page content');
      }
    } catch (e) {
      print('💥 EXCEPTION DURING API CALL: $e');
      print('🔄 Exception type: ${e.runtimeType}');
      rethrow;
    }
  }
}

// ==================== APP COLORS ====================
class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color accent = Color(0xFF00BCD4);
}

// ==================== HELP PAGE WIDGET ====================
class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  late Future<HelpPageContent> _helpPageFuture;
  HelpPageContent? _helpPageContent;

  @override
  void initState() {
    super.initState();
    print('🎬 HelpPage initState called');
    _helpPageFuture = _loadHelpPageContent();
  }

  Future<HelpPageContent> _loadHelpPageContent() async {
    print('🔄 Starting to load help page content...');
    try {
      final data = await HelpPageService.getHelpPageContent();
      print('✅ Data loaded successfully, parsing...');
      final helpPageContent = HelpPageContent.fromJson(data);
      print('🎉 Help page content parsed successfully!');
      print('📋 Content Summary:');
      print('   - Version: ${helpPageContent.version}');
      print('   - Title: ${helpPageContent.title}');
      print('   - Content keys: ${helpPageContent.content.keys.toList()}');

      // Debug: Print the actual structure
      if (helpPageContent.content['welcome'] != null) {
        print('   - Welcome: ${helpPageContent.content['welcome']}');
      }
      if (helpPageContent.content['howItWorks'] != null) {
        print('   - HowItWorks items: ${helpPageContent.content['howItWorks'].length}');
      }
      if (helpPageContent.content['faqs'] != null) {
        print('   - FAQs: ${helpPageContent.content['faqs'].length}');
      }
      if (helpPageContent.content['support'] != null) {
        print('   - Support: ${helpPageContent.content['support']}');
      }

      setState(() {
        _helpPageContent = helpPageContent;
      });
      return helpPageContent;
    } catch (e) {
      print('💥 ERROR in _loadHelpPageContent: $e');
      print('🔄 Rethrowing error...');
      rethrow;
    }
  }

  // ==================== LAUNCH PHONE CALL =====================
  Future<void> _makePhoneCall() async {
    final support = _helpPageContent?.content['support'];
    final contact = support != null && support is Map ? support['contact'] : null;
    final phoneNumber = contact != null && contact is Map ? contact['phone'] : '+91-9054605830';

    print('📞 Making phone call to: $phoneNumber');
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('❌ Could not launch phone: $phoneUri');
      throw 'Could not launch $phoneUri';
    }
  }

  // ==================== LAUNCH YOUTUBE =====================
  Future<void> _launchYouTube() async {
    final support = _helpPageContent?.content['support'];
    final contact = support != null && support is Map ? support['contact'] : null;
    final youtubeUrl = contact != null && contact is Map ? contact['youtube'] : 'https://www.youtube.com/watch?v=n2dVFdqMYGA&list=RDn2dVFdqMYGA&start_radio=1';

    print('🎬 Launching YouTube: $youtubeUrl');

    // Try multiple URL formats for YouTube
    Uri youtubeUri;

    // First try the direct URL
    if (youtubeUrl.startsWith('http')) {
      youtubeUri = Uri.parse(youtubeUrl);
    }
    // Try YouTube app scheme if it's a channel or video ID
    else if (youtubeUrl.contains('@') || youtubeUrl.length == 11) {
      // For YouTube channel: youtube://user/username or youtube://channel/channelId
      // For YouTube video: youtube://watch?v=videoId
      if (youtubeUrl.startsWith('@')) {
        youtubeUri = Uri(scheme: 'vnd.youtube', path: 'user/${youtubeUrl.substring(1)}');
      } else if (youtubeUrl.length == 11) {
        youtubeUri = Uri(scheme: 'vnd.youtube', path: 'watch', queryParameters: {'v': youtubeUrl});
      } else {
        youtubeUri = Uri.parse('https://www.youtube.com/watch?v=n2dVFdqMYGA&list=RDn2dVFdqMYGA&start_radio=1');
      }
    } else {
      youtubeUri = Uri.parse('https://www.youtube.com/watch?v=n2dVFdqMYGA&list=RDn2dVFdqMYGA&start_radio=1');
    }

    print('🔗 YouTube URI: $youtubeUri');

    // Try launching with YouTube app first, then fallback to browser
    if (await canLaunchUrl(youtubeUri)) {
      await launchUrl(youtubeUri);
    } else {
      // Fallback to web URL
      final webUri = Uri.parse(youtubeUrl.startsWith('http') ? youtubeUrl : 'https://www.youtube.com');
      print('🔄 Falling back to web URL: $webUri');
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri);
      } else {
        print('❌ Could not launch YouTube: $youtubeUri');
        throw 'Could not launch YouTube';
      }
    }
  }

  // ==================== LAUNCH EMAIL =====================
  Future<void> _sendEmail() async {
    final support = _helpPageContent?.content['support'];
    final contact = support != null && support is Map ? support['contact'] : null;
    final email = contact != null && contact is Map ? contact['email'] : 'adarshil438@gmail.com';

    print('📧 Sending email to: $email');
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Care Connect Support Request',
        'body': 'Hello Care Connect Team,\n\nI need assistance with:',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print('❌ Could not launch email: $emailUri');
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🏗 Building HelpPage widget');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Guidance'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FutureBuilder<HelpPageContent>(
          future: _helpPageFuture,
          builder: (context, snapshot) {
            print('🔮 FutureBuilder state:');
            print('   - ConnectionState: ${snapshot.connectionState}');
            print('   - HasData: ${snapshot.hasData}');
            print('   - HasError: ${snapshot.hasError}');
            print('   - Error: ${snapshot.error}');

            if (snapshot.connectionState == ConnectionState.waiting) {
              print('⏳ Showing loading indicator');
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading help content from server...'),
                    SizedBox(height: 8),
                    Text('Connecting to: ${ApiConfig.baseUrl}/help-page',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              print('❌ Showing error state: ${snapshot.error}');
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load help content',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Server: ${ApiConfig.baseUrl}/help-page',
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          print('🔄 Retry button pressed');
                          setState(() {
                            _helpPageFuture = _loadHelpPageContent();
                          });
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              print('✅ Showing help page content');
              final helpPageContent = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (helpPageContent.content['welcome'] != null)
                      _buildWelcomeSection(helpPageContent.content['welcome']),
                    const SizedBox(height: 24),
                    if (helpPageContent.content['howItWorks'] != null)
                      _buildHowItWorksSection(helpPageContent.content['howItWorks']),
                    const SizedBox(height: 24),
                    if (helpPageContent.content['faqs'] != null)
                      _buildFaqSection(helpPageContent.content['faqs']),
                    const SizedBox(height: 24),
                    if (helpPageContent.content['support'] != null)
                      _buildSupportSection(helpPageContent.content['support']),
                  ],
                ),
              );
            } else {
              print('❓ Unknown state - showing fallback');
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(dynamic welcomeData) {
    print('🎨 Building WelcomeSection: $welcomeData');

    if (welcomeData is! Map) {
      return _buildFallbackWelcomeSection();
    }

    final welcome = Map<String, dynamic>.from(welcomeData);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.accent.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            _getIconData(welcome['icon'] ?? 'medical_services'),
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            welcome['title'] ?? 'Welcome to Care Connect',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            welcome['description'] ?? 'Your trusted partner for online medical consultations.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection(dynamic howItWorksData) {
    print('🎨 Building HowItWorksSection: $howItWorksData');

    if (howItWorksData is! List) {
      return _buildFallbackHowItWorksSection();
    }

    final steps = List<dynamic>.from(howItWorksData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How Care Connect Works',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        ...steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          if (step is Map) {
            return _buildProcessStep(
              step: index + 1,
              title: step['title'] ?? 'Step ${index + 1}',
              description: step['description'] ?? 'Description',
              icon: step['icon'] ?? 'help_outline',
            );
          } else {
            return Container();
          }
        }).toList(),
      ],
    );
  }

  Widget _buildProcessStep({
    required int step,
    required String title,
    required String description,
    required String icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Icon(_getIconData(icon), color: AppColors.accent, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection(dynamic faqsData) {
    print('🎨 Building FaqSection: $faqsData');

    if (faqsData is! List) {
      return _buildFallbackFaqSection();
    }

    final faqs = List<dynamic>.from(faqsData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        ...faqs.asMap().entries.map((entry) {
          final index = entry.key;
          final faq = entry.value;
          if (faq is Map) {
            return _buildFaqItem(
              question: faq['question'] ?? 'Question ${index + 1}?',
              answer: faq['answer'] ?? 'Answer ${index + 1}.',
            );
          } else {
            return Container();
          }
        }).toList(),
      ],
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              answer,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(dynamic supportData) {
    print('🎨 Building SupportSection: $supportData');

    if (supportData is! Map) {
      return _buildFallbackSupportSection();
    }

    final support = Map<String, dynamic>.from(supportData);
    final contact = support['contact'] is Map ? Map<String, dynamic>.from(support['contact']) : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.support_agent,
            size: 40,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            support['title'] ?? 'Need More Help?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            support['description'] ?? 'Our support team is here to assist you with any questions or technical issues.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSupportOption(
                icon: Icons.email,
                text: 'Email',
                onTap: _sendEmail,
              ),
              // _buildSupportOption(
              //   icon: Icons.phone,
              //   text: 'Call',
              //   onTap: _makePhoneCall,
              // ),
              _buildSupportOption(
                icon: Icons.video_library, // Changed from video_chat to video_library for YouTube
                text: 'YouTube',
                onTap: _launchYouTube, // Now this will open YouTube instead of phone
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (contact != null && contact['hours'] != null)
            Text(
              'Support Hours: ${contact['hours']}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Fallback sections in case API data is missing
  Widget _buildFallbackWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.accent.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.medical_services, size: 48, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            'Welcome to Care Connect',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your trusted partner for online medical consultations.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackHowItWorksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How Care Connect Works',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 16),
        Text('How it works data not available', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildFallbackFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Frequently Asked Questions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 16),
        Text('FAQ data not available', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildFallbackSupportSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.support_agent, size: 40, color: AppColors.primary),
          const SizedBox(height: 16),
          Text('Need More Help?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 8),
          Text('Support data not available', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // Helper method to convert string to IconData
  IconData _getIconData(String iconName) {
    final icon = _iconMap[iconName] ?? Icons.help_outline;
    return icon;
  }

  final Map<String, IconData> _iconMap = {
    'medical_services': Icons.medical_services,
    'person_search': Icons.person_search,
    'payment': Icons.payment,
    'upload_file': Icons.upload_file,
    'message': Icons.message,
    'verified': Icons.verified,
    'help_outline': Icons.help_outline,
  };
}