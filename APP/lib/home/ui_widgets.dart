// import 'package:flutter/material.dart';
// import 'message_model.dart';
// import 'package:intl/intl.dart';
// import 'package:open_filex/open_filex.dart';
// import '../helper.dart';  // contains AppColors
//
// class UIWidgets {
//   static Widget buildHomePageBody(dynamic state, BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             controller: state.scrollController,
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             itemCount: state.messages.length,
//             itemBuilder: (context, index) {
//               final msg = state.messages[index];
//               bool showDate = false;
//               if (index == 0) {
//                 showDate = true;
//               } else {
//                 final prevMsg = state.messages[index - 1];
//                 if (msg.createdAt != null && prevMsg.createdAt != null) {
//                   showDate = !state.isSameDay(msg.createdAt!, prevMsg.createdAt!);
//                 }
//               }
//               return Column(
//                 children: [
//                   if (showDate && msg.createdAt != null)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: Container(
//                         padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           state.formatDate(msg.createdAt!),
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textLight,
//                           ),
//                         ),
//                       ),
//                     ),
//                   buildMessageBubble(state, msg, context),
//                 ],
//               );
//             },
//           ),
//         ),
//         SafeArea(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             color: AppColors.primary,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: state.canUseChat() ? Colors.white : Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(21),
//                     ),
//                     child: TextField(
//                       controller: state.m1,
//                       enabled: state.canUseChat(),
//                       keyboardType: TextInputType.multiline,
//                       textInputAction: TextInputAction.newline,
//                       minLines: 1,
//                       maxLines: 4,
//                       decoration: InputDecoration(
//                         hintText: state.canUseChat()
//                             ? "Type your message here"
//                             : "Complete required steps to chat",
//                         border: InputBorder.none,
//                         isDense: true,
//                         contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                       ),
//                       onChanged: (text) {
//                         WidgetsBinding.instance.addPostFrameCallback((_) {
//                           state.scrollToBottom();
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: state.canUseChat()
//                       ? () {
//                     if (state.m1.text.trim().isNotEmpty) {
//                       state.sendUserMessage(state.m1.text.trim());
//                       state.m1.clear();
//                       state.setState(() {
//                         state.queryAsked = true;
//                         state.reportUploaded = false;
//                       });
//                       state._addMessage(Message(
//                           text:
//                           "Your query has been submitted to the doctor. Please wait for their response.",
//                           isBot: true));
//                     }
//                   }
//                       : null,
//                   child: Icon(
//                     Icons.send,
//                     color: state.canUseChat()
//                         ? AppColors.iconColor
//                         : Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
//
//   static Widget buildMessageBubble(dynamic state, Message msg, BuildContext context) {
//     final isBot = msg.isBot;
//     return Column(
//       crossAxisAlignment: isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//       children: [
//         Align(
//           alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
//           child: GestureDetector(
//             onTap: () async {
//               if (msg.filePath != null) {
//                 String path = msg.filePath!;
//                 if (path.startsWith('http')) {
//                   path = await state.downloadFile(path, path.split('/').last) ?? '';
//                 }
//                 if (path.isNotEmpty) {
//                   final result = await OpenFilex.open(path);
//                   debugPrint("📂 Opened file: ${result.message}");
//                 }
//               }
//             },
//             child: Container(
//               margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//               padding: const EdgeInsets.all(12),
//               constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//               decoration: BoxDecoration(
//                 color: msg.filePath != null
//                     ? Colors.white
//                     : (isBot ? AppColors.chatBot : AppColors.chatUser),
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(16),
//                   topRight: const Radius.circular(16),
//                   bottomLeft: isBot ? const Radius.circular(0) : const Radius.circular(16),
//                   bottomRight: isBot ? const Radius.circular(16) : const Radius.circular(0),
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (msg.filePath != null) const SizedBox(width: 6),
//                   Flexible(
//                     child: Text(
//                       msg.text,
//                       style: TextStyle(
//                         color: isBot ? AppColors.chatBotText : AppColors.chatUserText,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         if (msg.createdAt != null)
//           Padding(
//             padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
//             child: Text(
//               DateFormat('hh:mm a').format(msg.createdAt!.toLocal()),
//               style: const TextStyle(color: Colors.grey, fontSize: 10),
//             ),
//           ),
//         if (msg.showButtons && msg.isSecondOpinion && !state.showTypeConfirm)
//           buildYesButtonOnly(state),
//         if (msg.showButtons && state.showTypeConfirm && !msg.isSecondOpinion && msg.id == state.activeConfirmMessageId)
//           buildYesNoButtons(state),
//         if (msg.isUploadPrompt) buildUploadReportButton(state),
//         if (state.showDoctorTypeOptions && msg == state.messages.last) buildDoctorTypeOptions(state),
//         if (state.showDropdown && msg == state.messages.last) buildCategoryDropdown(state),
//         if (state.paymentPrompt && msg == state.messages.last) buildPaymentButton(state),
//       ],
//     );
//   }
//
//   static Widget buildYesButtonOnly(dynamic state) {
//     if (state.yesClicked) return const SizedBox.shrink();
//     return Padding(
//       padding: const EdgeInsets.only(left: 12),
//       child: ElevatedButton(
//         onPressed: () {
//           state.setState(() {
//             state.yesClicked = true;
//           });
//           state.sendUserMessage("Yes");
//         },
//         style: ElevatedButton.styleFrom(
//           foregroundColor: AppColors.buttonText,
//         ),
//         child: const Text("Yes"),
//       ),
//     );
//   }
//
//   static Widget buildYesNoButtons(dynamic state) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12),
//       child: Row(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               state.setState(() {
//                 state.showTypeConfirm = false;
//
//                 if (state.pendingDoctorType == "Allopathy") {
//                   state.showDropdown = true;
//                   state._addMessage(Message(text: "Yes, continue with Allopathy.", isBot: false));
//                   state._addMessage(Message(text: "Now select the doctor's specialty:", isBot: true));
//                 } else {
//                   state.paymentPrompt = true;
//                   state._addMessage(Message(text: "Yes, continue with ${state.pendingDoctorType}.", isBot: false));
//                   state._addMessage(Message(text: "Please complete the payment to confirm the consultation.", isBot: true));
//                 }
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: AppColors.textLight,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             ),
//             child: const Text("Yes"),
//           ),
//           const SizedBox(width: 10),
//           ElevatedButton(
//             onPressed: () {
//               state.setState(() {
//                 state.showTypeConfirm = false;
//                 state.selectedDoctorType = null;
//                 state.pendingDoctorType = null;
//                 state.showDoctorTypeOptions = true;
//               });
//               state._addMessage(Message(text: "No, I don’t want this option.", isBot: false));
//               state._addMessage(Message(text: "Please choose another doctor type:", isBot: true));
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.background,
//               foregroundColor: AppColors.textDark,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             ),
//             child: const Text("No"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   static Widget buildUploadReportButton(dynamic state) {
//     if (!state.showUploadButton || state.reportUploaded) return const SizedBox.shrink();
//
//     return Padding(
//       padding: const EdgeInsets.only(left: 12, top: 4),
//       child: ElevatedButton.icon(
//         onPressed: () async {
//           final result = await Navigator.pushNamed(state.context, '/upload');
//
//           if (result is Map && result['status'] == 'uploaded') {
//             List reports = result['reports'];
//
//             state.setState(() {
//               state.reportUploaded = true;
//               state.showUploadButton = false;
//             });
//
//             state._addMessage(Message(text: "✅ Your reports have been successfully uploaded.", isBot: true));
//
//             for (var r in reports) {
//               state._addMessage(Message(text: "📄 ${r['category']} - ${r['fileName']}", isBot: false, filePath: r['filePath']));
//             }
//
//             state._addMessage(Message(text: "You may now type your query for the doctor.", isBot: true));
//           }
//         },
//         icon: Icon(Icons.upload_file, color: AppColors.iconColor),
//         label: Text("Upload Report", style: TextStyle(color: AppColors.iconColor)),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.buttonSecondary,
//         ),
//       ),
//     );
//   }
//
//   static Widget buildDoctorTypeOptions(dynamic state) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: AppColors.chatBot,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         width: double.infinity,
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             hint: const Text("Please choose a doctor type", style: TextStyle(color: AppColors.buttonText)),
//             dropdownColor: AppColors.chatBot,
//             value: state.selectedDoctorType,
//             isExpanded: true,
//             items: state.doctorTypes.map<DropdownMenuItem<String>>((String type) {
//               return DropdownMenuItem<String>(
//                 value: type,
//                 child: Text(type, style: const TextStyle(color: Colors.black)),
//               );
//             }).toList(),
//             onChanged: (String? value) {
//               if (value != null) {
//                 final confirmMsg = Message(
//                   text: "You selected $value. Do you want to continue?",
//                   isBot: true,
//                   showButtons: true,
//                   isSecondOpinion: false,
//                 );
//
//                 state._addMessage(confirmMsg);
//
//                 state.setState(() {
//                   state.selectedDoctorType = value;
//                   state.pendingDoctorType = value;
//                   state.showDoctorTypeOptions = false;
//                   state.showTypeConfirm = true;
//                   state.activeConfirmMessageId = confirmMsg.id;
//                 });
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   static Widget buildCategoryDropdown(dynamic state) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       child: DropdownButton<String>(
//         value: state.selectedCategory,
//         hint: const Text("Select Category"),
//         isExpanded: true,
//         menuMaxHeight: 200,
//         items: state.doctorCategories.map<DropdownMenuItem<String>>((String category) {
//           return DropdownMenuItem<String>(
//             value: category,
//             child: Text(category),
//           );
//         }).toList(),
//         onChanged: (String? value) {
//           if (value != null) {
//             state.setState(() {
//               state.selectedCategory = value;
//               state.showDropdown = false;
//               state.paymentPrompt = true;
//
//               state._addMessage(Message(text: "Selected: $value", isBot: false));
//               state._addMessage(Message(text: "Please complete the payment to confirm the consultation.", isBot: true));
//             });
//           }
//         },
//       ),
//     );
//   }
//
//   static Widget buildPaymentButton(dynamic state) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12, top: 4),
//       child: ElevatedButton.icon(
//         onPressed: () {
//           String doctorCategory = state.selectedDoctorType == "Allopathy"
//               ? state.selectedCategory ?? "General"
//               : state.selectedDoctorType!;
//           state.createOrder(200, doctorCategory);
//         },
//         icon: Icon(Icons.payment, color: AppColors.iconColor),
//         label: Text("Pay ₹200", style: TextStyle(color: AppColors.buttonText)),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.buttonSecondary,
//         ),
//       ),
//     );
//   }
// }
