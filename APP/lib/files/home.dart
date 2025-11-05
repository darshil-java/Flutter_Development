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
//   @override
//   Widget build(BuildContext context) {
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
//       body: Column(
//         children: [
//           Expanded(
//               child: Container()
//           ),
//           SafeArea(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
//               color: Color(0xFF0D4F45),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pushNamed(context, '/upload'),
//                     child: Icon(Icons.attach_file, color: Colors.teal.shade100),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(21)
//                       ),
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: "Type A Message",
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 8,),
//                   Icon(Icons.send,color: Colors.teal.shade100),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class Message {
//   final String text;
//   final bool isBot;
//   final bool showButtons;
//   final bool isDoctorChoice;
//   final bool isUploadPrompt;
//   final bool isYesNoPrompt;
//
//   Message({
//     required this.text,
//     required this.isBot,
//     this.showButtons = false,
//     this.isDoctorChoice = false,
//     this.isUploadPrompt = false,
//     this.isYesNoPrompt = false,
//   });
// }
//
// Future<void> logoutUser(BuildContext context) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.clear();
//   Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
// }
//
// class _HomePageState extends State<HomePage> {
//   List<Message> messages = [];
//   TextEditingController m1 = TextEditingController();
//   bool reportUploaded = false;
//
//   int reportUploadCount = 0; // Track number of uploads
//   bool queryAsked = false;   // Track if query is already asked
//
//   List<String> doctorCategories = ['MBBS', 'MD', 'Dentist', 'Cardiologist'];
//   String? selectedCategory;
//   bool showDropdown = false;
//   bool paymentPrompt = false;
//
//   late Razorpay _razorpay;
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//
//     messages.add(Message(
//       text: "Hi User, we provide doctor consultation from your home. Let's get started!",
//       isBot: true,
//     ));
//     messages.add(Message(
//       text: "Do you want to have any second opinion?",
//       isBot: true,
//       showButtons: true,
//     ));
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       loadDoctorMessage();
//     });
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     setState(() {
//       paymentPrompt = false;
//       messages.add(Message(text: "Payment successful!", isBot: true));
//       messages.add(Message(
//         text: "Please upload your medical report for consultation.",
//         isBot: true,
//         isUploadPrompt: true,
//       ));
//     });
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     setState(() {
//       messages.add(Message(
//         text: "Payment failed. Please try again.",
//         isBot: true,
//       ));
//     });
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     setState(() {
//       messages.add(Message(
//         text: "External wallet selected: ${response.walletName}",
//         isBot: true,
//       ));
//     });
//   }
//
//   Future<void> loadDoctorMessage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? lastDoctorName = prefs.getString('lastDoctorName');
//     if (lastDoctorName != null && lastDoctorName.isNotEmpty) {
//       if (!mounted) return;
//       setState(() {
//         messages.clear();
//         messages.add(Message(text: "I chose Dr. $lastDoctorName", isBot: false));
//         messages.add(Message(
//           text: "You chose Dr. $lastDoctorName for your consultation.",
//           isBot: true,
//         ));
//         messages.add(Message(
//           text: "Please upload your medical report for consultation.",
//           isBot: true,
//           isUploadPrompt: true,
//         ));
//       });
//       prefs.remove('lastDoctorName');
//     }
//   }
//
//   void sendUserMessage(String userText) {
//     setState(() {
//       messages.add(Message(text: userText, isBot: false));
//
//       if (userText.toLowerCase() == "yes") {
//         for (int i = 0; i < 4; i++) {
//           if (messages[i].showButtons || messages[i].isYesNoPrompt) {
//             messages[i] = Message(
//               text: messages[i].text,
//               isBot: messages[i].isBot,
//             );
//             break;
//           }
//         }
//
//         if (!reportUploaded) {
//           showDropdown = true;
//           messages.add(Message(
//             text: "Choose the doctor category:",
//             isBot: true,
//           ));
//         } else {
//           messages.add(Message(
//             text: "Please upload your medical report for consultation.",
//             isBot: true,
//             isUploadPrompt: true,
//           ));
//         }
//       } else if (userText.toLowerCase() == "no" && reportUploaded) {
//         messages.add(Message(
//           text: "Okay. Now type your query to ask the doctor.",
//           isBot: true,
//         ));
//       }
//     });
//   }
//
//   Widget buildMessageBubble(Message msg) {
//     return Column(
//       crossAxisAlignment:
//       msg.isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: msg.isBot ? Colors.teal.shade100 : Colors.teal.shade200,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Text(msg.text, style: const TextStyle(color: Colors.black)),
//         ),
//         if (msg.showButtons) buildYesButtonOnly(),
//         if (msg.isDoctorChoice) buildChooseDoctorButton(),
//         if (msg.isUploadPrompt) buildUploadReportButton(),
//         if (msg.isYesNoPrompt) buildYesNoButtons(),
//         if (showDropdown && msg == messages.last) buildCategoryDropdown(),
//         if (paymentPrompt && msg == messages.last) buildPaymentButton(),
//       ],
//     );
//   }
//
//   Widget buildYesButtonOnly() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12),
//       child: ElevatedButton(
//         onPressed: () => sendUserMessage("Yes"),
//         child: const Text("Yes"),
//       ),
//     );
//   }
//
//   Widget buildYesNoButtons() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12, top: 4),
//       child: Row(
//         children: [
//           ElevatedButton(
//             onPressed: () => sendUserMessage("Yes"),
//             child: const Text("Yes"),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green.shade100,
//               foregroundColor: Colors.black,
//             ),
//           ),
//           const SizedBox(width: 10),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 messages.add(Message(
//                   text: "Okay. Now type your query to ask the doctor.",
//                   isBot: true,
//                 ));
//                 reportUploaded = true;
//               });
//             },
//             child: const Text("No"),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red.shade100,
//               foregroundColor: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildCategoryDropdown() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       child: DropdownButton<String>(
//         value: selectedCategory,
//         hint: const Text("Select Category"),
//         isExpanded: true,
//         items: doctorCategories.map((String category) {
//           return DropdownMenuItem<String>(
//             value: category,
//             child: Text(category),
//           );
//         }).toList(),
//         onChanged: (String? value) {
//           if (value != null) {
//             setState(() {
//               selectedCategory = value;
//               showDropdown = false;
//               paymentPrompt = true;
//
//               messages.add(Message(text: "I choose $value", isBot: false));
//               messages.add(Message(
//                 text: "Please complete your payment for doctor consultation.",
//                 isBot: true,
//               ));
//             });
//           }
//         },
//       ),
//     );
//   }
//
//   Widget buildPaymentButton() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12, top: 4),
//       child: ElevatedButton.icon(
//         onPressed: () {
//           try {
//             var options = {
//               'key': 'rzp_test_vDQGr1D5EBRubo',
//               'amount': 20000,
//               'currency': 'INR',
//               'name': 'VSGLogic',
//               'description': 'Doctor Consultation Fee',
//               'prefill': {'contact': '9999999999', 'email': 'user@example.com'},
//               'theme': {'color': '#0D4F45'}
//             };
//             _razorpay.open(options);
//           } catch (e) {
//             debugPrint("Error: $e");
//             ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Unable to open Razorpay")));
//           }
//         },
//         icon: const Icon(Icons.payment),
//         label: const Text("Pay ₹200"),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.green.shade100,
//           foregroundColor: Colors.black,
//         ),
//       ),
//     );
//   }
//
//   Widget buildChooseDoctorButton() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12),
//       child: ElevatedButton.icon(
//         onPressed: () async {
//           final selectedDoctor = await Navigator.pushNamed(context, '/doctors');
//           if (selectedDoctor != null &&
//               selectedDoctor is String &&
//               selectedDoctor.isNotEmpty) {
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.setString('lastDoctorName', selectedDoctor);
//
//             setState(() {
//               messages.clear();
//               messages.add(
//                   Message(text: "I chose Dr. $selectedDoctor", isBot: false));
//               messages.add(Message(
//                 text: "Nice, you chose Dr. $selectedDoctor for your consultation.",
//                 isBot: true,
//               ));
//               messages.add(Message(
//                 text: "Please upload your medical report for consultation.",
//                 isBot: true,
//                 isUploadPrompt: true,
//               ));
//             });
//           } else {
//             setState(() {
//               messages.add(Message(
//                 text: "You did not choose any doctor. Please choose your doctor.",
//                 isBot: true,
//                 isDoctorChoice: true,
//               ));
//             });
//           }
//         },
//         icon: const Icon(Icons.add),
//         label: const Text("Choose Doctor"),
//       ),
//     );
//   }
//
//   Widget buildUploadReportButton() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12, top: 4),
//       child: ElevatedButton.icon(
//         onPressed: () async {
//           if (reportUploadCount >= 3) {
//             setState(() {
//               messages.add(Message(
//                 text: "You have uploaded maximum 3 reports.",
//                 isBot: true,
//               ));
//               messages.add(Message(
//                 text: "Okay. Now type your query to ask the doctor.",
//                 isBot: true,
//               ));
//               reportUploaded = true;
//             });
//             return;
//           }
//
//           final result = await Navigator.pushNamed(context, '/upload');
//           if (result == 'uploaded') {
//             setState(() {
//               reportUploadCount++;
//               reportUploaded = true;
//               messages.add(Message(
//                 text: "Your report uploaded successfully!",
//                 isBot: true,
//               ));
//
//               if (reportUploadCount < 3) {
//                 messages.add(Message(
//                   text: "Do you want to upload more reports?",
//                   isBot: true,
//                   isYesNoPrompt: true,
//                 ));
//               } else {
//                 messages.add(Message(
//                   text: "You have uploaded maximum 3 reports.",
//                   isBot: true,
//                 ));
//                 messages.add(Message(
//                   text: "Okay. Now type your query to ask the doctor.",
//                   isBot: true,
//                 ));
//               }
//             });
//           }
//         },
//         icon: const Icon(Icons.upload_file),
//         label: const Text("Upload Report"),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.grey.shade50,
//           foregroundColor: Colors.black,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         backgroundColor: const Color(0xFF0D4F45),
//         title: const Center(
//           child: Text("VSGLogic ChatApp",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold)),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/profile');
//               },
//               icon: const Icon(Icons.person_outline_sharp, color: Colors.white))
//         ],
//       ),
//       drawer: Drawer(
//         backgroundColor: const Color(0xFF0D4F45),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 40),
//               drawerItem("Home", Icons.home, null),
//               Divider(color: Colors.teal.shade100, thickness: 2, indent: 12),
//               drawerItem("Doctor", Icons.add, () {
//                 Navigator.pushNamed(context, '/doctors');
//               }),
//               drawerItem("Orders", Icons.file_copy_sharp, () {
//                 Navigator.pushNamed(context, '/orders');
//               }),
//               drawerItem("Terms & Privacy", Icons.privacy_tip, () {
//                 Navigator.pushNamed(context, '/terms');
//               }),
//               drawerItem("LogOut", Icons.logout_sharp, () async {
//                 bool? confirm = await showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Confirm Logout'),
//                     content: const Text('Are you sure you want to logout?'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context, false),
//                         child: const Text('Cancel'),
//                       ),
//                       TextButton(
//                         onPressed: () => Navigator.pop(context, true),
//                         child: const Text('Logout'),
//                       ),
//                     ],
//                   ),
//                 );
//                 if (confirm == true) {
//                   await logoutUser(context);
//                 }
//               }),
//               Divider(color: Colors.teal.shade100, thickness: 2, indent: 12),
//               const SizedBox(height: 50),
//               Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Padding(
//                       padding: EdgeInsets.all(3.0),
//                       child: Text("Made With",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w300,
//                               fontSize: 12)),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(3.0),
//                       child:
//                       Icon(Icons.favorite, color: Colors.white, size: 14),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(3.0),
//                       child: Text("By VSGLogic",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w300,
//                               fontSize: 12)),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return buildMessageBubble(messages[index]);
//               },
//             ),
//           ),
//           SafeArea(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               color: const Color(0xFF0D4F45),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: reportUploaded && !queryAsked
//                         ? () => Navigator.pushNamed(context, '/upload')
//                         : null,
//                     child: Icon(Icons.attach_file,
//                         color: reportUploaded && !queryAsked
//                             ? Colors.teal.shade100
//                             : Colors.grey),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: reportUploaded && !queryAsked
//                             ? Colors.white
//                             : Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(21),
//                       ),
//                       child: TextField(
//                         controller: m1,
//                         enabled: reportUploaded && !queryAsked,
//                         decoration: InputDecoration(
//                           hintText: reportUploaded && !queryAsked
//                               ? "Type A Message"
//                               : "Upload reports to start",
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: reportUploaded && !queryAsked
//                         ? () {
//                       if (m1.text.trim().isNotEmpty) {
//                         sendUserMessage(m1.text.trim());
//                         m1.clear();
//                         setState(() {
//                           queryAsked = true;
//                           reportUploaded = false;
//                         });
//                         messages.add(Message(
//                           text: "Your query has been sent to the doctor. Please wait for the response.",
//                           isBot: true,
//                         ));
//                       }
//                     }
//                         : null,
//                     child: Icon(Icons.send,
//                         color: reportUploaded && !queryAsked
//                             ? Colors.teal.shade100
//                             : Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget drawerItem(String title, IconData icon, VoidCallback? onTap) {
//     return ListTile(
//       leading: Icon(icon, size: 25, color: Colors.teal.shade100),
//       title: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(title,
//             style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white)),
//       ),
//       onTap: onTap,
//     );
//   }
// }