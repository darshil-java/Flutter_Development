//
//
// import 'package:flutter/material.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//
//   @override
//   Widget build(BuildContext context) {
//     final data=ModalRoute.of(context)!.settings.arguments as Map;
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),//Make drawer Icon White With This
//         backgroundColor: Color(0xFF0D4F45),
//         title: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child: Text("VSGLogic ChatApp",
//               style: TextStyle(
//                   color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: IconButton(onPressed: (){
//
//             }, icon: Icon(Icons.person_outline_sharp,)),
//           )
//         ],
//
//       ),
//
//       drawer: Drawer(
//         backgroundColor: Color(0xFF0D4F45),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 SizedBox(height: 40),
//                 ListTile(
//                   tileColor: Colors.teal,
//                   leading: Icon(
//                     Icons.home,
//                     size: 25,
//                     color: Colors.teal.shade100,
//                   ),
//                   title: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text("Home",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//
//
//                 new Divider(
//                   color: Colors.teal.shade100,
//                   thickness: 2,
//                   indent: 12,
//                 ),
//
//                 SizedBox(height: 10),
//                 ListTile(
//                   leading: Icon(
//                     Icons.add,
//                     size: 25,
//                     color: Colors.teal.shade100,
//                   ),
//                   title: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text("Doctor",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
//                   ),
//                 ),
//
//                 SizedBox(height: 10),
//                 ListTile(
//                   leading: Icon(
//                     Icons.file_copy_sharp,
//                     size: 25,
//                     color: Colors.teal.shade100,
//                   ),
//                   title: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text("Orders",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
//                   ),
//                 ),
//
//                 SizedBox(height: 10),
//                 ListTile(
//                   leading: Icon(
//                     Icons.privacy_tip,
//                     size: 25,
//                     color: Colors.teal.shade100,
//                   ),
//                   title: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text("Terms & Privacy",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
//                   ),
//                 ),
//
//                 SizedBox(height: 10),
//                 ListTile(
//                   leading: Icon(
//                     Icons.logout_sharp,
//                     size: 25,
//                     color: Colors.teal.shade100,
//                   ),
//                   title: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text("LogOut",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
//                   ),
//                 ),
//
//                 SizedBox(height: 10),
//                 new Divider(
//                   color: Colors.teal.shade100,
//                   thickness: 2,
//                   indent: 12,
//                 ),
//
//
//                 SizedBox(height: 50),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(3.0),
//                           child: Text("Made With",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 12),),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(3.0),
//                           child: Icon(Icons.favorite,color: Colors.teal.shade100,size: 14,),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(3.0),
//                           child: Text("By VSGLogic",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 12),),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//
//           ),
//         ),
//       ),
//
//
//       body: Container(
//         color: Colors.grey.shade100,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListView(
//             children: [
//               Text("Username: ${data['name']}" ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.redAccent),),
//               Text("Email: ${data['email']}" ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.redAccent),),
//               Text("Phone: ${data['phone']}" ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.redAccent),),
//               Text("dob: ${data['dob']}" ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.redAccent),),
//               Text("gender: ${data['gender']}" ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.redAccent),),
//               Text("KnownLanguage: ${data['KnownLanguage']}" ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.redAccent),),
//               Text("password: ${data['password']}" ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.redAccent),),
//               Text("confirmPassword: ${data['confirmPassword']}" ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.redAccent),),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//           color: Color(0xFF0D4F45),
//           child: Row(
//             children: [
//               // Attach icon
//               IconButton(
//                 icon: Icon(Icons.attach_file, color: Colors.teal.shade100),
//                 onPressed: () {},
//               ),
//
//               // Text field (Expanded to take available space)
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Send icon
//               IconButton(
//                 icon: Icon(Icons.send, color: Colors.teal.shade100),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
// }
