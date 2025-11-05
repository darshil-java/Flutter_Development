// import 'package:flutter/material.dart';
// import '../helper.dart';
// import 'logout_helper.dart';
//
// class DrawerItems {
//   static Widget drawerItem(String title, IconData icon, VoidCallback? onTap, dynamic state) {
//     return ListTile(
//       leading: Icon(icon, size: 25, color: AppColors.iconColor),
//       title: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(title,
//             style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
//       ),
//       onTap: onTap,
//     );
//   }
//
//   static Widget buildDrawer(BuildContext context) {
//     return Drawer(
//       backgroundColor: AppColors.primary,
//       child: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const SizedBox(height: 30),
//             Center(
//               child: Column(
//                 children: [
//                   const CircleAvatar(
//                     radius: 40,
//                     backgroundImage: AssetImage("assets/images/logo.png"),
//                     backgroundColor: Colors.white,
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "HealthBuddy",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Text(
//                     "info@healthbuddy.com",
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
//             Expanded(
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   drawerItem("Home", Icons.home, () {
//                     Navigator.pop(context);
//                     Navigator.pushNamed(context, '/home');
//                   }, null),
//                   drawerItem("Doctor", Icons.add, () {
//                     Navigator.pushNamed(context, '/doctors');
//                   }, null),
//                   drawerItem("Orders", Icons.file_copy_sharp, () {
//                     Navigator.pushNamed(context, '/orders');
//                   }, null),
//                   drawerItem("Terms & Privacy", Icons.privacy_tip, () {
//                     Navigator.pushNamed(context, '/terms');
//                   }, null),
//                   drawerItem("LogOut", Icons.logout_sharp, () async {
//                     bool? confirm = await showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: const Text('Confirm Logout'),
//                         content: const Text('Are you sure you want to logout?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, false),
//                             child: const Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, true),
//                             child: const Text('Logout'),
//                           ),
//                         ],
//                       ),
//                     );
//                     if (confirm == true) {
//                       await LogoutHelper.logoutUser(context);
//                     }
//                   }, null)
//                 ],
//               ),
//             ),
//             Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 80),
//               child: Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Text(
//                       "Made With",
//                       style: TextStyle(color: AppColors.textLight, fontSize: 12),
//                     ),
//                     SizedBox(width: 5),
//                     Icon(Icons.favorite, color: AppColors.textLight, size: 14),
//                     SizedBox(width: 5),
//                     Text(
//                       "By VSGLogic",
//                       style: TextStyle(color: AppColors.textLight, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
