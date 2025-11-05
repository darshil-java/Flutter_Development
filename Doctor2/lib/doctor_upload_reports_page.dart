// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'helper.dart';
//
// class DoctorUploadReportsPage extends StatefulWidget {
//   final String orderId;
//
//   const DoctorUploadReportsPage({super.key, required this.orderId});
//
//   @override
//   State<DoctorUploadReportsPage> createState() => _DoctorUploadReportsPageState();
// }
//
// class _DoctorUploadReportsPageState extends State<DoctorUploadReportsPage> {
//   List<PlatformFile> selectedFiles = [];
//   bool isUploading = false;
//   String visibility = 'both';
//
//   Future<void> pickFiles() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
//     );
//
//     if (result != null) {
//       setState(() {
//         selectedFiles = result.files;
//       });
//     }
//   }
//
//   Future<void> uploadFiles() async {
//     if (selectedFiles.isEmpty) {
//       Helpers.showSnackBar(context, 'Please select at least one file');
//       return;
//     }
//
//     setState(() => isUploading = true);
//
//     try {
//       final uri = Uri.parse("${ApiConfig.baseUrl}/uploadDoctorFiles");
//       var request = http.MultipartRequest('POST', uri);
//
//       // Add orderId and visibility
//       request.fields['orderId'] = widget.orderId;
//       request.fields['visibility'] = visibility;
//
//       // Add files
//       for (var file in selectedFiles) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'files',
//           file.path!,
//           filename: file.name,
//         ));
//       }
//
//       print("📤 Uploading ${selectedFiles.length} files for order ${widget.orderId}");
//       var response = await request.send();
//       var responseBody = await response.stream.bytesToString();
//       print('📥 Response: $responseBody');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(responseBody);
//         Helpers.showSnackBar(context, '✅ ${data['message']}', bgColor: Colors.green);
//         Navigator.pop(context, true);
//       } else {
//         final data = jsonDecode(responseBody);
//         Helpers.showSnackBar(context, '❌ ${data['message'] ?? "Upload failed"}', bgColor: Colors.red);
//       }
//     } catch (e) {
//       print('💥 Upload error: $e');
//       Helpers.showSnackBar(context, 'Upload failed: $e', bgColor: Colors.red);
//     } finally {
//       setState(() => isUploading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Upload Reports"),
//         backgroundColor: AppColors.primary,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ElevatedButton.icon(
//               onPressed: pickFiles,
//               icon: const Icon(Icons.attach_file),
//               label: const Text("Choose Files"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//               ),
//             ),
//             const SizedBox(height: 12),
//             if (selectedFiles.isNotEmpty)
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: selectedFiles.length,
//                   itemBuilder: (context, index) {
//                     final file = selectedFiles[index];
//                     return ListTile(
//                       leading: const Icon(Icons.insert_drive_file, color: Colors.blueAccent),
//                       title: Text(file.name),
//                       subtitle: Text("${(file.size / 1024).toStringAsFixed(2)} KB"),
//                     );
//                   },
//                 ),
//               )
//             else
//               const Text("No files selected."),
//
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 const Text("Visibility: "),
//                 const SizedBox(width: 10),
//                 DropdownButton<String>(
//                   value: visibility,
//                   items: const [
//                     DropdownMenuItem(value: 'both', child: Text('Both Doctor & Patient')),
//                     DropdownMenuItem(value: 'doctor', child: Text('Only Doctor')),
//                     DropdownMenuItem(value: 'patient', child: Text('Only Patient')),
//                   ],
//                   onChanged: (val) {
//                     setState(() => visibility = val!);
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Center(
//               child: ElevatedButton.icon(
//                 onPressed: isUploading ? null : uploadFiles,
//                 icon: const Icon(Icons.cloud_upload),
//                 label: Text(isUploading ? "Uploading..." : "Upload Reports"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:open_filex/open_filex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper.dart';

class DoctorUploadReportsPage extends StatefulWidget {
  final String orderId;

  const DoctorUploadReportsPage({super.key, required this.orderId});

  @override
  State<DoctorUploadReportsPage> createState() =>
      _DoctorUploadReportsPageState();
}

class _DoctorUploadReportsPageState extends State<DoctorUploadReportsPage> {
  List<PlatformFile> selectedFiles = [];
  bool isUploading = false;
  String visibility = 'both';
  String? _authError;

  // 🔐 Get authentication token with validation
  Future<String?> _getAuthToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        setState(() {
          _authError = "Doctor not authenticated. Please login again.";
        });
        return null;
      }

      // Optional: Validate token format (basic check)
      if (token.split('.').length != 3) {
        setState(() {
          _authError = "Invalid token format. Please login again.";
        });
        return null;
      }

      return token;
    } catch (e) {
      setState(() {
        _authError = "Authentication error: $e";
      });
      return null;
    }
  }

  // 📁 Pick up to 3 files directly
  Future<void> _pickFiles() async {
    if (selectedFiles.length >= 3) {
      Helpers.showSnackBar(context, "You can upload maximum 3 reports only.");
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFiles.addAll(result.files.take(3 - selectedFiles.length));
        _authError = null; // Clear any previous auth errors
      });
    }
  }

  // 📤 Upload selected files with proper authentication
  Future<void> _uploadFiles() async {
    if (selectedFiles.isEmpty) {
      Helpers.showSnackBar(context, "Please select at least one file.");
      return;
    }

    // Validate authentication first
    String? token = await _getAuthToken();
    if (token == null) {
      Helpers.showSnackBar(context, _authError ?? "Authentication failed!", bgColor: Colors.red);
      return;
    }

    setState(() => isUploading = true);

    try {
      final uri = Uri.parse("${ApiConfig.baseUrl}/doctor/upload");
      var request = http.MultipartRequest('POST', uri);

      // Add headers with authentication
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add fields
      request.fields['orderId'] = widget.orderId;
      request.fields['visibility'] = visibility;

      // Add files with error handling
      for (var file in selectedFiles) {
        if (file.path == null) {
          Helpers.showSnackBar(context, "Invalid file path for ${file.name}", bgColor: Colors.red);
          continue;
        }

        String fileName = path.basename(file.path!);
        String? mimeType = lookupMimeType(file.path!);

        // Validate file size (5MB limit)
        if (file.size > 5 * 1024 * 1024) {
          Helpers.showSnackBar(context, "File ${file.name} exceeds 5MB limit", bgColor: Colors.red);
          continue;
        }

        try {
          var multipartFile = await http.MultipartFile.fromPath(
            'files',
            file.path!,
            filename: fileName,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          );
          request.files.add(multipartFile);
        } catch (e) {
          Helpers.showSnackBar(context, "Error processing file ${file.name}: $e", bgColor: Colors.red);
        }
      }

      // Check if any valid files were added
      if (request.files.isEmpty) {
        Helpers.showSnackBar(context, "No valid files to upload", bgColor: Colors.red);
        setState(() => isUploading = false);
        return;
      }

      print("📤 Uploading ${request.files.length} files for order ${widget.orderId}");

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print("📥 Response Status: ${response.statusCode}");
      print("📥 Response Body: $responseBody");

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        Helpers.showSnackBar(context, "✅ ${data['message']}", bgColor: Colors.green);
        Navigator.pop(context, true);
      } else if (response.statusCode == 401) {
        // Handle authentication errors specifically
        setState(() {
          _authError = "Authentication failed. Please login again.";
        });
        Helpers.showSnackBar(context, "Authentication failed. Please login again.", bgColor: Colors.red);

        // Optional: Clear invalid token
        await _clearInvalidToken();
      } else if (response.statusCode == 403) {
        Helpers.showSnackBar(context, "Access denied. Doctor privileges required.", bgColor: Colors.red);
      } else {
        final data = jsonDecode(responseBody);
        Helpers.showSnackBar(
          context,
          "❌ ${data['message'] ?? 'Upload failed with status ${response.statusCode}'}",
          bgColor: Colors.red,
        );
      }
    } catch (e) {
      print("💥 Upload error: $e");
      Helpers.showSnackBar(
          context,
          "Upload failed: ${e.toString().contains('Connection') ? 'Network error. Check your connection.' : e.toString()}",
          bgColor: Colors.red
      );
    } finally {
      setState(() => isUploading = false);
    }
  }

  // 🗑️ Clear invalid token from storage
  Future<void> _clearInvalidToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      print("🗑️ Invalid token cleared from storage");
    } catch (e) {
      print("Error clearing token: $e");
    }
  }

  // 🔄 Retry authentication
  void _retryAuthentication() {
    setState(() {
      _authError = null;
    });
    // You can add navigation to login page here if needed
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  // 📄 Open file
  Future<void> _viewFile(PlatformFile file) async {
    try {
      final result = await OpenFilex.open(file.path!);
      if (result.type == ResultType.done) {
        debugPrint("✅ Opened: ${file.name}");
      } else {
        Helpers.showSnackBar(context, "Cannot open this file type",
            bgColor: Colors.orange);
      }
    } catch (e) {
      Helpers.showSnackBar(context, "Error opening file: $e", bgColor: Colors.red);
    }
  }

  // 📏 Format file size
  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Reports"),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Authentication Error Banner
              if (_authError != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          const Text(
                            "Authentication Error",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_authError!),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _retryAuthentication,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Retry Authentication"),
                      ),
                    ],
                  ),
                ),

              // Order Info
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
                      children: const [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "Order Information",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("Order ID: ${widget.orderId}",
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Upload Area
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_upload_outlined,
                          size: 48, color: Colors.blueAccent),
                      const SizedBox(height: 8),
                      const Text("Tap below to select files to upload",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        onPressed: _pickFiles,
                        child: const Text("Select Files"),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Selected Files
              if (selectedFiles.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selected Files (${selectedFiles.length}/3):",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: selectedFiles.map((file) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.insert_drive_file,
                                color: Colors.blue),
                            title:
                            Text(file.name, overflow: TextOverflow.ellipsis),
                            subtitle: Text(_formatFileSize(file.size)),
                            trailing: IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.redAccent),
                              onPressed: () =>
                                  setState(() => selectedFiles.remove(file)),
                            ),
                            onTap: () => _viewFile(file),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

              // Visibility Dropdown
              Row(
                children: [
                  const Text("Visibility: ",
                      style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: visibility,
                    items: const [
                      DropdownMenuItem(
                          value: 'both', child: Text('Both Doctor & Patient')),
                      DropdownMenuItem(
                          value: 'doctor', child: Text('Only Doctor')),
                      DropdownMenuItem(
                          value: 'patient', child: Text('Only Patient')),
                    ],
                    onChanged: (val) {
                      setState(() => visibility = val!);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Upload Button
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: isUploading ? null : _uploadFiles,
                  icon: const Icon(Icons.cloud_upload),
                  label: Text(
                    isUploading ? "Uploading..." : "Submit Upload",
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isUploading ? Colors.grey : AppColors.primary,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

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
                  children: const [
                    Text("📋 Instructions:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 10),
                    Text("📌 Select up to 3 reports to upload."),
                    Text("📄 Supported formats: PDF, JPG, PNG."),
                    Text("💾 Max file size: 5MB per file."),
                    Text("🔒 Authentication required for doctor uploads."),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}