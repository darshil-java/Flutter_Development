// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_selector/file_selector.dart';
// import 'package:http/http.dart' as http;
// import 'package:mime/mime.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:path/path.dart' as path;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:open_filex/open_filex.dart';
// import 'helper.dart';
//
// class UploadFiles extends StatefulWidget {
//   const UploadFiles({super.key});
//
//   @override
//   State<UploadFiles> createState() => _UploadFilesState();
// }
//
// class _UploadFilesState extends State<UploadFiles> {
//   List<Map<String, dynamic>> _selectedReports = [];
//   bool _isUploading = false;
//   String? _userEmail;
//
//   final List<String> _categories = [
//     'Blood Test',
//     'X-Ray',
//     'MRI Scan',
//     'CT Scan',
//     'Ultrasound',
//     'Prescription',
//     'ECG',
//     'Other'
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadEmail();
//   }
//
//   Future<void> _loadEmail() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _userEmail = prefs.getString('email') ?? '';
//     });
//   }
//
//   Future<void> _browse(String category) async {
//     if (_selectedReports.length >= 3) {
//       Helpers.showSnackBar(context, "You can upload maximum 3 reports only.");
//       return;
//     }
//
//     final XFile? file = await openFile(
//       acceptedTypeGroups: [XTypeGroup(label: 'any', extensions: [])],
//     );
//
//     if (file != null && mounted) {
//       setState(() {
//         _selectedReports.add({
//           "category": category,
//           "file": file,
//         });
//       });
//     }
//   }
//
//   Future<void> _uploadFileToServer() async {
//     if (_selectedReports.isEmpty) return;
//     if (_userEmail == null || _userEmail!.isEmpty) {
//       Helpers.showSnackBar(context, "Email not found. Please login again.");
//       return;
//     }
//
//     setState(() {
//       _isUploading = true;
//     });
//
//     var uri = Uri.parse(ApiConfig.upload);
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['email'] = _userEmail!;
//
//     // Extract categories for the return data
//     List<String> selectedCategories = _selectedReports.map((r) => r["category"] as String).toList();
//     List<Map<String, dynamic>> uploadedFiles = [];
//
//     try {
//       for (var report in _selectedReports) {
//         XFile file = report["file"];
//         String category = report["category"];
//         String fileName = path.basename(file.path);
//         String? mimeType = lookupMimeType(file.path);
//
//         var multipartFile = await http.MultipartFile.fromPath(
//           'files',
//           file.path,
//           filename: fileName,
//           contentType: mimeType != null ? MediaType.parse(mimeType) : null,
//         );
//
//         request.files.add(multipartFile);
//         request.fields['categories[]'] = category;
//
//         // Prepare file info for return data
//         uploadedFiles.add({
//           'category': category,
//           'fileName': fileName,
//           'filePath': file.path,
//           'fileSize': await file.length(),
//           'fileType': mimeType ?? 'unknown',
//         });
//       }
//
//       var response = await request.send();
//
//       if (response.statusCode == 200) {
//         var responseBody = await response.stream.bytesToString();
//         print("Upload success: $responseBody");
//         Helpers.showSnackBar(context, "Upload successful", bgColor: AppColors.primary);
//
//         // Prepare the return data with both reports and categories
//         final returnData = {
//           'status': 'uploaded',
//           'reports': uploadedFiles,
//           'categories': selectedCategories,
//         };
//
//         print('📤 Returning data to HomePage: $returnData');
//
//         setState(() {
//           _selectedReports.clear();
//         });
//
//         await Future.delayed(const Duration(seconds: 1));
//
//         if (mounted) {
//           Navigator.pop(context, returnData);
//         }
//       }
//       else {
//         print("Upload failed with status: ${response.statusCode}");
//         Helpers.showSnackBar(context, "Upload failed", bgColor: Colors.red.shade700);
//       }
//     } catch (e) {
//       print("Error: $e");
//       Helpers.showSnackBar(context, "Upload error: $e", bgColor: Colors.red.shade700);
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }
//
//   void _chooseCategory() {
//     if (_selectedReports.length >= 3) {
//       Helpers.showSnackBar(context, "You can upload maximum 3 reports only.");
//       return;
//     }
//
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: ListView(
//             shrinkWrap: true,
//             children: _categories.map((category) {
//               return ListTile(
//                 leading: Icon(Icons.medical_services, color: AppColors.primary),
//                 title: Text(category),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _browse(category);
//                 },
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textLight),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text('Upload Reports',
//             style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 height: 170,
//                 decoration: BoxDecoration(
//                   color: AppColors.background,
//                   border: Border.all(
//                     color: Colors.grey.shade400,
//                     width: 1.5,
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.cloud_upload_outlined, size: 48, color: AppColors.primary),
//                       SizedBox(height: 8),
//                       Text(
//                         "Tap to choose category and upload file (max 3)",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: Colors.grey.shade700, fontWeight: FontWeight.w600),
//                       ),
//                       SizedBox(height: 12),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                         ),
//                         onPressed: _chooseCategory,
//                         child: Text("Choose Category & Upload",
//                             style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w400)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24),
//
//               if (_selectedReports.isNotEmpty)
//                 Column(
//                   children: _selectedReports.map((report) {
//                     XFile file = report["file"];
//                     String category = report["category"];
//                     return Container(
//                       margin: EdgeInsets.only(bottom: 12),
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: AppColors.background,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.insert_drive_file, color: Colors.blue),
//                           SizedBox(width: 12),
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () async {
//                                 final result = await OpenFilex.open(file.path);
//                                 debugPrint("📂 Opened file: ${result.message}");
//                               },
//                               child: Text(
//                                 "$category - ${file.name}",
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           IconButton(
//                             icon: Icon(Icons.close),
//                             onPressed: () => setState(() {
//                               _selectedReports.remove(report);
//                             }),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//
//               SizedBox(height: 24),
//
//               SizedBox(
//                 height: 48,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                   onPressed: _selectedReports.isEmpty || _isUploading
//                       ? null
//                       : _uploadFileToServer,
//                   child: _isUploading
//                       ? CircularProgressIndicator(color: AppColors.textLight)
//                       : Text("Submit Reports",
//                       style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
//                 ),
//               ),
//
//               SizedBox(height: 16),
//
//               Text(
//                 "ℹ️ You can upload a maximum of 3 reports.\n"
//                     "📌 Select category first, then choose your report file.\n"
//                     "⚠️ After uploading all reports, click Submit.\n"
//                     "🚫 Once you leave this page, you cannot open it again.\n"
//                     "️⚠️ Max File Size Is 5MB",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.red.shade700,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_filex/open_filex.dart';
import 'helper.dart';

class UploadFiles extends StatefulWidget {
  final String orderId;
  final String userId;
  final bool isAdditionalUpload; // NEW: Add this parameter

  const UploadFiles({
    super.key,
    required this.orderId,
    required this.userId,
    this.isAdditionalUpload = false,
  });

  @override
  State<UploadFiles> createState() => _UploadFilesState();
}

class _UploadFilesState extends State<UploadFiles> {
  List<Map<String, dynamic>> _selectedReports = [];
  bool _isUploading = false;
  String? _userEmail;

  final List<String> _categories = [
    'Blood Test',
    'X-Ray',
    'MRI Scan',
    'CT Scan',
    'Ultrasound',
    'Prescription',
    'ECG',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('email') ?? '';
    });
  }

  Future<void> _browse(String category) async {
    if (_selectedReports.length >= 3) {
      Helpers.showSnackBar(context, "You can upload maximum 3 reports only.");
      return;
    }

    final XFile? file = await openFile(
      acceptedTypeGroups: [XTypeGroup(label: 'any', extensions: [])],
    );

    if (file != null && mounted) {
      setState(() {
        _selectedReports.add({
          "category": category,
          "file": file,
        });
      });
    }
  }

  Future<void> _uploadFileToServer() async {
    if (_selectedReports.isEmpty) return;
    if (_userEmail == null || _userEmail!.isEmpty) {
      Helpers.showSnackBar(context, "Email not found. Please login again.");
      return;
    }

    setState(() {
      _isUploading = true;
    });

    var uri = Uri.parse(ApiConfig.upload);
    var request = http.MultipartRequest('POST', uri);

    // ✅ CRITICAL: Send all required fields for backend
    request.fields['email'] = _userEmail!;
    request.fields['userId'] = widget.userId;
    request.fields['orderId'] = widget.orderId;

    print('📤 Uploading files with:');
    print('   - userId: ${widget.userId}');
    print('   - orderId: ${widget.orderId}');
    print('   - email: $_userEmail');

    // Extract categories for the return data
    List<String> selectedCategories = _selectedReports.map((r) => r["category"] as String).toList();
    List<Map<String, dynamic>> uploadedFiles = [];

    try {
      // Prepare categories as JSON string
      request.fields['categories'] = jsonEncode(selectedCategories);

      for (var report in _selectedReports) {
        XFile file = report["file"];
        String category = report["category"];
        String fileName = path.basename(file.path);
        String? mimeType = lookupMimeType(file.path);

        var multipartFile = await http.MultipartFile.fromPath(
          'files',
          file.path,
          filename: fileName,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        );

        request.files.add(multipartFile);

        // Prepare file info for return data
        uploadedFiles.add({
          'category': category,
          'fileName': fileName,
          'filePath': file.path,
          'fileSize': await file.length(),
          'fileType': mimeType ?? 'unknown',
        });
      }

      print('🚀 Sending upload request with ${request.files.length} files');

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('📥 Upload response: ${response.statusCode}');
      print('📥 Response body: $responseBody');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseBody);

        if (jsonResponse['success'] == true) {
          print("✅ Upload success: ${jsonResponse['message']}");
          Helpers.showSnackBar(context, "Upload successful", bgColor: AppColors.primary);

          // Prepare the return data with both reports and categories
          final returnData = {
            'status': 'uploaded',
            'reports': uploadedFiles,
            'categories': selectedCategories,
          };

          print('📤 Returning data to HomePage: $returnData');

          setState(() {
            _selectedReports.clear();
          });

          await Future.delayed(const Duration(seconds: 1));

          if (mounted) {
            Navigator.pop(context, returnData);
          }
        } else {
          print("❌ Upload failed: ${jsonResponse['message']}");
          Helpers.showSnackBar(context, "Upload failed: ${jsonResponse['message']}", bgColor: Colors.red.shade700);
        }
      } else {
        print("❌ Upload failed with status: ${response.statusCode}");
        var errorResponse = jsonDecode(responseBody);
        Helpers.showSnackBar(context, "Upload failed: ${errorResponse['message'] ?? 'Unknown error'}", bgColor: Colors.red.shade700);
      }
    } catch (e) {
      print("❌ Upload error: $e");
      Helpers.showSnackBar(context, "Upload error: $e", bgColor: Colors.red.shade700);
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _chooseCategory() {
    if (_selectedReports.length >= 3) {
      Helpers.showSnackBar(context, "You can upload maximum 3 reports only.");
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: _categories.map((category) {
              return ListTile(
                leading: Icon(Icons.medical_services, color: AppColors.primary),
                title: Text(category),
                onTap: () {
                  Navigator.pop(context);
                  _browse(category);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  Future<void> _viewFile(XFile file) async {
    try {
      final result = await OpenFilex.open(file.path);
      if (result.type == ResultType.done) {
        debugPrint("✅ File opened successfully: ${file.name}");
      } else if (result.type == ResultType.noAppToOpen) {
        Helpers.showSnackBar(context, "No application available to open this file type", bgColor: Colors.orange);
      } else if (result.type == ResultType.fileNotFound) {
        Helpers.showSnackBar(context, "File not found", bgColor: Colors.red);
      } else {
        Helpers.showSnackBar(context, "Could not open file: ${result.message}", bgColor: Colors.red);
      }
    } catch (e) {
      debugPrint("❌ Error opening file: $e");
      Helpers.showSnackBar(context, "Error opening file: $e", bgColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Upload Reports',
            style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Order info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          "Order Information",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Order ID: ${widget.orderId}",
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "User ID: ${widget.userId}",
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_userEmail != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        "Email: $_userEmail",
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Upload area
              Container(
                height: 170,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 48, color: AppColors.primary),
                      const SizedBox(height: 8),
                      Text(
                        "Tap to choose category and upload file",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Maximum 3 files allowed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: _chooseCategory,
                        child: Text(
                          "Choose Category & Upload",
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Selected files list
              if (_selectedReports.isNotEmpty) ...[
                Text(
                  "Selected Files (${_selectedReports.length}/3):",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: _selectedReports.map((report) {
                    XFile file = report["file"];
                    String category = report["category"];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.insert_drive_file,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _viewFile(file),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    file.name,
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  FutureBuilder<int>(
                                    future: file.length(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          _formatFileSize(snapshot.data!),
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 11,
                                          ),
                                        );
                                      }
                                      return Text(
                                        "Calculating size...",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 11,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red.shade600),
                            onPressed: () => setState(() {
                              _selectedReports.remove(report);
                            }),
                            tooltip: "Remove file",
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],

              // Submit button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedReports.isNotEmpty && !_isUploading
                        ? AppColors.primary
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _selectedReports.isEmpty || _isUploading
                      ? null
                      : _uploadFileToServer,
                  child: _isUploading
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Uploading...",
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                      : Text(
                    "Submit ${_selectedReports.length} File${_selectedReports.length > 1 ? 's' : ''}",
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange.shade700),
                        const SizedBox(width: 8),
                        Text(
                          "Important Instructions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInstruction("📌", "Select category first, then choose your report file"),
                    _buildInstruction("⚠️", "You can upload maximum 3 reports only"),
                    _buildInstruction("🚫", "Once you leave this page, you cannot upload again"),
                    _buildInstruction("📄", "Supported formats: PDF, Images, Documents"),
                    _buildInstruction("💾", "Maximum file size: 5MB per file"),
                    _buildInstruction("✅", "Files will be shared with your assigned doctor"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.orange.shade800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}