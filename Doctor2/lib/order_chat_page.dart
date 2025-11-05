// // // // import 'dart:async';
// // // // import 'dart:convert';
// // // // import 'dart:io';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:path_provider/path_provider.dart';
// // // // import 'package:permission_handler/permission_handler.dart';
// // // // import 'dart:math';
// // // // import 'order.dart';
// // // // import 'message.dart';
// // // // import 'helper.dart';
// // // // import 'package:flutter_downloader/flutter_downloader.dart';
// // // // import 'package:device_info_plus/device_info_plus.dart';
// // // // import 'package:open_filex/open_filex.dart';
// // // //
// // // // class OrderChatPage extends StatefulWidget {
// // // //   final Order order;
// // // //   final VoidCallback? onSessionEnded;
// // // //   final bool isReadOnly;
// // // //   final bool isDoctorView;
// // // //
// // // //   const OrderChatPage({
// // // //     super.key,
// // // //     required this.order,
// // // //     this.onSessionEnded,
// // // //     this.isReadOnly = false,
// // // //     this.isDoctorView = false,
// // // //   });
// // // //
// // // //   @override
// // // //   State<OrderChatPage> createState() => _OrderChatPageState();
// // // // }
// // // //
// // // // class _OrderChatPageState extends State<OrderChatPage> with SingleTickerProviderStateMixin {
// // // //   final TextEditingController _controller = TextEditingController();
// // // //   final ScrollController _scrollController = ScrollController();
// // // //   List<Message> messages = [];
// // // //   List<dynamic> files = [];
// // // //   bool _isLoadingFiles = false;
// // // //   late TabController _tabController;
// // // //   int _currentTabIndex = 0;
// // // //   bool _isDownloading = false;
// // // //   String _downloadingFileName = '';
// // // //
// // // //   // Download tracking variables
// // // //   final Set<String> _downloadingTaskIds = {};
// // // //   final Map<String, double> _downloadProgress = {};
// // // //
// // // //   bool get isReadOnly => widget.isReadOnly || widget.order.status?.toLowerCase() == 'completed';
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     messages = widget.order.messages ?? [];
// // // //     files = widget.order.files ?? [];
// // // //
// // // //     _tabController = TabController(length: 2, vsync: this);
// // // //     _tabController.addListener(_handleTabChange);
// // // //
// // // //     // Initialize downloader callbacks
// // // //     _initializeDownloader();
// // // //
// // // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // // //       _scrollToBottom();
// // // //       _loadOrderFiles();
// // // //     });
// // // //   }
// // // //
// // // //   // Initialize downloader callbacks
// // // //   void _initializeDownloader() {
// // // //     FlutterDownloader.registerCallback((id, status, progress) {
// // // //       if (_downloadingTaskIds.contains(id)) {
// // // //         print('Download task $id: $status ($progress%)');
// // // //
// // // //         setState(() {
// // // //           _downloadProgress[id] = progress.toDouble();
// // // //         });
// // // //
// // // //         if (status == DownloadTaskStatus.complete) {
// // // //           _downloadingTaskIds.remove(id);
// // // //           _downloadProgress.remove(id);
// // // //           if (mounted) {
// // // //             Helpers.showSnackBar(
// // // //               context,
// // // //               'Download completed!',
// // // //               bgColor: Colors.green,
// // // //             );
// // // //           }
// // // //         } else if (status == DownloadTaskStatus.failed) {
// // // //           _downloadingTaskIds.remove(id);
// // // //           _downloadProgress.remove(id);
// // // //           if (mounted) {
// // // //             Helpers.showSnackBar(
// // // //               context,
// // // //               'Download failed!',
// // // //               bgColor: Colors.red,
// // // //             );
// // // //           }
// // // //         } else if (status == DownloadTaskStatus.canceled) {
// // // //           _downloadingTaskIds.remove(id);
// // // //           _downloadProgress.remove(id);
// // // //         }
// // // //       }
// // // //     });
// // // //   }
// // // //
// // // //   void _handleTabChange() {
// // // //     if (_tabController.index != _currentTabIndex) {
// // // //       setState(() {
// // // //         _currentTabIndex = _tabController.index;
// // // //       });
// // // //
// // // //       if (_tabController.index == 1) {
// // // //         print('🔄 Switched to Files tab, refreshing files...');
// // // //         _loadOrderFiles();
// // // //       }
// // // //     }
// // // //   }
// // // //
// // // //   @override
// // // //   void dispose() {
// // // //     // Cancel all ongoing downloads when the page is disposed
// // // //     for (String taskId in _downloadingTaskIds) {
// // // //       FlutterDownloader.cancel(taskId: taskId);
// // // //     }
// // // //     _downloadingTaskIds.clear();
// // // //     _downloadProgress.clear();
// // // //
// // // //     _tabController.dispose();
// // // //     super.dispose();
// // // //   }
// // // //
// // // //   void _scrollToBottom() {
// // // //     if (_scrollController.hasClients) {
// // // //       _scrollController.animateTo(
// // // //         _scrollController.position.maxScrollExtent,
// // // //         duration: const Duration(milliseconds: 300),
// // // //         curve: Curves.easeOut,
// // // //       );
// // // //     }
// // // //   }
// // // //
// // // //   Future<void> _loadOrderFiles() async {
// // // //     if (_isLoadingFiles) return;
// // // //
// // // //     try {
// // // //       setState(() {
// // // //         _isLoadingFiles = true;
// // // //       });
// // // //
// // // //       if (widget.order.files != null && widget.order.files!.isNotEmpty) {
// // // //         print('🔄 Using files from order object (passed from HomePage)');
// // // //         setState(() {
// // // //           files = widget.order.files!;
// // // //         });
// // // //         print('✅ Loaded ${files.length} files from order object');
// // // //         return;
// // // //       }
// // // //
// // // //       print('ℹ No files in order object, trying API...');
// // // //
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       final token = prefs.getString('token');
// // // //       final doctorId = prefs.getString('doctorId');
// // // //       final doctorType = prefs.getString('doctorType');
// // // //
// // // //       if (token == null || token.isEmpty) {
// // // //         print('❌ No token available for loading files');
// // // //         return;
// // // //       }
// // // //
// // // //       if (doctorId == null || doctorType == null) {
// // // //         print('❌ Doctor information not available');
// // // //         return;
// // // //       }
// // // //
// // // //       print('🔐 Using token: ${token.substring(0, min(20, token.length))}...');
// // // //       print('👨‍⚕ Doctor: $doctorId, Type: $doctorType');
// // // //
// // // //       final String url = "${ApiConfig.baseUrl}/getOrders?doctorType=$doctorType&doctorId=$doctorId";
// // // //       print('📤 Loading files from: $url');
// // // //
// // // //       final response = await http.get(
// // // //         Uri.parse(url),
// // // //         headers: {
// // // //           'Content-Type': 'application/json',
// // // //           'Authorization': 'Bearer $token',
// // // //         },
// // // //       );
// // // //
// // // //       print('📥 Files API Response Status: ${response.statusCode}');
// // // //
// // // //       if (response.statusCode == 200) {
// // // //         final decoded = jsonDecode(response.body);
// // // //         print('📦 Files API Response Body: ${jsonEncode(decoded)}');
// // // //
// // // //         if (decoded['success'] == true) {
// // // //           List<dynamic> allOrdersData = [];
// // // //
// // // //           if (decoded['data'] is Map && decoded['data']['orders'] != null) {
// // // //             allOrdersData = decoded['data']['orders'];
// // // //           } else if (decoded['data'] is List) {
// // // //             allOrdersData = decoded['data'];
// // // //           } else if (decoded['orders'] is List) {
// // // //             allOrdersData = decoded['orders'];
// // // //           }
// // // //
// // // //           print('🔍 Searching for order: ${widget.order.orderId} in ${allOrdersData.length} orders');
// // // //
// // // //           Map<String, dynamic>? currentOrderData;
// // // //           for (var order in allOrdersData) {
// // // //             if (order is Map<String, dynamic>) {
// // // //               final orderId = order['orderId']?.toString() ?? order['_id']?.toString();
// // // //               if (orderId == widget.order.orderId) {
// // // //                 currentOrderData = order;
// // // //                 break;
// // // //               }
// // // //             }
// // // //           }
// // // //
// // // //           if (currentOrderData != null) {
// // // //             print('✅ Found current order data');
// // // //
// // // //             List<dynamic> allFiles = _extractFilesFromOrderData(currentOrderData);
// // // //
// // // //             print('✅ Extracted ${allFiles.length} files for order ${widget.order.orderId}');
// // // //
// // // //             for (int i = 0; i < allFiles.length; i++) {
// // // //               final file = allFiles[i];
// // // //               if (file is Map<String, dynamic>) {
// // // //                 print('📄 File $i: ${file['fileName']}');
// // // //                 print('   - fileType: ${file['fileType']}');
// // // //                 print('   - uploadedBy: ${file['uploadedBy']}');
// // // //                 print('   - filePath: ${file['filePath']}');
// // // //                 print('   - downloadUrl: ${file['downloadUrl']}');
// // // //               }
// // // //             }
// // // //
// // // //             setState(() {
// // // //               files = allFiles;
// // // //             });
// // // //
// // // //             print('✅ UI Updated with ${files.length} files');
// // // //           } else {
// // // //             print('❌ Order ${widget.order.orderId} not found in response');
// // // //           }
// // // //         } else {
// // // //           print('❌ API returned success: false');
// // // //           print('❌ Message: ${decoded['message']}');
// // // //         }
// // // //       } else {
// // // //         print('❌ Failed to load files: ${response.statusCode}');
// // // //         print('❌ Response body: ${response.body}');
// // // //       }
// // // //     } catch (e, stackTrace) {
// // // //       print('❌ Error loading files: $e');
// // // //       print('❌ Stack trace: $stackTrace');
// // // //     } finally {
// // // //       setState(() {
// // // //         _isLoadingFiles = false;
// // // //       });
// // // //     }
// // // //   }
// // // //
// // // //   List<dynamic> _extractFilesFromOrderData(Map<String, dynamic> orderData) {
// // // //     List<dynamic> allFiles = [];
// // // //
// // // //     try {
// // // //       print('🔍 Extracting files from order data structure...');
// // // //
// // // //       // Method 1: Extract from reports.files.all (main location)
// // // //       if (orderData['reports'] != null && orderData['reports'] is Map<String, dynamic>) {
// // // //         final reports = orderData['reports'] as Map<String, dynamic>;
// // // //
// // // //         if (reports['files'] != null && reports['files'] is Map<String, dynamic>) {
// // // //           final filesMap = reports['files'] as Map<String, dynamic>;
// // // //
// // // //           // Get files from 'all' array
// // // //           if (filesMap['all'] != null && filesMap['all'] is List) {
// // // //             final allFilesList = filesMap['all'] as List<dynamic>;
// // // //             print('✅ Found ${allFilesList.length} files in reports.files.all');
// // // //
// // // //             for (var file in allFilesList) {
// // // //               if (file is Map<String, dynamic>) {
// // // //                 // Ensure file has all required fields and normalize filePath
// // // //                 final normalizedFile = _normalizeFileData(file);
// // // //                 if (normalizedFile != null) {
// // // //                   allFiles.add(normalizedFile);
// // // //                 }
// // // //               }
// // // //             }
// // // //           }
// // // //         }
// // // //       }
// // // //
// // // //       // Method 2: Extract from messages with attachedFiles
// // // //       if (orderData['messages'] != null && orderData['messages'] is List) {
// // // //         final messages = orderData['messages'] as List<dynamic>;
// // // //         for (var message in messages) {
// // // //           if (message is Map<String, dynamic> &&
// // // //               message['attachedFiles'] != null &&
// // // //               message['attachedFiles'] is List) {
// // // //             final attachedFiles = message['attachedFiles'] as List<dynamic>;
// // // //             for (var file in attachedFiles) {
// // // //               if (file is Map<String, dynamic>) {
// // // //                 // Create a file object from message attachment
// // // //                 final fileFromMessage = {
// // // //                   'fileName': file['fileName'],
// // // //                   'filePath': file['filePath'],
// // // //                   'fileType': _getFileTypeFromFileName(file['fileName']),
// // // //                   'fileSize': 0, // Size might not be available in messages
// // // //                   'uploadedBy': 'patient', // Assuming from message context
// // // //                   'category': file['category'] ?? 'Uncategorized',
// // // //                   'source': 'messages',
// // // //                   'messageText': message['text'],
// // // //                   'messageCreatedAt': message['createdAt'],
// // // //                 };
// // // //                 final normalizedFile = _normalizeFileData(fileFromMessage);
// // // //                 if (normalizedFile != null) {
// // // //                   allFiles.add(normalizedFile);
// // // //                 }
// // // //               }
// // // //             }
// // // //           }
// // // //         }
// // // //       }
// // // //
// // // //       print('✅ Total normalized files extracted: ${allFiles.length}');
// // // //
// // // //       // Log all extracted files for debugging
// // // //       for (int i = 0; i < allFiles.length; i++) {
// // // //         final file = allFiles[i];
// // // //         if (file is Map<String, dynamic>) {
// // // //           print('📄 File $i: ${file['fileName']}');
// // // //           print('   - filePath: ${file['filePath']}');
// // // //           print('   - downloadUrl: ${file['downloadUrl']}');
// // // //           print('   - fileSize: ${file['fileSize']}');
// // // //           print('   - uploadedBy: ${file['uploadedBy']}');
// // // //         }
// // // //       }
// // // //
// // // //       return allFiles;
// // // //
// // // //     } catch (e) {
// // // //       print('❌ Error extracting files: $e');
// // // //       return allFiles;
// // // //     }
// // // //   }
// // // //
// // // //   // Map<String, dynamic>? _normalizeFileData(Map<String, dynamic> file) {
// // // //   //   try {
// // // //   //     final fileName = file['fileName']?.toString();
// // // //   //     if (fileName == null || fileName.isEmpty) {
// // // //   //       print('⚠ Skipping file with no fileName: $file');
// // // //   //       return null;
// // // //   //     }
// // // //   //
// // // //   //     String filePath = file['filePath']?.toString() ?? '';
// // // //   //
// // // //   //     // Normalize file path - replace backslashes with forward slashes
// // // //   //     if (filePath.isNotEmpty) {
// // // //   //       filePath = filePath.replaceAll('\\', '/');
// // // //   //     }
// // // //   //
// // // //   //     // Create download URL
// // // //   //     String downloadUrl;
// // // //   //     if (filePath.startsWith('http')) {
// // // //   //       downloadUrl = filePath;
// // // //   //     } else if (filePath.isNotEmpty) {
// // // //   //       downloadUrl = "${ApiConfig.baseUrl}/$filePath";
// // // //   //     } else {
// // // //   //       print('⚠ No filePath available for: $fileName');
// // // //   //       return null;
// // // //   //     }
// // // //   //
// // // //   //     // Determine file type
// // // //   //     final fileType = file['fileType']?.toString() ??
// // // //   //         _getFileTypeFromFileName(fileName) ??
// // // //   //         'application/octet-stream';
// // // //   //
// // // //   //     return {
// // // //   //       'fileName': fileName,
// // // //   //       'filePath': filePath,
// // // //   //       'downloadUrl': downloadUrl,
// // // //   //       'fileType': fileType,
// // // //   //       'fileSize': file['fileSize'] is int ? file['fileSize'] :
// // // //   //       file['fileSize'] is String ? int.tryParse(file['fileSize']) ?? 0 : 0,
// // // //   //       'uploadedBy': file['uploadedBy']?.toString() ?? 'unknown',
// // // //   //       'category': file['category']?.toString() ?? 'Uncategorized',
// // // //   //       'source': file['source']?.toString() ?? 'reports',
// // // //   //       'uploadDate': file['uploadDate']?.toString() ?? DateTime.now().toIso8601String(),
// // // //   //       'originalData': file, // Keep original data for reference
// // // //   //     };
// // // //   //   } catch (e) {
// // // //   //     print('❌ Error normalizing file data: $e');
// // // //   //     return null;
// // // //   //   }
// // // //   // }
// // // //
// // // //
// // // //
// // // //   String getFileTypeFromFileName(String fileName) {
// // // //     final extension = fileName.toLowerCase().split('.').last;
// // // //     switch (extension) {
// // // //       case 'pdf':
// // // //         return 'application/pdf';
// // // //       case 'jpg':
// // // //       case 'jpeg':
// // // //         return 'image/jpeg';
// // // //       case 'png':
// // // //         return 'image/png';
// // // //       case 'doc':
// // // //       case 'docx':
// // // //         return 'application/msword';
// // // //       case 'xls':
// // // //       case 'xlsx':
// // // //         return 'application/vnd.ms-excel';
// // // //       default:
// // // //         return 'application/octet-stream';
// // // //     }
// // // //   }
// // // //
// // // //   // In your OrderChatPage.dart file
// // // //
// // // //   Map<String, dynamic>? _normalizeFileData(Map<String, dynamic> file) {
// // // //     try {
// // // //       final fileName = file['fileName']?.toString();
// // // //       if (fileName == null || fileName.isEmpty) {
// // // //         print('⚠ Skipping file with no fileName: $file');
// // // //         return null;
// // // //       }
// // // //
// // // //       String filePath = file['filePath']?.toString() ?? '';
// // // //
// // // //       // Normalize file path - replace backslashes with forward slashes
// // // //       if (filePath.isNotEmpty) {
// // // //         filePath = filePath.replaceAll('\\', '/');
// // // //         print('📝 Normalized file path: $filePath');
// // // //       }
// // // //
// // // //       // Create download URL using the dedicated base FILE URL
// // // //       String downloadUrl;
// // // //       if (filePath.startsWith('http')) {
// // // //         // If the path is already a full URL, use it as is
// // // //         downloadUrl = filePath;
// // // //       } else if (filePath.isNotEmpty) {
// // // //         // Construct the URL from the base FILE URL and the relative path
// // // //         // Ensure there's no double slash
// // // //         final String base = ApiConfig.baseFileUrl.endsWith('/')
// // // //             ? ApiConfig.baseFileUrl.substring(0, ApiConfig.baseFileUrl.length - 1)
// // // //             : ApiConfig.baseFileUrl;
// // // //         final String path = filePath.startsWith('/') ? filePath : '/$filePath';
// // // //
// // // //         downloadUrl = '$base$path';
// // // //         print('🔗 CORRECTLY Constructed download URL: $downloadUrl');
// // // //       } else {
// // // //         print('⚠ No filePath available for: $fileName');
// // // //         return null;
// // // //       }
// // // //
// // // //       final fileType = file['fileType']?.toString() ?? getFileTypeFromFileName(fileName) ?? 'application/octet-stream';
// // // //
// // // //       return {
// // // //         'fileName': fileName,
// // // //         'filePath': filePath,
// // // //         'downloadUrl': downloadUrl,
// // // //         'fileType': fileType,
// // // //         'fileSize': (file['fileSize'] is int)
// // // //             ? file['fileSize']
// // // //             : (file['fileSize'] is String)
// // // //             ? int.tryParse(file['fileSize']) ?? 0
// // // //             : 0,
// // // //         'uploadedBy': file['uploadedBy']?.toString() ?? 'unknown',
// // // //         'category': file['category']?.toString() ?? 'Uncategorized',
// // // //         'source': file['source']?.toString() ?? 'reports',
// // // //         'uploadDate': file['uploadDate']?.toString() ?? DateTime.now().toIso8601String(),
// // // //         'originalData': file,
// // // //       };
// // // //     } catch (e) {
// // // //       print('❌ Error normalizing file data: $e');
// // // //       return null;
// // // //     }
// // // //   }
// // // //
// // // //   String _getFileTypeFromFileName(String fileName) {
// // // //     final extension = fileName.toLowerCase().split('.').last;
// // // //     switch (extension) {
// // // //       case 'pdf':
// // // //         return 'application/pdf';
// // // //       case 'jpg':
// // // //       case 'jpeg':
// // // //         return 'image/jpeg';
// // // //       case 'png':
// // // //         return 'image/png';
// // // //       case 'doc':
// // // //       case 'docx':
// // // //         return 'application/msword';
// // // //       case 'xls':
// // // //       case 'xlsx':
// // // //         return 'application/vnd.ms-excel';
// // // //       default:
// // // //         return 'application/octet-stream';
// // // //     }
// // // //   }
// // // //
// // // //   // Future<void> _downloadFile(Map<String, dynamic> file) async {
// // // //   //   final fileName = file['fileName']?.toString() ?? 'Unknown File';
// // // //   //   final downloadUrl = file['downloadUrl']?.toString();
// // // //   //   final filePath = file['filePath']?.toString();
// // // //   //
// // // //   //   print('📥 Starting download for: $fileName');
// // // //   //   print('🔗 Download URL: $downloadUrl');
// // // //   //   print('📁 File path: $filePath');
// // // //   //
// // // //   //   if (downloadUrl == null || downloadUrl.isEmpty) {
// // // //   //     print('❌ No download URL available');
// // // //   //     Helpers.showSnackBar(context, 'Download URL not available for $fileName', bgColor: Colors.red);
// // // //   //     return;
// // // //   //   }
// // // //   //
// // // //   //   try {
// // // //   //     setState(() {
// // // //   //       _isDownloading = true;
// // // //   //       _downloadingFileName = fileName;
// // // //   //     });
// // // //   //
// // // //   //     Helpers.showSnackBar(context, 'Starting download for $fileName...', bgColor: Colors.blue);
// // // //   //
// // // //   //     // Use enhanced fallback download for better reliability
// // // //   //     await _enhancedFallbackDownload(downloadUrl, fileName);
// // // //   //
// // // //   //   } catch (e) {
// // // //   //     print('❌ Download error: $e');
// // // //   //     Helpers.showSnackBar(
// // // //   //       context,
// // // //   //       'Download failed: ${e.toString()}',
// // // //   //       bgColor: Colors.red,
// // // //   //     );
// // // //   //   } finally {
// // // //   //     setState(() {
// // // //   //       _isDownloading = false;
// // // //   //       _downloadingFileName = '';
// // // //   //     });
// // // //   //   }
// // // //   // }
// // // //   // In your OrderChatPage.dart file
// // // //
// // // //   Future<void> _downloadFile(Map<String, dynamic> file) async {
// // // //     final fileName = file['fileName']?.toString() ?? 'Unknown File';
// // // //     String? downloadUrl = file['downloadUrl']?.toString();
// // // //     final filePath = file['filePath']?.toString();
// // // //
// // // //     print('📥 Starting download for: $fileName');
// // // //     print('🔗 Initial Download URL: $downloadUrl');
// // // //     print('📁 File path: $filePath');
// // // //
// // // //     // Fallback: If downloadUrl is still null but we have a filePath, try to construct it one last time
// // // //     if ((downloadUrl == null || downloadUrl.isEmpty) && filePath != null && filePath.isNotEmpty) {
// // // //       print('🔄 Download URL is null, attempting to construct from file path as a last resort');
// // // //
// // // //       String normalizedPath = filePath.replaceAll('\\', '/');
// // // //
// // // //       // USE THE CORRECT BASE FILE URL HERE
// // // //       final String base = ApiConfig.baseFileUrl.endsWith('/')
// // // //           ? ApiConfig.baseFileUrl.substring(0, ApiConfig.baseFileUrl.length - 1)
// // // //           : ApiConfig.baseFileUrl;
// // // //       final String path = normalizedPath.startsWith('/') ? normalizedPath : '/$normalizedPath';
// // // //
// // // //       downloadUrl = '$base$path';
// // // //       print('🔗 CORRECT Fallback constructed download URL: $downloadUrl');
// // // //     }
// // // //
// // // //     if (downloadUrl == null || downloadUrl.isEmpty) {
// // // //       print('❌ No download URL could be determined for $fileName');
// // // //       Helpers.showSnackBar(context, 'Download URL not available for $fileName', bgColor: Colors.red);
// // // //       return;
// // // //     }
// // // //
// // // //     try {
// // // //       setState(() {
// // // //         _isDownloading = true;
// // // //         _downloadingFileName = fileName;
// // // //       });
// // // //
// // // //       Helpers.showSnackBar(context, 'Starting download for $fileName...', bgColor: Colors.blue);
// // // //
// // // //       await _enhancedFallbackDownload(downloadUrl, fileName);
// // // //
// // // //     } catch (e) {
// // // //       print('❌ Download error: $e');
// // // //       Helpers.showSnackBar(
// // // //         context,
// // // //         'Download failed: ${e.toString()}',
// // // //         bgColor: Colors.red,
// // // //       );
// // // //     } finally {
// // // //       setState(() {
// // // //         _isDownloading = false;
// // // //         _downloadingFileName = '';
// // // //       });
// // // //     }
// // // //   }
// // // //   Future<void> _enhancedFallbackDownload(String url, String fileName) async {
// // // //     try {
// // // //       print('🔄 Using enhanced fallback download for: $fileName');
// // // //       print('🔗 URL: $url');
// // // //
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       final token = prefs.getString('token');
// // // //
// // // //       // Create HTTP client
// // // //       final client = http.Client();
// // // //
// // // //       // Make the request
// // // //       final response = await client.get(
// // // //         Uri.parse(url),
// // // //         headers: {
// // // //           if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
// // // //           'Accept': '/',
// // // //         },
// // // //       );
// // // //
// // // //       print('📥 Response status: ${response.statusCode}');
// // // //       print('📥 Content length: ${response.contentLength}');
// // // //
// // // //       if (response.statusCode == 200) {
// // // //         // Get a reliable directory
// // // //         final directory = await _getReliableDownloadDirectory();
// // // //         final String savePath = '${directory.path}/MediConnect';
// // // //         final Directory saveDir = Directory(savePath);
// // // //
// // // //         if (!await saveDir.exists()) {
// // // //           await saveDir.create(recursive: true);
// // // //           print('📁 Created directory: $savePath');
// // // //         }
// // // //
// // // //         // Clean filename
// // // //         final cleanFileName = _cleanFileName(fileName);
// // // //         final File file = File('$savePath/$cleanFileName');
// // // //
// // // //         // Write file
// // // //         await file.writeAsBytes(response.bodyBytes);
// // // //
// // // //         final fileSize = await file.length();
// // // //         print('✅ Download successful: ${file.path}');
// // // //         print('📊 File size: $fileSize bytes');
// // // //
// // // //         // Verify file exists and has content
// // // //         if (await file.exists() && fileSize > 0) {
// // // //           if (mounted) {
// // // //             Helpers.showSnackBar(
// // // //               context,
// // // //               'Download completed: $fileName',
// // // //               bgColor: Colors.green,
// // // //             );
// // // //           }
// // // //
// // // //           // Try to open the file
// // // //           try {
// // // //             final openResult = await OpenFilex.open(file.path);
// // // //             print('📂 Open file result: ${openResult.type}');
// // // //             print('📂 Open file message: ${openResult.message}');
// // // //
// // // //             if (openResult.type != ResultType.done) {
// // // //               if (mounted) {
// // // //                 Helpers.showSnackBar(
// // // //                   context,
// // // //                   'File downloaded to MediConnect folder',
// // // //                   bgColor: Colors.blue,
// // // //                 );
// // // //               }
// // // //             }
// // // //           } catch (e) {
// // // //             print('⚠ Cannot open file automatically: $e');
// // // //             if (mounted) {
// // // //               Helpers.showSnackBar(
// // // //                 context,
// // // //                 'File downloaded to MediConnect folder',
// // // //                 bgColor: Colors.green,
// // // //               );
// // // //             }
// // // //           }
// // // //
// // // //           // Show file location
// // // //           print('📍 File saved at: ${file.path}');
// // // //
// // // //         } else {
// // // //           throw Exception('File was written but is empty or cannot be accessed');
// // // //         }
// // // //       } else {
// // // //         throw Exception('HTTP ${response.statusCode} - ${response.reasonPhrase}');
// // // //       }
// // // //
// // // //       client.close();
// // // //     } catch (e) {
// // // //       print('❌ Enhanced fallback download failed: $e');
// // // //       rethrow;
// // // //     }
// // // //   }
// // // //
// // // //   Future<Directory> _getReliableDownloadDirectory() async {
// // // //     try {
// // // //       // For Android 10+, use scoped storage - app-specific directory
// // // //       if (Platform.isAndroid) {
// // // //         // Try external storage first (visible in file managers)
// // // //         final externalDir = await getExternalStorageDirectory();
// // // //         if (externalDir != null) {
// // // //           return externalDir;
// // // //         }
// // // //       }
// // // //
// // // //       // Fallback to application documents directory
// // // //       return await getApplicationDocumentsDirectory();
// // // //     } catch (e) {
// // // //       print('⚠ Error getting directory: $e');
// // // //       return await getApplicationDocumentsDirectory();
// // // //     }
// // // //   }
// // // //
// // // //   // String _cleanFileName(String fileName) {
// // // //   //   // Remove invalid characters for file names and replace spaces with underscores
// // // //   //   String cleaned = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
// // // //   //   // Replace multiple spaces with single underscore
// // // //   //   cleaned = cleaned.replaceAll(RegExp(r'\s+'), '_');
// // // //   //   // Remove leading/trailing spaces and underscores
// // // //   //   cleaned = cleaned.trim().replaceAll(RegExp(r'^+|$'), '');
// // // //   //
// // // //   //   // If filename is empty after cleaning, use a default name
// // // //   //   if (cleaned.isEmpty) {
// // // //   //     cleaned = 'downloaded_file_${DateTime.now().millisecondsSinceEpoch}';
// // // //   //   }
// // // //   //
// // // //   //   return cleaned;
// // // //   // }
// // // //
// // // //   String _cleanFileName(String fileName) {
// // // //     // Remove invalid characters for file names
// // // //     // We will explicitly replace each character to avoid regex issues
// // // //     String cleaned = fileName
// // // //         .replaceAll('<', '_')
// // // //         .replaceAll('>', '_')
// // // //         .replaceAll(':', '_')
// // // //         .replaceAll('"', '_')
// // // //         .replaceAll('/', '_')
// // // //         .replaceAll('\\', '_')
// // // //         .replaceAll('|', '_')
// // // //         .replaceAll('?', '_')
// // // //         .replaceAll('*', '_');
// // // //
// // // //     // Replace multiple spaces with single underscore
// // // //     cleaned = cleaned.replaceAll(RegExp(r'\s+'), '_');
// // // //
// // // //     // Remove leading/trailing spaces and underscores
// // // //     cleaned = cleaned.trim().replaceAll(RegExp(r'^_+|_+$'), '');
// // // //
// // // //     // If filename is empty after cleaning, use a default name
// // // //     if (cleaned.isEmpty) {
// // // //       cleaned = 'downloaded_file_${DateTime.now().millisecondsSinceEpoch}';
// // // //     }
// // // //
// // // //     return cleaned;
// // // //   }
// // // //   // Send message
// // // //   Future<void> sendMessage(String text) async {
// // // //     if (text.trim().isEmpty) return;
// // // //     if (isReadOnly) {
// // // //       Helpers.showSnackBar(context, 'Cannot send messages in completed order', bgColor: Colors.orange);
// // // //       return;
// // // //     }
// // // //
// // // //     try {
// // // //       final String url = "${ApiConfig.baseUrl}/sendMessageDoctor/${widget.order.orderId}";
// // // //       final Map<String, dynamic> requestBody = {
// // // //         'text': text,
// // // //         'isBot': false,
// // // //         'userName': 'Doctor',
// // // //         'userId': 'doctor',
// // // //         'patientUserId': widget.order.userId,
// // // //         'patientUserName': widget.order.userName,
// // // //       };
// // // //
// // // //       print('📤 Sending message to: $url');
// // // //       print('📦 Request body: $requestBody');
// // // //
// // // //       final response = await http.post(
// // // //         Uri.parse(url),
// // // //         headers: {'Content-Type': 'application/json'},
// // // //         body: jsonEncode(requestBody),
// // // //       );
// // // //
// // // //       print('📥 Response status: ${response.statusCode}');
// // // //       print('📥 Response body: ${response.body}');
// // // //
// // // //       if (response.statusCode == 200) {
// // // //         final data = jsonDecode(response.body)['data'];
// // // //         setState(() {
// // // //           messages.add(Message.fromMap(data));
// // // //         });
// // // //         _controller.clear();
// // // //         _scrollToBottom();
// // // //       } else {
// // // //         final errorBody = jsonDecode(response.body);
// // // //         final errorMessage = errorBody['message'] ?? 'Failed to send message';
// // // //         Helpers.showSnackBar(context, 'Error: $errorMessage', bgColor: Colors.red);
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ sendMessage error: $e');
// // // //       Helpers.showSnackBar(context, 'Network error: $e', bgColor: Colors.red);
// // // //     }
// // // //   }
// // // //
// // // //   // End Session
// // // //   Future<void> _endSession() async {
// // // //     if (isReadOnly) {
// // // //       Helpers.showSnackBar(context, 'This order is already completed', bgColor: Colors.orange);
// // // //       return;
// // // //     }
// // // //
// // // //     bool confirmEnd = await showDialog(
// // // //       context: context,
// // // //       builder: (BuildContext context) {
// // // //         return AlertDialog(
// // // //           title: const Text("End Session"),
// // // //           content: const Text("Are you sure you want to end this session? This will complete the order and reset the chat for the patient."),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () => Navigator.of(context).pop(false),
// // // //               child: const Text("Cancel"),
// // // //             ),
// // // //             ElevatedButton(
// // // //               onPressed: () => Navigator.of(context).pop(true),
// // // //               style: ElevatedButton.styleFrom(
// // // //                 backgroundColor: Colors.green,
// // // //               ),
// // // //               child: const Text("End Session", style: TextStyle(color: Colors.white)),
// // // //             ),
// // // //           ],
// // // //         );
// // // //       },
// // // //     );
// // // //
// // // //     if (confirmEnd != true) return;
// // // //
// // // //     try {
// // // //       final String url = "${ApiConfig.baseUrl}/completeOrder/${widget.order.orderId}";
// // // //
// // // //       print('🚀 Ending session for order: ${widget.order.orderId}');
// // // //
// // // //       final requestBody = {
// // // //         'status': 'completed',
// // // //         'completedAt': DateTime.now().toIso8601String(),
// // // //         'completedBy': 'Doctor',
// // // //         'resetChat': true,
// // // //       };
// // // //
// // // //       final response = await http.put(
// // // //         Uri.parse(url),
// // // //         headers: {'Content-Type': 'application/json'},
// // // //         body: jsonEncode(requestBody),
// // // //       );
// // // //
// // // //       if (response.statusCode == 200) {
// // // //         final responseData = jsonDecode(response.body);
// // // //
// // // //         if (responseData['success'] == true) {
// // // //           Helpers.showSnackBar(
// // // //             context,
// // // //             'Session ended successfully! Order completed and chat reset.',
// // // //             bgColor: Colors.green,
// // // //           );
// // // //
// // // //           if (widget.onSessionEnded != null) {
// // // //             widget.onSessionEnded!();
// // // //           }
// // // //
// // // //           Navigator.of(context).pop(true);
// // // //         } else {
// // // //           throw Exception(responseData['message'] ?? 'Failed to complete order');
// // // //         }
// // // //       } else {
// // // //         throw Exception('HTTP ${response.statusCode}: ${response.body}');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ End session error: $e');
// // // //       Helpers.showSnackBar(
// // // //         context,
// // // //         'Failed to end session: ${e.toString()}',
// // // //         bgColor: Colors.red,
// // // //       );
// // // //     }
// // // //   }
// // // //
// // // //   // Build file item widget
// // // //   Widget _buildFileItem(Map<String, dynamic> file) {
// // // //     final fileName = file['fileName']?.toString() ?? 'Unknown File';
// // // //     final fileSize = file['fileSize'] ?? 0;
// // // //     final fileType = file['fileType']?.toString() ?? 'file';
// // // //     final uploadedBy = file['uploadedBy']?.toString() ?? 'Unknown';
// // // //     final category = file['category']?.toString() ?? 'Uncategorized';
// // // //     final uploadDate = file['uploadDate'] != null
// // // //         ? DateTime.tryParse(file['uploadDate'])?.toLocal() ?? DateTime.now()
// // // //         : DateTime.now();
// // // //
// // // //     // Check if this file is currently downloading
// // // //     bool isDownloadingThisFile = _isDownloading && _downloadingFileName == fileName;
// // // //
// // // //     return Container(
// // // //       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// // // //       padding: const EdgeInsets.all(12),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         border: Border.all(color: Colors.grey.shade300),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Colors.grey.withOpacity(0.1),
// // // //             blurRadius: 4,
// // // //             offset: const Offset(0, 2),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: Row(
// // // //         children: [
// // // //           Container(
// // // //             padding: const EdgeInsets.all(8),
// // // //             decoration: BoxDecoration(
// // // //               color: AppColors.primary.withOpacity(0.1),
// // // //               borderRadius: BorderRadius.circular(8),
// // // //             ),
// // // //             child: Icon(
// // // //               _getFileIcon(fileType),
// // // //               color: AppColors.primary,
// // // //               size: 24,
// // // //             ),
// // // //           ),
// // // //           const SizedBox(width: 12),
// // // //           Expanded(
// // // //             child: Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 Text(
// // // //                   fileName,
// // // //                   style: const TextStyle(
// // // //                     fontWeight: FontWeight.bold,
// // // //                     fontSize: 14,
// // // //                   ),
// // // //                   maxLines: 2,
// // // //                   overflow: TextOverflow.ellipsis,
// // // //                 ),
// // // //                 const SizedBox(height: 4),
// // // //                 Text(
// // // //                   'Category: $category',
// // // //                   style: TextStyle(
// // // //                     color: Colors.grey.shade600,
// // // //                     fontSize: 12,
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 4),
// // // //                 Row(
// // // //                   children: [
// // // //                     Text(
// // // //                       _formatFileSize(fileSize is int ? fileSize : 0),
// // // //                       style: TextStyle(
// // // //                         color: Colors.grey.shade600,
// // // //                         fontSize: 12,
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(width: 8),
// // // //                     Container(
// // // //                       width: 4,
// // // //                       height: 4,
// // // //                       decoration: BoxDecoration(
// // // //                         color: Colors.grey.shade400,
// // // //                         shape: BoxShape.circle,
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(width: 8),
// // // //                     Text(
// // // //                       fileType.split('/').last.toUpperCase(),
// // // //                       style: TextStyle(
// // // //                         color: Colors.grey.shade600,
// // // //                         fontSize: 12,
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //                 const SizedBox(height: 4),
// // // //                 Row(
// // // //                   children: [
// // // //                     Icon(
// // // //                       uploadedBy == 'patient' ? Icons.person : Icons.medical_services,
// // // //                       size: 12,
// // // //                       color: Colors.grey.shade600,
// // // //                     ),
// // // //                     const SizedBox(width: 4),
// // // //                     Text(
// // // //                       'Uploaded by ${uploadedBy == 'patient' ? 'Patient' : 'Doctor'}',
// // // //                       style: TextStyle(
// // // //                         color: Colors.grey.shade600,
// // // //                         fontSize: 11,
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(width: 8),
// // // //                     Text(
// // // //                       '${uploadDate.day}/${uploadDate.month}/${uploadDate.year}',
// // // //                       style: TextStyle(
// // // //                         color: Colors.grey.shade600,
// // // //                         fontSize: 11,
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //                 if (isDownloadingThisFile) ...[
// // // //                   const SizedBox(height: 8),
// // // //                   LinearProgressIndicator(
// // // //                     backgroundColor: Colors.grey.shade300,
// // // //                     valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
// // // //                   ),
// // // //                   const SizedBox(height: 4),
// // // //                   Text(
// // // //                     'Downloading...',
// // // //                     style: const TextStyle(
// // // //                       color: Colors.blue,
// // // //                       fontSize: 10,
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ],
// // // //             ),
// // // //           ),
// // // //           if (isDownloadingThisFile)
// // // //             const Padding(
// // // //               padding: EdgeInsets.all(8.0),
// // // //               child: SizedBox(
// // // //                 width: 24,
// // // //                 height: 24,
// // // //                 child: CircularProgressIndicator(strokeWidth: 2),
// // // //               ),
// // // //             )
// // // //           else
// // // //             IconButton(
// // // //               icon: Icon(
// // // //                 Icons.download,
// // // //                 color: AppColors.primary,
// // // //               ),
// // // //               onPressed: () => _downloadFile(file),
// // // //             ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   // Helper methods for file display
// // // //   IconData _getFileIcon(String fileType) {
// // // //     if (fileType.toLowerCase().contains('image')) return Icons.image;
// // // //     if (fileType.toLowerCase().contains('pdf')) return Icons.picture_as_pdf;
// // // //     if (fileType.toLowerCase().contains('word') || fileType.toLowerCase().contains('document'))
// // // //       return Icons.description;
// // // //     return Icons.insert_drive_file;
// // // //   }
// // // //
// // // //   String _formatFileSize(int bytes) {
// // // //     if (bytes < 1024) return '$bytes B';
// // // //     if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
// // // //     return '${(bytes / 1048576).toStringAsFixed(1)} MB';
// // // //   }
// // // //
// // // //   // Build message bubble
// // // //   Widget _buildMessageBubble(Message msg) {
// // // //     final isDoctor = msg.userName == "Doctor";
// // // //     final alignment = isDoctor ? Alignment.centerRight : Alignment.centerLeft;
// // // //     final bgColor = isDoctor
// // // //         ? AppColors.textLight.withOpacity(0.9)
// // // //         : AppColors.primary.withOpacity(0.9);
// // // //     final textColor = isDoctor ? Colors.black87 : Colors.white;
// // // //
// // // //     return Container(
// // // //       alignment: alignment,
// // // //       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// // // //       child: Container(
// // // //         padding: const EdgeInsets.all(12),
// // // //         constraints: const BoxConstraints(maxWidth: 280),
// // // //         decoration: BoxDecoration(
// // // //           color: bgColor,
// // // //           borderRadius: BorderRadius.circular(12),
// // // //         ),
// // // //         child: Column(
// // // //           crossAxisAlignment: isDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// // // //           children: [
// // // //             Text(
// // // //               msg.text,
// // // //               style: TextStyle(color: textColor, fontSize: 15),
// // // //             ),
// // // //             const SizedBox(height: 4),
// // // //             Text(
// // // //               "${msg.createdAt?.hour.toString().padLeft(2, '0')}:${msg.createdAt?.minute.toString().padLeft(2, '0')}",
// // // //               style: TextStyle(
// // // //                 color: textColor.withOpacity(0.7),
// // // //                 fontSize: 10,
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Future<void> _refreshFiles() async {
// // // //     print('🔄 Manually refreshing files...');
// // // //     await _loadOrderFiles();
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: Colors.grey[100],
// // // //       appBar: AppBar(
// // // //         backgroundColor: isReadOnly ? Colors.grey : AppColors.primary,
// // // //         iconTheme: const IconThemeData(color: Colors.white),
// // // //         toolbarHeight: 75,
// // // //         title: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             Text(
// // // //               widget.order.userName,
// // // //               style: const TextStyle(
// // // //                 color: Colors.white,
// // // //                 fontSize: 20,
// // // //                 fontWeight: FontWeight.bold,
// // // //               ),
// // // //             ),
// // // //             if (isReadOnly)
// // // //               const Text(
// // // //                 "COMPLETED - VIEW ONLY",
// // // //                 style: TextStyle(
// // // //                   color: Colors.white,
// // // //                   fontSize: 10,
// // // //                   fontWeight: FontWeight.bold,
// // // //                 ),
// // // //               ),
// // // //           ],
// // // //         ),
// // // //
// // // //         actions: [
// // // //           if (!isReadOnly)
// // // //             Padding(
// // // //               padding: const EdgeInsets.only(right: 11.0),
// // // //               child: ElevatedButton.icon(
// // // //                 onPressed: _endSession,
// // // //                 style: ElevatedButton.styleFrom(
// // // //                   backgroundColor: Colors.green,
// // // //                   foregroundColor: Colors.white,
// // // //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // // //                   shape: RoundedRectangleBorder(
// // // //                     borderRadius: BorderRadius.circular(20),
// // // //                   ),
// // // //                 ),
// // // //                 icon: const Icon(Icons.done_all, size: 16),
// // // //                 label: const Text(
// // // //                   "End Session",
// // // //                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //         ],
// // // //         bottom: PreferredSize(
// // // //           preferredSize: const Size.fromHeight(48.0),
// // // //           child: Container(
// // // //             color: AppColors.primary,
// // // //             child: TabBar(
// // // //               controller: _tabController,
// // // //               indicatorColor: Colors.white,
// // // //               labelColor: Colors.white,
// // // //               unselectedLabelColor: Colors.white70,
// // // //               tabs: const [
// // // //                 Tab(
// // // //                   icon: Icon(Icons.chat, size: 20),
// // // //                   text: 'Chat',
// // // //                 ),
// // // //                 Tab(
// // // //                   icon: Icon(Icons.attach_file, size: 20),
// // // //                   text: 'Files',
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //       body: TabBarView(
// // // //         controller: _tabController,
// // // //         children: [
// // // //           // Chat Tab
// // // //           _buildChatTab(),
// // // //
// // // //           // Files Tab
// // // //           _buildFilesTab(),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildChatTab() {
// // // //     return Column(
// // // //       children: [
// // // //         // Order Info Card
// // // //         Container(
// // // //           width: double.infinity,
// // // //           padding: const EdgeInsets.all(12),
// // // //           margin: const EdgeInsets.all(8),
// // // //           decoration: BoxDecoration(
// // // //             color: Colors.white,
// // // //             borderRadius: BorderRadius.circular(12),
// // // //             boxShadow: [
// // // //               BoxShadow(
// // // //                 color: Colors.grey.withOpacity(0.2),
// // // //                 blurRadius: 4,
// // // //                 offset: const Offset(0, 2),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           child: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               Text(
// // // //                 "Consultation Details",
// // // //                 style: TextStyle(
// // // //                   fontSize: 14,
// // // //                   fontWeight: FontWeight.bold,
// // // //                   color: AppColors.primary,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(height: 8),
// // // //               Row(
// // // //                 children: [
// // // //                   Icon(Icons.medical_services, size: 16, color: Colors.grey),
// // // //                   const SizedBox(width: 8),
// // // //                   Text("${widget.order.doctorType} - ${widget.order.speciality}"),
// // // //                 ],
// // // //               ),
// // // //               const SizedBox(height: 4),
// // // //               Row(
// // // //                 children: [
// // // //                   Icon(Icons.person, size: 16, color: Colors.grey),
// // // //                   const SizedBox(width: 8),
// // // //                   Text("Patient: ${widget.order.userName}"),
// // // //                 ],
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //         Expanded(
// // // //           child: messages.isEmpty
// // // //               ? const Center(
// // // //             child: Column(
// // // //               mainAxisAlignment: MainAxisAlignment.center,
// // // //               children: [
// // // //                 Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
// // // //                 SizedBox(height: 16),
// // // //                 Text(
// // // //                   "No messages yet",
// // // //                   style: TextStyle(
// // // //                     color: Colors.grey,
// // // //                     fontSize: 16,
// // // //                   ),
// // // //                 ),
// // // //                 Text(
// // // //                   "Start the conversation with your patient",
// // // //                   style: TextStyle(
// // // //                     color: Colors.grey,
// // // //                     fontSize: 12,
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           )
// // // //               : ListView.builder(
// // // //             controller: _scrollController,
// // // //             padding: const EdgeInsets.all(10),
// // // //             itemCount: messages.length,
// // // //             itemBuilder: (context, index) {
// // // //               return _buildMessageBubble(messages[index]);
// // // //             },
// // // //           ),
// // // //         ),
// // // //         if (!isReadOnly) _buildMessageInput(),
// // // //         if (isReadOnly) _buildReadOnlyMessage(),
// // // //       ],
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildFilesTab() {
// // // //     return Column(
// // // //       children: [
// // // //         // Header with file count and refresh
// // // //         Container(
// // // //           padding: const EdgeInsets.all(16),
// // // //           color: Colors.white,
// // // //           child: Row(
// // // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //             children: [
// // // //               Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   Text(
// // // //                     "Medical Reports & Files",
// // // //                     style: TextStyle(
// // // //                       fontWeight: FontWeight.bold,
// // // //                       fontSize: 16,
// // // //                       color: AppColors.primary,
// // // //                     ),
// // // //                   ),
// // // //                   Text(
// // // //                     "${files.length} file(s) found",
// // // //                     style: TextStyle(
// // // //                       color: Colors.grey.shade600,
// // // //                       fontSize: 12,
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               IconButton(
// // // //                 icon: Icon(Icons.refresh, color: AppColors.primary),
// // // //                 onPressed: _loadOrderFiles,
// // // //                 tooltip: 'Refresh Files',
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //
// // // //         // Debug info panel
// // // //         if (files.isNotEmpty)
// // // //           Container(
// // // //             padding: const EdgeInsets.all(8),
// // // //             margin: const EdgeInsets.symmetric(horizontal: 8),
// // // //             decoration: BoxDecoration(
// // // //               color: Colors.blue.shade50,
// // // //               borderRadius: BorderRadius.circular(8),
// // // //               border: Border.all(color: Colors.blue.shade100),
// // // //             ),
// // // //             child: Row(
// // // //               children: [
// // // //                 Icon(Icons.info, color: Colors.blue.shade600, size: 16),
// // // //                 SizedBox(width: 8),
// // // //                 Expanded(
// // // //                   child: Text(
// // // //                     'Files will be saved in /MediConnect folder in your device storage',
// // // //                     style: TextStyle(
// // // //                       color: Colors.blue.shade800,
// // // //                       fontSize: 12,
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //
// // // //         // Files list
// // // //         Expanded(
// // // //           child: _buildFilesList(),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildFilesList() {
// // // //     if (_isLoadingFiles) {
// // // //       return const Center(
// // // //         child: Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             CircularProgressIndicator(),
// // // //             SizedBox(height: 16),
// // // //             Text("Loading medical reports..."),
// // // //           ],
// // // //         ),
// // // //       );
// // // //     }
// // // //
// // // //     if (files.isEmpty) {
// // // //       return const Center(
// // // //         child: Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             Icon(Icons.folder_open, size: 64, color: Colors.grey),
// // // //             SizedBox(height: 16),
// // // //             Text(
// // // //               "No medical reports uploaded yet",
// // // //               style: TextStyle(
// // // //                 color: Colors.grey,
// // // //                 fontSize: 16,
// // // //               ),
// // // //             ),
// // // //             Text(
// // // //               "Patient uploaded files will appear here",
// // // //               style: TextStyle(
// // // //                 color: Colors.grey,
// // // //                 fontSize: 12,
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       );
// // // //     }
// // // //
// // // //     return RefreshIndicator(
// // // //       onRefresh: _refreshFiles,
// // // //       child: ListView.builder(
// // // //         padding: const EdgeInsets.all(8),
// // // //         itemCount: files.length,
// // // //         itemBuilder: (context, index) {
// // // //           final file = files[index];
// // // //           if (file is Map<String, dynamic>) {
// // // //             return _buildFileItem(file);
// // // //           } else {
// // // //             return Container(
// // // //               margin: const EdgeInsets.symmetric(vertical: 4),
// // // //               padding: const EdgeInsets.all(12),
// // // //               decoration: BoxDecoration(
// // // //                 color: Colors.white,
// // // //                 borderRadius: BorderRadius.circular(8),
// // // //                 border: Border.all(color: Colors.red),
// // // //               ),
// // // //               child: Text(
// // // //                 'Invalid file format at index $index: ${file.toString()}',
// // // //                 style: const TextStyle(color: Colors.red),
// // // //               ),
// // // //             );
// // // //           }
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildMessageInput() {
// // // //     return SafeArea(
// // // //       child: Container(
// // // //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// // // //         decoration: BoxDecoration(
// // // //           color: AppColors.primary,
// // // //           boxShadow: [
// // // //             BoxShadow(
// // // //               color: Colors.grey.withOpacity(0.2),
// // // //               blurRadius: 4,
// // // //               offset: const Offset(0, -1),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         child: Row(
// // // //           children: [
// // // //             Expanded(
// // // //               child: Container(
// // // //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Colors.white,
// // // //                   borderRadius: BorderRadius.circular(21),
// // // //                   boxShadow: [
// // // //                     BoxShadow(
// // // //                       color: Colors.grey.withOpacity(0.2),
// // // //                       blurRadius: 4,
// // // //                       offset: const Offset(0, 1),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //                 child: TextField(
// // // //                   controller: _controller,
// // // //                   keyboardType: TextInputType.multiline,
// // // //                   textInputAction: TextInputAction.newline,
// // // //                   minLines: 1,
// // // //                   maxLines: 4,
// // // //                   decoration: const InputDecoration.collapsed(
// // // //                     hintText: "Type your message here",
// // // //                   ),
// // // //                   onChanged: (text) {
// // // //                     WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
// // // //                   },
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(width: 8),
// // // //             CircleAvatar(
// // // //               backgroundColor: AppColors.textLight,
// // // //               child: IconButton(
// // // //                 icon: const Icon(Icons.send, color: AppColors.primary),
// // // //                 onPressed: () => sendMessage(_controller.text),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildReadOnlyMessage() {
// // // //     return Container(
// // // //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.grey,
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Colors.grey.withOpacity(0.2),
// // // //             blurRadius: 4,
// // // //             offset: const Offset(0, -1),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: const Center(
// // // //         child: Text(
// // // //           "This order is completed - Chat history view only",
// // // //           style: TextStyle(
// // // //             color: Colors.white,
// // // //             fontWeight: FontWeight.bold,
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // //
// // //
// // //
// // //
// // //
// // //
// // //
// // // import 'dart:async';
// // // import 'dart:convert';
// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:path_provider/path_provider.dart';
// // // import 'package:permission_handler/permission_handler.dart';
// // // import 'dart:math';
// // // import 'order.dart';
// // // import 'message.dart';
// // // import 'helper.dart';
// // // import 'package:flutter_downloader/flutter_downloader.dart';
// // // import 'package:device_info_plus/device_info_plus.dart';
// // // import 'package:open_filex/open_filex.dart';
// // //
// // // class OrderChatPage extends StatefulWidget {
// // //   final Order order;
// // //   final VoidCallback? onSessionEnded;
// // //   final bool isReadOnly;
// // //   final bool isDoctorView;
// // //
// // //   const OrderChatPage({
// // //     super.key,
// // //     required this.order,
// // //     this.onSessionEnded,
// // //     this.isReadOnly = false,
// // //     this.isDoctorView = false,
// // //   });
// // //
// // //   @override
// // //   State<OrderChatPage> createState() => _OrderChatPageState();
// // // }
// // //
// // // class _OrderChatPageState extends State<OrderChatPage> with SingleTickerProviderStateMixin {
// // //   final TextEditingController _controller = TextEditingController();
// // //   final ScrollController _scrollController = ScrollController();
// // //   List<Message> messages = [];
// // //   List<dynamic> files = [];
// // //   bool _isLoadingFiles = false;
// // //   late TabController _tabController;
// // //   int _currentTabIndex = 0;
// // //   bool _isDownloading = false;
// // //   String _downloadingFileName = '';
// // //
// // //   // NEW: Upload access variables
// // //   bool _isGrantingUploadAccess = false;
// // //   bool _hasUploadAccess = false;
// // //
// // //   // Download tracking variables
// // //   final Set<String> _downloadingTaskIds = {};
// // //   final Map<String, double> _downloadProgress = {};
// // //
// // //   bool get isReadOnly => widget.isReadOnly || widget.order.status?.toLowerCase() == 'completed';
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     messages = widget.order.messages ?? [];
// // //     files = widget.order.files ?? [];
// // //
// // //     _tabController = TabController(length: 2, vsync: this);
// // //     _tabController.addListener(_handleTabChange);
// // //
// // //     // Initialize downloader callbacks
// // //     _initializeDownloader();
// // //
// // //     // NEW: Check if upload access is already granted
// // //     _checkUploadAccess();
// // //
// // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // //       _scrollToBottom();
// // //       _loadOrderFiles();
// // //     });
// // //   }
// // //
// // //   // NEW: Check if upload access is already granted
// // //   void _checkUploadAccess() {
// // //     // Check if there's any message indicating upload access was granted
// // //     for (var message in messages) {
// // //       if (message.text.toLowerCase().contains('upload access granted') ||
// // //           message.text.toLowerCase().contains('can upload more reports')) {
// // //         setState(() {
// // //           _hasUploadAccess = true;
// // //         });
// // //         break;
// // //       }
// // //     }
// // //   }
// // //
// // //   // Initialize downloader callbacks
// // //   void _initializeDownloader() {
// // //     FlutterDownloader.registerCallback((id, status, progress) {
// // //       if (_downloadingTaskIds.contains(id)) {
// // //         print('Download task $id: $status ($progress%)');
// // //
// // //         setState(() {
// // //           _downloadProgress[id] = progress.toDouble();
// // //         });
// // //
// // //         if (status == DownloadTaskStatus.complete) {
// // //           _downloadingTaskIds.remove(id);
// // //           _downloadProgress.remove(id);
// // //           if (mounted) {
// // //             Helpers.showSnackBar(
// // //               context,
// // //               'Download completed!',
// // //               bgColor: Colors.green,
// // //             );
// // //           }
// // //         } else if (status == DownloadTaskStatus.failed) {
// // //           _downloadingTaskIds.remove(id);
// // //           _downloadProgress.remove(id);
// // //           if (mounted) {
// // //             Helpers.showSnackBar(
// // //               context,
// // //               'Download failed!',
// // //               bgColor: Colors.red,
// // //             );
// // //           }
// // //         } else if (status == DownloadTaskStatus.canceled) {
// // //           _downloadingTaskIds.remove(id);
// // //           _downloadProgress.remove(id);
// // //         }
// // //       }
// // //     });
// // //   }
// // //
// // //   void _handleTabChange() {
// // //     if (_tabController.index != _currentTabIndex) {
// // //       setState(() {
// // //         _currentTabIndex = _tabController.index;
// // //       });
// // //
// // //       if (_tabController.index == 1) {
// // //         print('🔄 Switched to Files tab, refreshing files...');
// // //         _loadOrderFiles();
// // //       }
// // //     }
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     // Cancel all ongoing downloads when the page is disposed
// // //     for (String taskId in _downloadingTaskIds) {
// // //       FlutterDownloader.cancel(taskId: taskId);
// // //     }
// // //     _downloadingTaskIds.clear();
// // //     _downloadProgress.clear();
// // //
// // //     _tabController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   void _scrollToBottom() {
// // //     if (_scrollController.hasClients) {
// // //       _scrollController.animateTo(
// // //         _scrollController.position.maxScrollExtent,
// // //         duration: const Duration(milliseconds: 300),
// // //         curve: Curves.easeOut,
// // //       );
// // //     }
// // //   }
// // //
// // //   // NEW: Grant upload access to patient
// // //   Future<void> _grantUploadAccess() async {
// // //     if (_isGrantingUploadAccess) return;
// // //
// // //     try {
// // //       setState(() {
// // //         _isGrantingUploadAccess = true;
// // //       });
// // //
// // //       final prefs = await SharedPreferences.getInstance();
// // //       final token = prefs.getString('token');
// // //
// // //       if (token == null) {
// // //         Helpers.showSnackBar(context, 'Authentication required', bgColor: Colors.red);
// // //         return;
// // //       }
// // //
// // //       final String url = "${ApiConfig.baseUrl}/grantUploadAccess/${widget.order.orderId}";
// // //
// // //       print('📤 Granting upload access for order: ${widget.order.orderId}');
// // //
// // //       final response = await http.post(
// // //         Uri.parse(url),
// // //         headers: {
// // //           'Content-Type': 'application/json',
// // //           'Authorization': 'Bearer $token',
// // //         },
// // //         body: jsonEncode({
// // //           'doctorId': prefs.getString('doctorId'),
// // //           'doctorName': prefs.getString('doctorName') ?? 'Doctor',
// // //           'patientUserId': widget.order.userId,
// // //           'patientUserName': widget.order.userName,
// // //         }),
// // //       );
// // //
// // //       print('📥 Grant upload access response: ${response.statusCode}');
// // //       print('📥 Response body: ${response.body}');
// // //
// // //       if (response.statusCode == 200) {
// // //         final data = jsonDecode(response.body);
// // //
// // //         if (data['success'] == true) {
// // //           // Send a message to the chat about upload access
// // //           await _sendUploadAccessMessage();
// // //
// // //           setState(() {
// // //             _hasUploadAccess = true;
// // //           });
// // //
// // //           Helpers.showSnackBar(
// // //             context,
// // //             'Upload access granted to patient!',
// // //             bgColor: Colors.green,
// // //           );
// // //         } else {
// // //           throw Exception(data['message'] ?? 'Failed to grant upload access');
// // //         }
// // //       } else {
// // //         throw Exception('HTTP ${response.statusCode}: ${response.body}');
// // //       }
// // //     } catch (e) {
// // //       print('❌ Grant upload access error: $e');
// // //       Helpers.showSnackBar(
// // //         context,
// // //         'Failed to grant upload access: ${e.toString()}',
// // //         bgColor: Colors.red,
// // //       );
// // //     } finally {
// // //       setState(() {
// // //         _isGrantingUploadAccess = false;
// // //       });
// // //     }
// // //   }
// // //
// // //   // NEW: Send message about upload access
// // //   Future<void> _sendUploadAccessMessage() async {
// // //     try {
// // //       final String url = "${ApiConfig.baseUrl}/sendMessageDoctor/${widget.order.orderId}";
// // //
// // //       final messageText = "📎 Upload Access Granted!\n\nThe patient can now upload additional medical reports for this consultation. They will see an upload button in their chat to add more files.";
// // //
// // //       final Map<String, dynamic> requestBody = {
// // //         'text': messageText,
// // //         'isBot': false,
// // //         'userName': 'Doctor',
// // //         'userId': 'doctor',
// // //         'patientUserId': widget.order.userId,
// // //         'patientUserName': widget.order.userName,
// // //         'isSystemMessage': true,
// // //       };
// // //
// // //       final response = await http.post(
// // //         Uri.parse(url),
// // //         headers: {'Content-Type': 'application/json'},
// // //         body: jsonEncode(requestBody),
// // //       );
// // //
// // //       if (response.statusCode == 200) {
// // //         final data = jsonDecode(response.body)['data'];
// // //         setState(() {
// // //           messages.add(Message.fromMap(data));
// // //         });
// // //         _scrollToBottom();
// // //       }
// // //     } catch (e) {
// // //       print('❌ Error sending upload access message: $e');
// // //     }
// // //   }
// // //
// // //   Future<void> _loadOrderFiles() async {
// // //     if (_isLoadingFiles) return;
// // //
// // //     try {
// // //       setState(() {
// // //         _isLoadingFiles = true;
// // //       });
// // //
// // //       if (widget.order.files != null && widget.order.files!.isNotEmpty) {
// // //         print('🔄 Using files from order object (passed from HomePage)');
// // //         setState(() {
// // //           files = widget.order.files!;
// // //         });
// // //         print('✅ Loaded ${files.length} files from order object');
// // //         return;
// // //       }
// // //
// // //       print('ℹ No files in order object, trying API...');
// // //
// // //       final prefs = await SharedPreferences.getInstance();
// // //       final token = prefs.getString('token');
// // //       final doctorId = prefs.getString('doctorId');
// // //       final doctorType = prefs.getString('doctorType');
// // //
// // //       if (token == null || token.isEmpty) {
// // //         print('❌ No token available for loading files');
// // //         return;
// // //       }
// // //
// // //       if (doctorId == null || doctorType == null) {
// // //         print('❌ Doctor information not available');
// // //         return;
// // //       }
// // //
// // //       print('🔐 Using token: ${token.substring(0, min(20, token.length))}...');
// // //       print('👨‍⚕ Doctor: $doctorId, Type: $doctorType');
// // //
// // //       final String url = "${ApiConfig.baseUrl}/getOrders?doctorType=$doctorType&doctorId=$doctorId";
// // //       print('📤 Loading files from: $url');
// // //
// // //       final response = await http.get(
// // //         Uri.parse(url),
// // //         headers: {
// // //           'Content-Type': 'application/json',
// // //           'Authorization': 'Bearer $token',
// // //         },
// // //       );
// // //
// // //       print('📥 Files API Response Status: ${response.statusCode}');
// // //
// // //       if (response.statusCode == 200) {
// // //         final decoded = jsonDecode(response.body);
// // //         print('📦 Files API Response Body: ${jsonEncode(decoded)}');
// // //
// // //         if (decoded['success'] == true) {
// // //           List<dynamic> allOrdersData = [];
// // //
// // //           if (decoded['data'] is Map && decoded['data']['orders'] != null) {
// // //             allOrdersData = decoded['data']['orders'];
// // //           } else if (decoded['data'] is List) {
// // //             allOrdersData = decoded['data'];
// // //           } else if (decoded['orders'] is List) {
// // //             allOrdersData = decoded['orders'];
// // //           }
// // //
// // //           print('🔍 Searching for order: ${widget.order.orderId} in ${allOrdersData.length} orders');
// // //
// // //           Map<String, dynamic>? currentOrderData;
// // //           for (var order in allOrdersData) {
// // //             if (order is Map<String, dynamic>) {
// // //               final orderId = order['orderId']?.toString() ?? order['_id']?.toString();
// // //               if (orderId == widget.order.orderId) {
// // //                 currentOrderData = order;
// // //                 break;
// // //               }
// // //             }
// // //           }
// // //
// // //           if (currentOrderData != null) {
// // //             print('✅ Found current order data');
// // //
// // //             List<dynamic> allFiles = _extractFilesFromOrderData(currentOrderData);
// // //
// // //             print('✅ Extracted ${allFiles.length} files for order ${widget.order.orderId}');
// // //
// // //             for (int i = 0; i < allFiles.length; i++) {
// // //               final file = allFiles[i];
// // //               if (file is Map<String, dynamic>) {
// // //                 print('📄 File $i: ${file['fileName']}');
// // //                 print('   - fileType: ${file['fileType']}');
// // //                 print('   - uploadedBy: ${file['uploadedBy']}');
// // //                 print('   - filePath: ${file['filePath']}');
// // //                 print('   - downloadUrl: ${file['downloadUrl']}');
// // //               }
// // //             }
// // //
// // //             setState(() {
// // //               files = allFiles;
// // //             });
// // //
// // //             print('✅ UI Updated with ${files.length} files');
// // //           } else {
// // //             print('❌ Order ${widget.order.orderId} not found in response');
// // //           }
// // //         } else {
// // //           print('❌ API returned success: false');
// // //           print('❌ Message: ${decoded['message']}');
// // //         }
// // //       } else {
// // //         print('❌ Failed to load files: ${response.statusCode}');
// // //         print('❌ Response body: ${response.body}');
// // //       }
// // //     } catch (e, stackTrace) {
// // //       print('❌ Error loading files: $e');
// // //       print('❌ Stack trace: $stackTrace');
// // //     } finally {
// // //       setState(() {
// // //         _isLoadingFiles = false;
// // //       });
// // //     }
// // //   }
// // //
// // //   List<dynamic> _extractFilesFromOrderData(Map<String, dynamic> orderData) {
// // //     List<dynamic> allFiles = [];
// // //
// // //     try {
// // //       print('🔍 Extracting files from order data structure...');
// // //
// // //       // Method 1: Extract from reports.files.all (main location)
// // //       if (orderData['reports'] != null && orderData['reports'] is Map<String, dynamic>) {
// // //         final reports = orderData['reports'] as Map<String, dynamic>;
// // //
// // //         if (reports['files'] != null && reports['files'] is Map<String, dynamic>) {
// // //           final filesMap = reports['files'] as Map<String, dynamic>;
// // //
// // //           // Get files from 'all' array
// // //           if (filesMap['all'] != null && filesMap['all'] is List) {
// // //             final allFilesList = filesMap['all'] as List<dynamic>;
// // //             print('✅ Found ${allFilesList.length} files in reports.files.all');
// // //
// // //             for (var file in allFilesList) {
// // //               if (file is Map<String, dynamic>) {
// // //                 // Ensure file has all required fields and normalize filePath
// // //                 final normalizedFile = _normalizeFileData(file);
// // //                 if (normalizedFile != null) {
// // //                   allFiles.add(normalizedFile);
// // //                 }
// // //               }
// // //             }
// // //           }
// // //         }
// // //       }
// // //
// // //       // Method 2: Extract from messages with attachedFiles
// // //       if (orderData['messages'] != null && orderData['messages'] is List) {
// // //         final messages = orderData['messages'] as List<dynamic>;
// // //         for (var message in messages) {
// // //           if (message is Map<String, dynamic> &&
// // //               message['attachedFiles'] != null &&
// // //               message['attachedFiles'] is List) {
// // //             final attachedFiles = message['attachedFiles'] as List<dynamic>;
// // //             for (var file in attachedFiles) {
// // //               if (file is Map<String, dynamic>) {
// // //                 // Create a file object from message attachment
// // //                 final fileFromMessage = {
// // //                   'fileName': file['fileName'],
// // //                   'filePath': file['filePath'],
// // //                   'fileType': _getFileTypeFromFileName(file['fileName']),
// // //                   'fileSize': 0, // Size might not be available in messages
// // //                   'uploadedBy': 'patient', // Assuming from message context
// // //                   'category': file['category'] ?? 'Uncategorized',
// // //                   'source': 'messages',
// // //                   'messageText': message['text'],
// // //                   'messageCreatedAt': message['createdAt'],
// // //                 };
// // //                 final normalizedFile = _normalizeFileData(fileFromMessage);
// // //                 if (normalizedFile != null) {
// // //                   allFiles.add(normalizedFile);
// // //                 }
// // //               }
// // //             }
// // //           }
// // //         }
// // //       }
// // //
// // //       print('✅ Total normalized files extracted: ${allFiles.length}');
// // //
// // //       // Log all extracted files for debugging
// // //       for (int i = 0; i < allFiles.length; i++) {
// // //         final file = allFiles[i];
// // //         if (file is Map<String, dynamic>) {
// // //           print('📄 File $i: ${file['fileName']}');
// // //           print('   - filePath: ${file['filePath']}');
// // //           print('   - downloadUrl: ${file['downloadUrl']}');
// // //           print('   - fileSize: ${file['fileSize']}');
// // //           print('   - uploadedBy: ${file['uploadedBy']}');
// // //         }
// // //       }
// // //
// // //       return allFiles;
// // //
// // //     } catch (e) {
// // //       print('❌ Error extracting files: $e');
// // //       return allFiles;
// // //     }
// // //   }
// // //
// // //   String getFileTypeFromFileName(String fileName) {
// // //     final extension = fileName.toLowerCase().split('.').last;
// // //     switch (extension) {
// // //       case 'pdf':
// // //         return 'application/pdf';
// // //       case 'jpg':
// // //       case 'jpeg':
// // //         return 'image/jpeg';
// // //       case 'png':
// // //         return 'image/png';
// // //       case 'doc':
// // //       case 'docx':
// // //         return 'application/msword';
// // //       case 'xls':
// // //       case 'xlsx':
// // //         return 'application/vnd.ms-excel';
// // //       default:
// // //         return 'application/octet-stream';
// // //     }
// // //   }
// // //
// // //   Map<String, dynamic>? _normalizeFileData(Map<String, dynamic> file) {
// // //     try {
// // //       final fileName = file['fileName']?.toString();
// // //       if (fileName == null || fileName.isEmpty) {
// // //         print('⚠ Skipping file with no fileName: $file');
// // //         return null;
// // //       }
// // //
// // //       String filePath = file['filePath']?.toString() ?? '';
// // //
// // //       // Normalize file path - replace backslashes with forward slashes
// // //       if (filePath.isNotEmpty) {
// // //         filePath = filePath.replaceAll('\\', '/');
// // //         print('📝 Normalized file path: $filePath');
// // //       }
// // //
// // //       // Create download URL using the dedicated base FILE URL
// // //       String downloadUrl;
// // //       if (filePath.startsWith('http')) {
// // //         // If the path is already a full URL, use it as is
// // //         downloadUrl = filePath;
// // //       } else if (filePath.isNotEmpty) {
// // //         // Construct the URL from the base FILE URL and the relative path
// // //         // Ensure there's no double slash
// // //         final String base = ApiConfig.baseFileUrl.endsWith('/')
// // //             ? ApiConfig.baseFileUrl.substring(0, ApiConfig.baseFileUrl.length - 1)
// // //             : ApiConfig.baseFileUrl;
// // //         final String path = filePath.startsWith('/') ? filePath : '/$filePath';
// // //
// // //         downloadUrl = '$base$path';
// // //         print('🔗 CORRECTLY Constructed download URL: $downloadUrl');
// // //       } else {
// // //         print('⚠ No filePath available for: $fileName');
// // //         return null;
// // //       }
// // //
// // //       final fileType = file['fileType']?.toString() ?? getFileTypeFromFileName(fileName) ?? 'application/octet-stream';
// // //
// // //       return {
// // //         'fileName': fileName,
// // //         'filePath': filePath,
// // //         'downloadUrl': downloadUrl,
// // //         'fileType': fileType,
// // //         'fileSize': (file['fileSize'] is int)
// // //             ? file['fileSize']
// // //             : (file['fileSize'] is String)
// // //             ? int.tryParse(file['fileSize']) ?? 0
// // //             : 0,
// // //         'uploadedBy': file['uploadedBy']?.toString() ?? 'unknown',
// // //         'category': file['category']?.toString() ?? 'Uncategorized',
// // //         'source': file['source']?.toString() ?? 'reports',
// // //         'uploadDate': file['uploadDate']?.toString() ?? DateTime.now().toIso8601String(),
// // //         'originalData': file,
// // //       };
// // //     } catch (e) {
// // //       print('❌ Error normalizing file data: $e');
// // //       return null;
// // //     }
// // //   }
// // //
// // //   String _getFileTypeFromFileName(String fileName) {
// // //     final extension = fileName.toLowerCase().split('.').last;
// // //     switch (extension) {
// // //       case 'pdf':
// // //         return 'application/pdf';
// // //       case 'jpg':
// // //       case 'jpeg':
// // //         return 'image/jpeg';
// // //       case 'png':
// // //         return 'image/png';
// // //       case 'doc':
// // //       case 'docx':
// // //         return 'application/msword';
// // //       case 'xls':
// // //       case 'xlsx':
// // //         return 'application/vnd.ms-excel';
// // //       default:
// // //         return 'application/octet-stream';
// // //     }
// // //   }
// // //
// // //   Future<void> _downloadFile(Map<String, dynamic> file) async {
// // //     final fileName = file['fileName']?.toString() ?? 'Unknown File';
// // //     String? downloadUrl = file['downloadUrl']?.toString();
// // //     final filePath = file['filePath']?.toString();
// // //
// // //     print('📥 Starting download for: $fileName');
// // //     print('🔗 Initial Download URL: $downloadUrl');
// // //     print('📁 File path: $filePath');
// // //
// // //     // Fallback: If downloadUrl is still null but we have a filePath, try to construct it one last time
// // //     if ((downloadUrl == null || downloadUrl.isEmpty) && filePath != null && filePath.isNotEmpty) {
// // //       print('🔄 Download URL is null, attempting to construct from file path as a last resort');
// // //
// // //       String normalizedPath = filePath.replaceAll('\\', '/');
// // //
// // //       // USE THE CORRECT BASE FILE URL HERE
// // //       final String base = ApiConfig.baseFileUrl.endsWith('/')
// // //           ? ApiConfig.baseFileUrl.substring(0, ApiConfig.baseFileUrl.length - 1)
// // //           : ApiConfig.baseFileUrl;
// // //       final String path = normalizedPath.startsWith('/') ? normalizedPath : '/$normalizedPath';
// // //
// // //       downloadUrl = '$base$path';
// // //       print('🔗 CORRECT Fallback constructed download URL: $downloadUrl');
// // //     }
// // //
// // //     if (downloadUrl == null || downloadUrl.isEmpty) {
// // //       print('❌ No download URL could be determined for $fileName');
// // //       Helpers.showSnackBar(context, 'Download URL not available for $fileName', bgColor: Colors.red);
// // //       return;
// // //     }
// // //
// // //     try {
// // //       setState(() {
// // //         _isDownloading = true;
// // //         _downloadingFileName = fileName;
// // //       });
// // //
// // //       Helpers.showSnackBar(context, 'Starting download for $fileName...', bgColor: Colors.blue);
// // //
// // //       await _enhancedFallbackDownload(downloadUrl, fileName);
// // //
// // //     } catch (e) {
// // //       print('❌ Download error: $e');
// // //       Helpers.showSnackBar(
// // //         context,
// // //         'Download failed: ${e.toString()}',
// // //         bgColor: Colors.red,
// // //       );
// // //     } finally {
// // //       setState(() {
// // //         _isDownloading = false;
// // //         _downloadingFileName = '';
// // //       });
// // //     }
// // //   }
// // //
// // //   Future<void> _enhancedFallbackDownload(String url, String fileName) async {
// // //     try {
// // //       print('🔄 Using enhanced fallback download for: $fileName');
// // //       print('🔗 URL: $url');
// // //
// // //       final prefs = await SharedPreferences.getInstance();
// // //       final token = prefs.getString('token');
// // //
// // //       // Create HTTP client
// // //       final client = http.Client();
// // //
// // //       // Make the request
// // //       final response = await client.get(
// // //         Uri.parse(url),
// // //         headers: {
// // //           if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
// // //           'Accept': '/',
// // //         },
// // //       );
// // //
// // //       print('📥 Response status: ${response.statusCode}');
// // //       print('📥 Content length: ${response.contentLength}');
// // //
// // //       if (response.statusCode == 200) {
// // //         // Get a reliable directory
// // //         final directory = await _getReliableDownloadDirectory();
// // //         final String savePath = '${directory.path}/MediConnect';
// // //         final Directory saveDir = Directory(savePath);
// // //
// // //         if (!await saveDir.exists()) {
// // //           await saveDir.create(recursive: true);
// // //           print('📁 Created directory: $savePath');
// // //         }
// // //
// // //         // Clean filename
// // //         final cleanFileName = _cleanFileName(fileName);
// // //         final File file = File('$savePath/$cleanFileName');
// // //
// // //         // Write file
// // //         await file.writeAsBytes(response.bodyBytes);
// // //
// // //         final fileSize = await file.length();
// // //         print('✅ Download successful: ${file.path}');
// // //         print('📊 File size: $fileSize bytes');
// // //
// // //         // Verify file exists and has content
// // //         if (await file.exists() && fileSize > 0) {
// // //           if (mounted) {
// // //             Helpers.showSnackBar(
// // //               context,
// // //               'Download completed: $fileName',
// // //               bgColor: Colors.green,
// // //             );
// // //           }
// // //
// // //           // Try to open the file
// // //           try {
// // //             final openResult = await OpenFilex.open(file.path);
// // //             print('📂 Open file result: ${openResult.type}');
// // //             print('📂 Open file message: ${openResult.message}');
// // //
// // //             if (openResult.type != ResultType.done) {
// // //               if (mounted) {
// // //                 Helpers.showSnackBar(
// // //                   context,
// // //                   'File downloaded to MediConnect folder',
// // //                   bgColor: Colors.blue,
// // //                 );
// // //               }
// // //             }
// // //           } catch (e) {
// // //             print('⚠ Cannot open file automatically: $e');
// // //             if (mounted) {
// // //               Helpers.showSnackBar(
// // //                 context,
// // //                 'File downloaded to MediConnect folder',
// // //                 bgColor: Colors.green,
// // //               );
// // //             }
// // //           }
// // //
// // //           // Show file location
// // //           print('📍 File saved at: ${file.path}');
// // //
// // //         } else {
// // //           throw Exception('File was written but is empty or cannot be accessed');
// // //         }
// // //       } else {
// // //         throw Exception('HTTP ${response.statusCode} - ${response.reasonPhrase}');
// // //       }
// // //
// // //       client.close();
// // //     } catch (e) {
// // //       print('❌ Enhanced fallback download failed: $e');
// // //       rethrow;
// // //     }
// // //   }
// // //
// // //   Future<Directory> _getReliableDownloadDirectory() async {
// // //     try {
// // //       // For Android 10+, use scoped storage - app-specific directory
// // //       if (Platform.isAndroid) {
// // //         // Try external storage first (visible in file managers)
// // //         final externalDir = await getExternalStorageDirectory();
// // //         if (externalDir != null) {
// // //           return externalDir;
// // //         }
// // //       }
// // //
// // //       // Fallback to application documents directory
// // //       return await getApplicationDocumentsDirectory();
// // //     } catch (e) {
// // //       print('⚠ Error getting directory: $e');
// // //       return await getApplicationDocumentsDirectory();
// // //     }
// // //   }
// // //
// // //   String _cleanFileName(String fileName) {
// // //     // Remove invalid characters for file names
// // //     // We will explicitly replace each character to avoid regex issues
// // //     String cleaned = fileName
// // //         .replaceAll('<', '_')
// // //         .replaceAll('>', '_')
// // //         .replaceAll(':', '_')
// // //         .replaceAll('"', '_')
// // //         .replaceAll('/', '_')
// // //         .replaceAll('\\', '_')
// // //         .replaceAll('|', '_')
// // //         .replaceAll('?', '_')
// // //         .replaceAll('*', '_');
// // //
// // //     // Replace multiple spaces with single underscore
// // //     cleaned = cleaned.replaceAll(RegExp(r'\s+'), '_');
// // //
// // //     // Remove leading/trailing spaces and underscores
// // //     cleaned = cleaned.trim().replaceAll(RegExp(r'^_+|_+$'), '');
// // //
// // //     // If filename is empty after cleaning, use a default name
// // //     if (cleaned.isEmpty) {
// // //       cleaned = 'downloaded_file_${DateTime.now().millisecondsSinceEpoch}';
// // //     }
// // //
// // //     return cleaned;
// // //   }
// // //
// // //   // Send message
// // //   Future<void> sendMessage(String text) async {
// // //     if (text.trim().isEmpty) return;
// // //     if (isReadOnly) {
// // //       Helpers.showSnackBar(context, 'Cannot send messages in completed order', bgColor: Colors.orange);
// // //       return;
// // //     }
// // //
// // //     try {
// // //       final String url = "${ApiConfig.baseUrl}/sendMessageDoctor/${widget.order.orderId}";
// // //       final Map<String, dynamic> requestBody = {
// // //         'text': text,
// // //         'isBot': false,
// // //         'userName': 'Doctor',
// // //         'userId': 'doctor',
// // //         'patientUserId': widget.order.userId,
// // //         'patientUserName': widget.order.userName,
// // //       };
// // //
// // //       print('📤 Sending message to: $url');
// // //       print('📦 Request body: $requestBody');
// // //
// // //       final response = await http.post(
// // //         Uri.parse(url),
// // //         headers: {'Content-Type': 'application/json'},
// // //         body: jsonEncode(requestBody),
// // //       );
// // //
// // //       print('📥 Response status: ${response.statusCode}');
// // //       print('📥 Response body: ${response.body}');
// // //
// // //       if (response.statusCode == 200) {
// // //         final data = jsonDecode(response.body)['data'];
// // //         setState(() {
// // //           messages.add(Message.fromMap(data));
// // //         });
// // //         _controller.clear();
// // //         _scrollToBottom();
// // //       } else {
// // //         final errorBody = jsonDecode(response.body);
// // //         final errorMessage = errorBody['message'] ?? 'Failed to send message';
// // //         Helpers.showSnackBar(context, 'Error: $errorMessage', bgColor: Colors.red);
// // //       }
// // //     } catch (e) {
// // //       print('❌ sendMessage error: $e');
// // //       Helpers.showSnackBar(context, 'Network error: $e', bgColor: Colors.red);
// // //     }
// // //   }
// // //
// // //   // End Session
// // //   Future<void> _endSession() async {
// // //     if (isReadOnly) {
// // //       Helpers.showSnackBar(context, 'This order is already completed', bgColor: Colors.orange);
// // //       return;
// // //     }
// // //
// // //     bool confirmEnd = await showDialog(
// // //       context: context,
// // //       builder: (BuildContext context) {
// // //         return AlertDialog(
// // //           title: const Text("End Session"),
// // //           content: const Text("Are you sure you want to end this session? This will complete the order and reset the chat for the patient."),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.of(context).pop(false),
// // //               child: const Text("Cancel"),
// // //             ),
// // //             ElevatedButton(
// // //               onPressed: () => Navigator.of(context).pop(true),
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: Colors.green,
// // //               ),
// // //               child: const Text("End Session", style: TextStyle(color: Colors.white)),
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //
// // //     if (confirmEnd != true) return;
// // //
// // //     try {
// // //       final String url = "${ApiConfig.baseUrl}/completeOrder/${widget.order.orderId}";
// // //
// // //       print('🚀 Ending session for order: ${widget.order.orderId}');
// // //
// // //       final requestBody = {
// // //         'status': 'completed',
// // //         'completedAt': DateTime.now().toIso8601String(),
// // //         'completedBy': 'Doctor',
// // //         'resetChat': true,
// // //       };
// // //
// // //       final response = await http.put(
// // //         Uri.parse(url),
// // //         headers: {'Content-Type': 'application/json'},
// // //         body: jsonEncode(requestBody),
// // //       );
// // //
// // //       if (response.statusCode == 200) {
// // //         final responseData = jsonDecode(response.body);
// // //
// // //         if (responseData['success'] == true) {
// // //           Helpers.showSnackBar(
// // //             context,
// // //             'Session ended successfully! Order completed and chat reset.',
// // //             bgColor: Colors.green,
// // //           );
// // //
// // //           if (widget.onSessionEnded != null) {
// // //             widget.onSessionEnded!();
// // //           }
// // //
// // //           Navigator.of(context).pop(true);
// // //         } else {
// // //           throw Exception(responseData['message'] ?? 'Failed to complete order');
// // //         }
// // //       } else {
// // //         throw Exception('HTTP ${response.statusCode}: ${response.body}');
// // //       }
// // //     } catch (e) {
// // //       print('❌ End session error: $e');
// // //       Helpers.showSnackBar(
// // //         context,
// // //         'Failed to end session: ${e.toString()}',
// // //         bgColor: Colors.red,
// // //       );
// // //     }
// // //   }
// // //
// // //   // Build file item widget
// // //   Widget _buildFileItem(Map<String, dynamic> file) {
// // //     final fileName = file['fileName']?.toString() ?? 'Unknown File';
// // //     final fileSize = file['fileSize'] ?? 0;
// // //     final fileType = file['fileType']?.toString() ?? 'file';
// // //     final uploadedBy = file['uploadedBy']?.toString() ?? 'Unknown';
// // //     final category = file['category']?.toString() ?? 'Uncategorized';
// // //     final uploadDate = file['uploadDate'] != null
// // //         ? DateTime.tryParse(file['uploadDate'])?.toLocal() ?? DateTime.now()
// // //         : DateTime.now();
// // //
// // //     // Check if this file is currently downloading
// // //     bool isDownloadingThisFile = _isDownloading && _downloadingFileName == fileName;
// // //
// // //     return Container(
// // //       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// // //       padding: const EdgeInsets.all(12),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(12),
// // //         border: Border.all(color: Colors.grey.shade300),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.grey.withOpacity(0.1),
// // //             blurRadius: 4,
// // //             offset: const Offset(0, 2),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Container(
// // //             padding: const EdgeInsets.all(8),
// // //             decoration: BoxDecoration(
// // //               color: AppColors.primary.withOpacity(0.1),
// // //               borderRadius: BorderRadius.circular(8),
// // //             ),
// // //             child: Icon(
// // //               _getFileIcon(fileType),
// // //               color: AppColors.primary,
// // //               size: 24,
// // //             ),
// // //           ),
// // //           const SizedBox(width: 12),
// // //           Expanded(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   fileName,
// // //                   style: const TextStyle(
// // //                     fontWeight: FontWeight.bold,
// // //                     fontSize: 14,
// // //                   ),
// // //                   maxLines: 2,
// // //                   overflow: TextOverflow.ellipsis,
// // //                 ),
// // //                 const SizedBox(height: 4),
// // //                 Text(
// // //                   'Category: $category',
// // //                   style: TextStyle(
// // //                     color: Colors.grey.shade600,
// // //                     fontSize: 12,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 4),
// // //                 Row(
// // //                   children: [
// // //                     Text(
// // //                       _formatFileSize(fileSize is int ? fileSize : 0),
// // //                       style: TextStyle(
// // //                         color: Colors.grey.shade600,
// // //                         fontSize: 12,
// // //                       ),
// // //                     ),
// // //                     const SizedBox(width: 8),
// // //                     Container(
// // //                       width: 4,
// // //                       height: 4,
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.grey.shade400,
// // //                         shape: BoxShape.circle,
// // //                       ),
// // //                     ),
// // //                     const SizedBox(width: 8),
// // //                     Text(
// // //                       fileType.split('/').last.toUpperCase(),
// // //                       style: TextStyle(
// // //                         color: Colors.grey.shade600,
// // //                         fontSize: 12,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 const SizedBox(height: 4),
// // //                 Row(
// // //                   children: [
// // //                     Icon(
// // //                       uploadedBy == 'patient' ? Icons.person : Icons.medical_services,
// // //                       size: 12,
// // //                       color: Colors.grey.shade600,
// // //                     ),
// // //                     const SizedBox(width: 4),
// // //                     Text(
// // //                       'Uploaded by ${uploadedBy == 'patient' ? 'Patient' : 'Doctor'}',
// // //                       style: TextStyle(
// // //                         color: Colors.grey.shade600,
// // //                         fontSize: 11,
// // //                       ),
// // //                     ),
// // //                     const SizedBox(width: 8),
// // //                     Text(
// // //                       '${uploadDate.day}/${uploadDate.month}/${uploadDate.year}',
// // //                       style: TextStyle(
// // //                         color: Colors.grey.shade600,
// // //                         fontSize: 11,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 if (isDownloadingThisFile) ...[
// // //                   const SizedBox(height: 8),
// // //                   LinearProgressIndicator(
// // //                     backgroundColor: Colors.grey.shade300,
// // //                     valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
// // //                   ),
// // //                   const SizedBox(height: 4),
// // //                   Text(
// // //                     'Downloading...',
// // //                     style: const TextStyle(
// // //                       color: Colors.blue,
// // //                       fontSize: 10,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ],
// // //             ),
// // //           ),
// // //           if (isDownloadingThisFile)
// // //             const Padding(
// // //               padding: EdgeInsets.all(8.0),
// // //               child: SizedBox(
// // //                 width: 24,
// // //                 height: 24,
// // //                 child: CircularProgressIndicator(strokeWidth: 2),
// // //               ),
// // //             )
// // //           else
// // //             IconButton(
// // //               icon: Icon(
// // //                 Icons.download,
// // //                 color: AppColors.primary,
// // //               ),
// // //               onPressed: () => _downloadFile(file),
// // //             ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   // Helper methods for file display
// // //   IconData _getFileIcon(String fileType) {
// // //     if (fileType.toLowerCase().contains('image')) return Icons.image;
// // //     if (fileType.toLowerCase().contains('pdf')) return Icons.picture_as_pdf;
// // //     if (fileType.toLowerCase().contains('word') || fileType.toLowerCase().contains('document'))
// // //       return Icons.description;
// // //     return Icons.insert_drive_file;
// // //   }
// // //
// // //   String _formatFileSize(int bytes) {
// // //     if (bytes < 1024) return '$bytes B';
// // //     if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
// // //     return '${(bytes / 1048576).toStringAsFixed(1)} MB';
// // //   }
// // //
// // //   // Build message bubble
// // //   Widget _buildMessageBubble(Message msg) {
// // //     final isDoctor = msg.userName == "Doctor";
// // //     final alignment = isDoctor ? Alignment.centerRight : Alignment.centerLeft;
// // //     final bgColor = isDoctor
// // //         ? AppColors.textLight.withOpacity(0.9)
// // //         : AppColors.primary.withOpacity(0.9);
// // //     final textColor = isDoctor ? Colors.black87 : Colors.white;
// // //
// // //     return Container(
// // //       alignment: alignment,
// // //       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// // //       child: Container(
// // //         padding: const EdgeInsets.all(12),
// // //         constraints: const BoxConstraints(maxWidth: 280),
// // //         decoration: BoxDecoration(
// // //           color: bgColor,
// // //           borderRadius: BorderRadius.circular(12),
// // //         ),
// // //         child: Column(
// // //           crossAxisAlignment: isDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               msg.text,
// // //               style: TextStyle(color: textColor, fontSize: 15),
// // //             ),
// // //             const SizedBox(height: 4),
// // //             Text(
// // //               "${msg.createdAt?.hour.toString().padLeft(2, '0')}:${msg.createdAt?.minute.toString().padLeft(2, '0')}",
// // //               style: TextStyle(
// // //                 color: textColor.withOpacity(0.7),
// // //                 fontSize: 10,
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Future<void> _refreshFiles() async {
// // //     print('🔄 Manually refreshing files...');
// // //     await _loadOrderFiles();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.grey[100],
// // //       appBar: AppBar(
// // //         backgroundColor: isReadOnly ? Colors.grey : AppColors.primary,
// // //         iconTheme: const IconThemeData(color: Colors.white),
// // //         toolbarHeight: 75,
// // //         title: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               widget.order.userName,
// // //               style: const TextStyle(
// // //                 color: Colors.white,
// // //                 fontSize: 20,
// // //                 fontWeight: FontWeight.bold,
// // //               ),
// // //             ),
// // //             if (isReadOnly)
// // //               const Text(
// // //                 "COMPLETED - VIEW ONLY",
// // //                 style: TextStyle(
// // //                   color: Colors.white,
// // //                   fontSize: 10,
// // //                   fontWeight: FontWeight.bold,
// // //                 ),
// // //               ),
// // //           ],
// // //         ),
// // //
// // //         actions: [
// // //           // NEW: Upload Access Button
// // //           if (!isReadOnly && !_hasUploadAccess)
// // //             Padding(
// // //               padding: const EdgeInsets.only(right: 8.0),
// // //               child: ElevatedButton.icon(
// // //                 onPressed: _isGrantingUploadAccess ? null : _grantUploadAccess,
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: Colors.orange,
// // //                   foregroundColor: Colors.white,
// // //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                   shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(20),
// // //                   ),
// // //                 ),
// // //                 icon: _isGrantingUploadAccess
// // //                     ? const SizedBox(
// // //                   width: 16,
// // //                   height: 16,
// // //                   child: CircularProgressIndicator(
// // //                     strokeWidth: 2,
// // //                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// // //                   ),
// // //                 )
// // //                     : const Icon(Icons.upload_file, size: 16),
// // //                 label: _isGrantingUploadAccess
// // //                     ? const Text(
// // //                   "Granting...",
// // //                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
// // //                 )
// // //                     : const Text(
// // //                   "Allow Upload",
// // //                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
// // //                 ),
// // //               ),
// // //             ),
// // //           if (!isReadOnly)
// // //             Padding(
// // //               padding: const EdgeInsets.only(right: 11.0),
// // //               child: ElevatedButton.icon(
// // //                 onPressed: _endSession,
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: Colors.green,
// // //                   foregroundColor: Colors.white,
// // //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                   shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(20),
// // //                   ),
// // //                 ),
// // //                 icon: const Icon(Icons.done_all, size: 16),
// // //                 label: const Text(
// // //                   "End Session",
// // //                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
// // //                 ),
// // //               ),
// // //             ),
// // //         ],
// // //         bottom: PreferredSize(
// // //           preferredSize: const Size.fromHeight(48.0),
// // //           child: Container(
// // //             color: AppColors.primary,
// // //             child: TabBar(
// // //               controller: _tabController,
// // //               indicatorColor: Colors.white,
// // //               labelColor: Colors.white,
// // //               unselectedLabelColor: Colors.white70,
// // //               tabs: const [
// // //                 Tab(
// // //                   icon: Icon(Icons.chat, size: 20),
// // //                   text: 'Chat',
// // //                 ),
// // //                 Tab(
// // //                   icon: Icon(Icons.attach_file, size: 20),
// // //                   text: 'Files',
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //       body: TabBarView(
// // //         controller: _tabController,
// // //         children: [
// // //           // Chat Tab
// // //           _buildChatTab(),
// // //
// // //           // Files Tab
// // //           _buildFilesTab(),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildChatTab() {
// // //     return Column(
// // //       children: [
// // //         // Order Info Card
// // //         Container(
// // //           width: double.infinity,
// // //           padding: const EdgeInsets.all(12),
// // //           margin: const EdgeInsets.all(8),
// // //           decoration: BoxDecoration(
// // //             color: Colors.white,
// // //             borderRadius: BorderRadius.circular(12),
// // //             boxShadow: [
// // //               BoxShadow(
// // //                 color: Colors.grey.withOpacity(0.2),
// // //                 blurRadius: 4,
// // //                 offset: const Offset(0, 2),
// // //               ),
// // //             ],
// // //           ),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Text(
// // //                 "Consultation Details",
// // //                 style: TextStyle(
// // //                   fontSize: 14,
// // //                   fontWeight: FontWeight.bold,
// // //                   color: AppColors.primary,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 8),
// // //               Row(
// // //                 children: [
// // //                   Icon(Icons.medical_services, size: 16, color: Colors.grey),
// // //                   const SizedBox(width: 8),
// // //                   Text("${widget.order.doctorType} - ${widget.order.speciality}"),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 4),
// // //               Row(
// // //                 children: [
// // //                   Icon(Icons.person, size: 16, color: Colors.grey),
// // //                   const SizedBox(width: 8),
// // //                   Text("Patient: ${widget.order.userName}"),
// // //                 ],
// // //               ),
// // //               // NEW: Upload Access Status
// // //               if (_hasUploadAccess)
// // //                 Container(
// // //                   margin: const EdgeInsets.only(top: 8),
// // //                   padding: const EdgeInsets.all(8),
// // //                   decoration: BoxDecoration(
// // //                     color: Colors.green.shade50,
// // //                     borderRadius: BorderRadius.circular(8),
// // //                     border: Border.all(color: Colors.green.shade200),
// // //                   ),
// // //                   child: Row(
// // //                     children: [
// // //                       Icon(Icons.check_circle, color: Colors.green.shade700, size: 16),
// // //                       const SizedBox(width: 8),
// // //                       Text(
// // //                         "Patient can upload additional reports",
// // //                         style: TextStyle(
// // //                           color: Colors.green.shade800,
// // //                           fontSize: 12,
// // //                           fontWeight: FontWeight.bold,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //             ],
// // //           ),
// // //         ),
// // //         Expanded(
// // //           child: messages.isEmpty
// // //               ? const Center(
// // //             child: Column(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               children: [
// // //                 Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
// // //                 SizedBox(height: 16),
// // //                 Text(
// // //                   "No messages yet",
// // //                   style: TextStyle(
// // //                     color: Colors.grey,
// // //                     fontSize: 16,
// // //                   ),
// // //                 ),
// // //                 Text(
// // //                   "Start the conversation with your patient",
// // //                   style: TextStyle(
// // //                     color: Colors.grey,
// // //                     fontSize: 12,
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           )
// // //               : ListView.builder(
// // //             controller: _scrollController,
// // //             padding: const EdgeInsets.all(10),
// // //             itemCount: messages.length,
// // //             itemBuilder: (context, index) {
// // //               return _buildMessageBubble(messages[index]);
// // //             },
// // //           ),
// // //         ),
// // //         if (!isReadOnly) _buildMessageInput(),
// // //         if (isReadOnly) _buildReadOnlyMessage(),
// // //       ],
// // //     );
// // //   }
// // //
// // //   Widget _buildFilesTab() {
// // //     return Column(
// // //       children: [
// // //         // Header with file count and refresh
// // //         Container(
// // //           padding: const EdgeInsets.all(16),
// // //           color: Colors.white,
// // //           child: Row(
// // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //             children: [
// // //               Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     "Medical Reports & Files",
// // //                     style: TextStyle(
// // //                       fontWeight: FontWeight.bold,
// // //                       fontSize: 16,
// // //                       color: AppColors.primary,
// // //                     ),
// // //                   ),
// // //                   Text(
// // //                     "${files.length} file(s) found",
// // //                     style: TextStyle(
// // //                       color: Colors.grey.shade600,
// // //                       fontSize: 12,
// // //                     ),
// // //                   ),
// // //                   // NEW: Upload Access Info in Files Tab
// // //                   if (_hasUploadAccess)
// // //                     Container(
// // //                       margin: const EdgeInsets.only(top: 4),
// // //                       child: Text(
// // //                         "Patient can upload more files",
// // //                         style: TextStyle(
// // //                           color: Colors.green.shade700,
// // //                           fontSize: 11,
// // //                           fontWeight: FontWeight.bold,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                 ],
// // //               ),
// // //               Row(
// // //                 children: [
// // //                   // NEW: Upload Access Button in Files Tab
// // //                   if (!isReadOnly && !_hasUploadAccess)
// // //                     Padding(
// // //                       padding: const EdgeInsets.only(right: 8.0),
// // //                       child: ElevatedButton.icon(
// // //                         onPressed: _isGrantingUploadAccess ? null : _grantUploadAccess,
// // //                         style: ElevatedButton.styleFrom(
// // //                           backgroundColor: Colors.orange,
// // //                           foregroundColor: Colors.white,
// // //                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                           shape: RoundedRectangleBorder(
// // //                             borderRadius: BorderRadius.circular(20),
// // //                           ),
// // //                         ),
// // //                         icon: _isGrantingUploadAccess
// // //                             ? const SizedBox(
// // //                           width: 16,
// // //                           height: 16,
// // //                           child: CircularProgressIndicator(
// // //                             strokeWidth: 2,
// // //                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// // //                           ),
// // //                         )
// // //                             : const Icon(Icons.upload_file, size: 16),
// // //                         label: _isGrantingUploadAccess
// // //                             ? const Text(
// // //                           "Granting...",
// // //                           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
// // //                         )
// // //                             : const Text(
// // //                           "Allow Upload",
// // //                           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   IconButton(
// // //                     icon: Icon(Icons.refresh, color: AppColors.primary),
// // //                     onPressed: _loadOrderFiles,
// // //                     tooltip: 'Refresh Files',
// // //                   ),
// // //                 ],
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //
// // //         // Debug info panel
// // //         if (files.isNotEmpty)
// // //           Container(
// // //             padding: const EdgeInsets.all(8),
// // //             margin: const EdgeInsets.symmetric(horizontal: 8),
// // //             decoration: BoxDecoration(
// // //               color: Colors.blue.shade50,
// // //               borderRadius: BorderRadius.circular(8),
// // //               border: Border.all(color: Colors.blue.shade100),
// // //             ),
// // //             child: Row(
// // //               children: [
// // //                 Icon(Icons.info, color: Colors.blue.shade600, size: 16),
// // //                 SizedBox(width: 8),
// // //                 Expanded(
// // //                   child: Text(
// // //                     'Files will be saved in /MediConnect folder in your device storage',
// // //                     style: TextStyle(
// // //                       color: Colors.blue.shade800,
// // //                       fontSize: 12,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //
// // //         // Files list
// // //         Expanded(
// // //           child: _buildFilesList(),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   Widget _buildFilesList() {
// // //     if (_isLoadingFiles) {
// // //       return const Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             CircularProgressIndicator(),
// // //             SizedBox(height: 16),
// // //             Text("Loading medical reports..."),
// // //           ],
// // //         ),
// // //       );
// // //     }
// // //
// // //     if (files.isEmpty) {
// // //       return Column(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         children: [
// // //           Icon(Icons.folder_open, size: 64, color: Colors.grey),
// // //           SizedBox(height: 16),
// // //           Text(
// // //             "No medical reports uploaded yet",
// // //             style: TextStyle(
// // //               color: Colors.grey,
// // //               fontSize: 16,
// // //             ),
// // //           ),
// // //           Text(
// // //             "Patient uploaded files will appear here",
// // //             style: TextStyle(
// // //               color: Colors.grey,
// // //               fontSize: 12,
// // //             ),
// // //           ),
// // //           // NEW: Upload Access Prompt
// // //           if (!isReadOnly && !_hasUploadAccess)
// // //             Container(
// // //               margin: const EdgeInsets.only(top: 20),
// // //               padding: const EdgeInsets.all(16),
// // //               child: Column(
// // //                 children: [
// // //                   Text(
// // //                     "Allow patient to upload medical reports",
// // //                     style: TextStyle(
// // //                       color: Colors.orange.shade700,
// // //                       fontSize: 14,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                     textAlign: TextAlign.center,
// // //                   ),
// // //                   SizedBox(height: 8),
// // //                   ElevatedButton.icon(
// // //                     onPressed: _isGrantingUploadAccess ? null : _grantUploadAccess,
// // //                     style: ElevatedButton.styleFrom(
// // //                       backgroundColor: Colors.orange,
// // //                       foregroundColor: Colors.white,
// // //                     ),
// // //                     icon: _isGrantingUploadAccess
// // //                         ? SizedBox(
// // //                       width: 16,
// // //                       height: 16,
// // //                       child: CircularProgressIndicator(
// // //                         strokeWidth: 2,
// // //                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// // //                       ),
// // //                     )
// // //                         : Icon(Icons.upload_file),
// // //                     label: _isGrantingUploadAccess
// // //                         ? Text("Granting Upload Access...")
// // //                         : Text("Grant Upload Access to Patient"),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //         ],
// // //       );
// // //     }
// // //
// // //     return RefreshIndicator(
// // //       onRefresh: _refreshFiles,
// // //       child: ListView.builder(
// // //         padding: const EdgeInsets.all(8),
// // //         itemCount: files.length,
// // //         itemBuilder: (context, index) {
// // //           final file = files[index];
// // //           if (file is Map<String, dynamic>) {
// // //             return _buildFileItem(file);
// // //           } else {
// // //             return Container(
// // //               margin: const EdgeInsets.symmetric(vertical: 4),
// // //               padding: const EdgeInsets.all(12),
// // //               decoration: BoxDecoration(
// // //                 color: Colors.white,
// // //                 borderRadius: BorderRadius.circular(8),
// // //                 border: Border.all(color: Colors.red),
// // //               ),
// // //               child: Text(
// // //                 'Invalid file format at index $index: ${file.toString()}',
// // //                 style: const TextStyle(color: Colors.red),
// // //               ),
// // //             );
// // //           }
// // //         },
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildMessageInput() {
// // //     return SafeArea(
// // //       child: Container(
// // //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// // //         decoration: BoxDecoration(
// // //           color: AppColors.primary,
// // //           boxShadow: [
// // //             BoxShadow(
// // //               color: Colors.grey.withOpacity(0.2),
// // //               blurRadius: 4,
// // //               offset: const Offset(0, -1),
// // //             ),
// // //           ],
// // //         ),
// // //         child: Row(
// // //           children: [
// // //             Expanded(
// // //               child: Container(
// // //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.white,
// // //                   borderRadius: BorderRadius.circular(21),
// // //                   boxShadow: [
// // //                     BoxShadow(
// // //                       color: Colors.grey.withOpacity(0.2),
// // //                       blurRadius: 4,
// // //                       offset: const Offset(0, 1),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 child: TextField(
// // //                   controller: _controller,
// // //                   keyboardType: TextInputType.multiline,
// // //                   textInputAction: TextInputAction.newline,
// // //                   minLines: 1,
// // //                   maxLines: 4,
// // //                   decoration: const InputDecoration.collapsed(
// // //                     hintText: "Type your message here",
// // //                   ),
// // //                   onChanged: (text) {
// // //                     WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
// // //                   },
// // //                 ),
// // //               ),
// // //             ),
// // //             const SizedBox(width: 8),
// // //             CircleAvatar(
// // //               backgroundColor: AppColors.textLight,
// // //               child: IconButton(
// // //                 icon: const Icon(Icons.send, color: AppColors.primary),
// // //                 onPressed: () => sendMessage(_controller.text),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildReadOnlyMessage() {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// // //       decoration: BoxDecoration(
// // //         color: Colors.grey,
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.grey.withOpacity(0.2),
// // //             blurRadius: 4,
// // //             offset: const Offset(0, -1),
// // //           ),
// // //         ],
// // //       ),
// // //       child: const Center(
// // //         child: Text(
// // //           "This order is completed - Chat history view only",
// // //           style: TextStyle(
// // //             color: Colors.white,
// // //             fontWeight: FontWeight.bold,
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// //
// //
// //
// //
// //
// // import 'dart:async';
// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'dart:math';
// // import 'order.dart';
// // import 'message.dart';
// // import 'helper.dart';
// // import 'package:flutter_downloader/flutter_downloader.dart';
// // import 'package:device_info_plus/device_info_plus.dart';
// // import 'package:open_filex/open_filex.dart';
// //
// // class OrderChatPage extends StatefulWidget {
// //   final Order order;
// //   final VoidCallback? onSessionEnded;
// //   final bool isReadOnly;
// //   final bool isDoctorView;
// //
// //   const OrderChatPage({
// //     super.key,
// //     required this.order,
// //     this.onSessionEnded,
// //     this.isReadOnly = false,
// //     this.isDoctorView = false,
// //   });
// //
// //   @override
// //   State<OrderChatPage> createState() => _OrderChatPageState();
// // }
// //
// // class _OrderChatPageState extends State<OrderChatPage> with SingleTickerProviderStateMixin {
// //   final TextEditingController _controller = TextEditingController();
// //   final ScrollController _scrollController = ScrollController();
// //   List<Message> messages = [];
// //   List<dynamic> files = [];
// //   bool _isLoadingFiles = false;
// //   late TabController _tabController;
// //   int _currentTabIndex = 0;
// //   bool _isDownloading = false;
// //   String _downloadingFileName = '';
// //
// //   // Upload access variables
// //   bool _isGrantingUploadAccess = false;
// //   bool _hasUploadAccess = false;
// //
// //   // Download tracking variables
// //   final Set<String> _downloadingTaskIds = {};
// //   final Map<String, double> _downloadProgress = {};
// //
// //   bool get isReadOnly => widget.isReadOnly || widget.order.status?.toLowerCase() == 'completed';
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     messages = widget.order.messages ?? [];
// //     files = widget.order.files ?? [];
// //
// //     _tabController = TabController(length: 2, vsync: this);
// //     _tabController.addListener(_handleTabChange);
// //
// //     // Initialize downloader callbacks
// //     _initializeDownloader();
// //
// //     // Check if upload access is already granted
// //     _checkUploadAccess();
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _scrollToBottom();
// //       _loadOrderFiles();
// //     });
// //   }
// //
// //   // Check if upload access is already granted
// //   void _checkUploadAccess() {
// //     // Check if there's any message indicating upload access was granted
// //     for (var message in messages) {
// //       if (message.text.toLowerCase().contains('upload access granted') ||
// //           message.text.toLowerCase().contains('can upload more reports')) {
// //         setState(() {
// //           _hasUploadAccess = true;
// //         });
// //         break;
// //       }
// //     }
// //   }
// //
// //   // Initialize downloader callbacks
// //   void _initializeDownloader() {
// //     FlutterDownloader.registerCallback((id, status, progress) {
// //       if (_downloadingTaskIds.contains(id)) {
// //         print('Download task $id: $status ($progress%)');
// //
// //         setState(() {
// //           _downloadProgress[id] = progress.toDouble();
// //         });
// //
// //         if (status == DownloadTaskStatus.complete) {
// //           _downloadingTaskIds.remove(id);
// //           _downloadProgress.remove(id);
// //           if (mounted) {
// //             Helpers.showSnackBar(
// //               context,
// //               'Download completed!',
// //               bgColor: Colors.green,
// //             );
// //           }
// //         } else if (status == DownloadTaskStatus.failed) {
// //           _downloadingTaskIds.remove(id);
// //           _downloadProgress.remove(id);
// //           if (mounted) {
// //             Helpers.showSnackBar(
// //               context,
// //               'Download failed!',
// //               bgColor: Colors.red,
// //             );
// //           }
// //         } else if (status == DownloadTaskStatus.canceled) {
// //           _downloadingTaskIds.remove(id);
// //           _downloadProgress.remove(id);
// //         }
// //       }
// //     });
// //   }
// //
// //   void _handleTabChange() {
// //     if (_tabController.index != _currentTabIndex) {
// //       setState(() {
// //         _currentTabIndex = _tabController.index;
// //       });
// //
// //       if (_tabController.index == 1) {
// //         print('🔄 Switched to Files tab, refreshing files...');
// //         _loadOrderFiles();
// //       }
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     // Cancel all ongoing downloads when the page is disposed
// //     for (String taskId in _downloadingTaskIds) {
// //       FlutterDownloader.cancel(taskId: taskId);
// //     }
// //     _downloadingTaskIds.clear();
// //     _downloadProgress.clear();
// //
// //     _tabController.dispose();
// //     super.dispose();
// //   }
// //
// //   void _scrollToBottom() {
// //     if (_scrollController.hasClients) {
// //       _scrollController.animateTo(
// //         _scrollController.position.maxScrollExtent,
// //         duration: const Duration(milliseconds: 300),
// //         curve: Curves.easeOut,
// //       );
// //     }
// //   }
// //
// //   // Grant upload access to patient
// //   Future<void> _grantUploadAccess() async {
// //     if (_isGrantingUploadAccess) return;
// //
// //     try {
// //       setState(() {
// //         _isGrantingUploadAccess = true;
// //       });
// //
// //       final prefs = await SharedPreferences.getInstance();
// //       final token = prefs.getString('token');
// //
// //       if (token == null) {
// //         Helpers.showSnackBar(context, 'Authentication required', bgColor: Colors.red);
// //         return;
// //       }
// //
// //       final String url = "${ApiConfig.baseUrl}/update-report-permission";
// //
// //       print('📤 Granting upload access for patient: ${widget.order.userId}');
// //
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Authorization': 'Bearer $token',
// //         },
// //         body: jsonEncode({
// //           'userId': widget.order.userId,
// //           'canSendReports': true,
// //         }),
// //       );
// //
// //       print('📥 Grant upload access response: ${response.statusCode}');
// //       print('📥 Response body: ${response.body}');
// //
// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         final data = jsonDecode(response.body);
// //
// //         if (data['success'] == true) {
// //           // Send a message to the chat about upload access
// //           await _sendUploadAccessMessage();
// //
// //           setState(() {
// //             _hasUploadAccess = true;
// //           });
// //
// //           Helpers.showSnackBar(
// //             context,
// //             'Upload access granted to patient!',
// //             bgColor: Colors.green,
// //           );
// //         } else {
// //           throw Exception(data['message'] ?? 'Failed to grant upload access');
// //         }
// //       } else {
// //         throw Exception('HTTP ${response.statusCode}: ${response.body}');
// //       }
// //     } catch (e) {
// //       print('❌ Grant upload access error: $e');
// //       Helpers.showSnackBar(
// //         context,
// //         'Failed to grant upload access: ${e.toString()}',
// //         bgColor: Colors.red,
// //       );
// //     } finally {
// //       setState(() {
// //         _isGrantingUploadAccess = false;
// //       });
// //     }
// //   }
// //
// //   // Send message about upload access
// //   Future<void> _sendUploadAccessMessage() async {
// //     try {
// //       final String url = "${ApiConfig.baseUrl}/sendMessageDoctor/${widget.order.orderId}";
// //
// //       final messageText = "📎 Upload Access Granted!\n\nThe patient can now upload additional medical reports for this consultation. They will see an upload button in their chat to add more files.";
// //
// //       final Map<String, dynamic> requestBody = {
// //         'text': messageText,
// //         'isBot': false,
// //         'userName': 'Doctor',
// //         'userId': 'doctor',
// //         'patientUserId': widget.order.userId,
// //         'patientUserName': widget.order.userName,
// //         'isSystemMessage': true,
// //       };
// //
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode(requestBody),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body)['data'];
// //         setState(() {
// //           messages.add(Message.fromMap(data));
// //         });
// //         _scrollToBottom();
// //       }
// //     } catch (e) {
// //       print('❌ Error sending upload access message: $e');
// //     }
// //   }
// //
// //   Future<void> _loadOrderFiles() async {
// //     if (_isLoadingFiles) return;
// //
// //     try {
// //       setState(() {
// //         _isLoadingFiles = true;
// //       });
// //
// //       if (widget.order.files != null && widget.order.files!.isNotEmpty) {
// //         print('🔄 Using files from order object (passed from HomePage)');
// //         setState(() {
// //           files = widget.order.files!;
// //         });
// //         print('✅ Loaded ${files.length} files from order object');
// //         return;
// //       }
// //
// //       print('ℹ No files in order object, trying API...');
// //
// //       final prefs = await SharedPreferences.getInstance();
// //       final token = prefs.getString('token');
// //       final doctorId = prefs.getString('doctorId');
// //       final doctorType = prefs.getString('doctorType');
// //
// //       if (token == null || token.isEmpty) {
// //         print('❌ No token available for loading files');
// //         return;
// //       }
// //
// //       if (doctorId == null || doctorType == null) {
// //         print('❌ Doctor information not available');
// //         return;
// //       }
// //
// //       print('🔐 Using token: ${token.substring(0, min(20, token.length))}...');
// //       print('👨‍⚕ Doctor: $doctorId, Type: $doctorType');
// //
// //       final String url = "${ApiConfig.baseUrl}/getOrders?doctorType=$doctorType&doctorId=$doctorId";
// //       print('📤 Loading files from: $url');
// //
// //       final response = await http.get(
// //         Uri.parse(url),
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Authorization': 'Bearer $token',
// //         },
// //       );
// //
// //       print('📥 Files API Response Status: ${response.statusCode}');
// //
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         print('📦 Files API Response Body: ${jsonEncode(decoded)}');
// //
// //         if (decoded['success'] == true) {
// //           List<dynamic> allOrdersData = [];
// //
// //           if (decoded['data'] is Map && decoded['data']['orders'] != null) {
// //             allOrdersData = decoded['data']['orders'];
// //           } else if (decoded['data'] is List) {
// //             allOrdersData = decoded['data'];
// //           } else if (decoded['orders'] is List) {
// //             allOrdersData = decoded['orders'];
// //           }
// //
// //           print('🔍 Searching for order: ${widget.order.orderId} in ${allOrdersData.length} orders');
// //
// //           Map<String, dynamic>? currentOrderData;
// //           for (var order in allOrdersData) {
// //             if (order is Map<String, dynamic>) {
// //               final orderId = order['orderId']?.toString() ?? order['_id']?.toString();
// //               if (orderId == widget.order.orderId) {
// //                 currentOrderData = order;
// //                 break;
// //               }
// //             }
// //           }
// //
// //           if (currentOrderData != null) {
// //             print('✅ Found current order data');
// //
// //             List<dynamic> allFiles = _extractFilesFromOrderData(currentOrderData);
// //
// //             print('✅ Extracted ${allFiles.length} files for order ${widget.order.orderId}');
// //
// //             for (int i = 0; i < allFiles.length; i++) {
// //               final file = allFiles[i];
// //               if (file is Map<String, dynamic>) {
// //                 print('📄 File $i: ${file['fileName']}');
// //                 print('   - fileType: ${file['fileType']}');
// //                 print('   - uploadedBy: ${file['uploadedBy']}');
// //                 print('   - filePath: ${file['filePath']}');
// //                 print('   - downloadUrl: ${file['downloadUrl']}');
// //               }
// //             }
// //
// //             setState(() {
// //               files = allFiles;
// //             });
// //
// //             print('✅ UI Updated with ${files.length} files');
// //           } else {
// //             print('❌ Order ${widget.order.orderId} not found in response');
// //           }
// //         } else {
// //           print('❌ API returned success: false');
// //           print('❌ Message: ${decoded['message']}');
// //         }
// //       } else {
// //         print('❌ Failed to load files: ${response.statusCode}');
// //         print('❌ Response body: ${response.body}');
// //       }
// //     } catch (e, stackTrace) {
// //       print('❌ Error loading files: $e');
// //       print('❌ Stack trace: $stackTrace');
// //     } finally {
// //       setState(() {
// //         _isLoadingFiles = false;
// //       });
// //     }
// //   }
// //
// //   List<dynamic> _extractFilesFromOrderData(Map<String, dynamic> orderData) {
// //     List<dynamic> allFiles = [];
// //
// //     try {
// //       print('🔍 Extracting files from order data structure...');
// //
// //       // Method 1: Extract from reports.files.all (main location)
// //       if (orderData['reports'] != null && orderData['reports'] is Map<String, dynamic>) {
// //         final reports = orderData['reports'] as Map<String, dynamic>;
// //
// //         if (reports['files'] != null && reports['files'] is Map<String, dynamic>) {
// //           final filesMap = reports['files'] as Map<String, dynamic>;
// //
// //           // Get files from 'all' array
// //           if (filesMap['all'] != null && filesMap['all'] is List) {
// //             final allFilesList = filesMap['all'] as List<dynamic>;
// //             print('✅ Found ${allFilesList.length} files in reports.files.all');
// //
// //             for (var file in allFilesList) {
// //               if (file is Map<String, dynamic>) {
// //                 // Ensure file has all required fields and normalize filePath
// //                 final normalizedFile = _normalizeFileData(file);
// //                 if (normalizedFile != null) {
// //                   allFiles.add(normalizedFile);
// //                 }
// //               }
// //             }
// //           }
// //         }
// //       }
// //
// //       // Method 2: Extract from messages with attachedFiles
// //       if (orderData['messages'] != null && orderData['messages'] is List) {
// //         final messages = orderData['messages'] as List<dynamic>;
// //         for (var message in messages) {
// //           if (message is Map<String, dynamic> &&
// //               message['attachedFiles'] != null &&
// //               message['attachedFiles'] is List) {
// //             final attachedFiles = message['attachedFiles'] as List<dynamic>;
// //             for (var file in attachedFiles) {
// //               if (file is Map<String, dynamic>) {
// //                 // Create a file object from message attachment
// //                 final fileFromMessage = {
// //                   'fileName': file['fileName'],
// //                   'filePath': file['filePath'],
// //                   'fileType': _getFileTypeFromFileName(file['fileName']),
// //                   'fileSize': 0, // Size might not be available in messages
// //                   'uploadedBy': 'patient', // Assuming from message context
// //                   'category': file['category'] ?? 'Uncategorized',
// //                   'source': 'messages',
// //                   'messageText': message['text'],
// //                   'messageCreatedAt': message['createdAt'],
// //                 };
// //                 final normalizedFile = _normalizeFileData(fileFromMessage);
// //                 if (normalizedFile != null) {
// //                   allFiles.add(normalizedFile);
// //                 }
// //               }
// //             }
// //           }
// //         }
// //       }
// //
// //       print('✅ Total normalized files extracted: ${allFiles.length}');
// //
// //       // Log all extracted files for debugging
// //       for (int i = 0; i < allFiles.length; i++) {
// //         final file = allFiles[i];
// //         if (file is Map<String, dynamic>) {
// //           print('📄 File $i: ${file['fileName']}');
// //           print('   - filePath: ${file['filePath']}');
// //           print('   - downloadUrl: ${file['downloadUrl']}');
// //           print('   - fileSize: ${file['fileSize']}');
// //           print('   - uploadedBy: ${file['uploadedBy']}');
// //         }
// //       }
// //
// //       return allFiles;
// //
// //     } catch (e) {
// //       print('❌ Error extracting files: $e');
// //       return allFiles;
// //     }
// //   }
// //
// //   String getFileTypeFromFileName(String fileName) {
// //     final extension = fileName.toLowerCase().split('.').last;
// //     switch (extension) {
// //       case 'pdf':
// //         return 'application/pdf';
// //       case 'jpg':
// //       case 'jpeg':
// //         return 'image/jpeg';
// //       case 'png':
// //         return 'image/png';
// //       case 'doc':
// //       case 'docx':
// //         return 'application/msword';
// //       case 'xls':
// //       case 'xlsx':
// //         return 'application/vnd.ms-excel';
// //       default:
// //         return 'application/octet-stream';
// //     }
// //   }
// //
// //   Map<String, dynamic>? _normalizeFileData(Map<String, dynamic> file) {
// //     try {
// //       final fileName = file['fileName']?.toString();
// //       if (fileName == null || fileName.isEmpty) {
// //         print('⚠ Skipping file with no fileName: $file');
// //         return null;
// //       }
// //
// //       String filePath = file['filePath']?.toString() ?? '';
// //
// //       // Normalize file path - replace backslashes with forward slashes
// //       if (filePath.isNotEmpty) {
// //         filePath = filePath.replaceAll('\\', '/');
// //         print('📝 Normalized file path: $filePath');
// //       }
// //
// //       // Create download URL using the dedicated base FILE URL
// //       String downloadUrl;
// //       if (filePath.startsWith('http')) {
// //         // If the path is already a full URL, use it as is
// //         downloadUrl = filePath;
// //       } else if (filePath.isNotEmpty) {
// //         // Construct the URL from the base FILE URL and the relative path
// //         // Ensure there's no double slash
// //         final String base = ApiConfig.baseFileUrl.endsWith('/')
// //             ? ApiConfig.baseFileUrl.substring(0, ApiConfig.baseFileUrl.length - 1)
// //             : ApiConfig.baseFileUrl;
// //         final String path = filePath.startsWith('/') ? filePath : '/$filePath';
// //
// //         downloadUrl = '$base$path';
// //         print('🔗 CORRECTLY Constructed download URL: $downloadUrl');
// //       } else {
// //         print('⚠ No filePath available for: $fileName');
// //         return null;
// //       }
// //
// //       final fileType = file['fileType']?.toString() ?? getFileTypeFromFileName(fileName) ?? 'application/octet-stream';
// //
// //       return {
// //         'fileName': fileName,
// //         'filePath': filePath,
// //         'downloadUrl': downloadUrl,
// //         'fileType': fileType,
// //         'fileSize': (file['fileSize'] is int)
// //             ? file['fileSize']
// //             : (file['fileSize'] is String)
// //             ? int.tryParse(file['fileSize']) ?? 0
// //             : 0,
// //         'uploadedBy': file['uploadedBy']?.toString() ?? 'unknown',
// //         'category': file['category']?.toString() ?? 'Uncategorized',
// //         'source': file['source']?.toString() ?? 'reports',
// //         'uploadDate': file['uploadDate']?.toString() ?? DateTime.now().toIso8601String(),
// //         'originalData': file,
// //       };
// //     } catch (e) {
// //       print('❌ Error normalizing file data: $e');
// //       return null;
// //     }
// //   }
// //
// //   String _getFileTypeFromFileName(String fileName) {
// //     final extension = fileName.toLowerCase().split('.').last;
// //     switch (extension) {
// //       case 'pdf':
// //         return 'application/pdf';
// //       case 'jpg':
// //       case 'jpeg':
// //         return 'image/jpeg';
// //       case 'png':
// //         return 'image/png';
// //       case 'doc':
// //       case 'docx':
// //         return 'application/msword';
// //       case 'xls':
// //       case 'xlsx':
// //         return 'application/vnd.ms-excel';
// //       default:
// //         return 'application/octet-stream';
// //     }
// //   }
// //
// //   Future<void> _downloadFile(Map<String, dynamic> file) async {
// //     final fileName = file['fileName']?.toString() ?? 'Unknown File';
// //     String? downloadUrl = file['downloadUrl']?.toString();
// //     final filePath = file['filePath']?.toString();
// //
// //     print('📥 Starting download for: $fileName');
// //     print('🔗 Initial Download URL: $downloadUrl');
// //     print('📁 File path: $filePath');
// //
// //     // Fallback: If downloadUrl is still null but we have a filePath, try to construct it one last time
// //     if ((downloadUrl == null || downloadUrl.isEmpty) && filePath != null && filePath.isNotEmpty) {
// //       print('🔄 Download URL is null, attempting to construct from file path as a last resort');
// //
// //       String normalizedPath = filePath.replaceAll('\\', '/');
// //
// //       // USE THE CORRECT BASE FILE URL HERE
// //       final String base = ApiConfig.baseFileUrl.endsWith('/')
// //           ? ApiConfig.baseFileUrl.substring(0, ApiConfig.baseFileUrl.length - 1)
// //           : ApiConfig.baseFileUrl;
// //       final String path = normalizedPath.startsWith('/') ? normalizedPath : '/$normalizedPath';
// //
// //       downloadUrl = '$base$path';
// //       print('🔗 CORRECT Fallback constructed download URL: $downloadUrl');
// //     }
// //
// //     if (downloadUrl == null || downloadUrl.isEmpty) {
// //       print('❌ No download URL could be determined for $fileName');
// //       Helpers.showSnackBar(context, 'Download URL not available for $fileName', bgColor: Colors.red);
// //       return;
// //     }
// //
// //     try {
// //       setState(() {
// //         _isDownloading = true;
// //         _downloadingFileName = fileName;
// //       });
// //
// //       Helpers.showSnackBar(context, 'Starting download for $fileName...', bgColor: Colors.blue);
// //
// //       await _enhancedFallbackDownload(downloadUrl, fileName);
// //
// //     } catch (e) {
// //       print('❌ Download error: $e');
// //       Helpers.showSnackBar(
// //         context,
// //         'Download failed: ${e.toString()}',
// //         bgColor: Colors.red,
// //       );
// //     } finally {
// //       setState(() {
// //         _isDownloading = false;
// //         _downloadingFileName = '';
// //       });
// //     }
// //   }
// //
// //   Future<void> _enhancedFallbackDownload(String url, String fileName) async {
// //     try {
// //       print('🔄 Using enhanced fallback download for: $fileName');
// //       print('🔗 URL: $url');
// //
// //       final prefs = await SharedPreferences.getInstance();
// //       final token = prefs.getString('token');
// //
// //       // Create HTTP client
// //       final client = http.Client();
// //
// //       // Make the request
// //       final response = await client.get(
// //         Uri.parse(url),
// //         headers: {
// //           if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
// //           'Accept': '/',
// //         },
// //       );
// //
// //       print('📥 Response status: ${response.statusCode}');
// //       print('📥 Content length: ${response.contentLength}');
// //
// //       if (response.statusCode == 200) {
// //         // Get a reliable directory
// //         final directory = await _getReliableDownloadDirectory();
// //         final String savePath = '${directory.path}/MediConnect';
// //         final Directory saveDir = Directory(savePath);
// //
// //         if (!await saveDir.exists()) {
// //           await saveDir.create(recursive: true);
// //           print('📁 Created directory: $savePath');
// //         }
// //
// //         // Clean filename
// //         final cleanFileName = _cleanFileName(fileName);
// //         final File file = File('$savePath/$cleanFileName');
// //
// //         // Write file
// //         await file.writeAsBytes(response.bodyBytes);
// //
// //         final fileSize = await file.length();
// //         print('✅ Download successful: ${file.path}');
// //         print('📊 File size: $fileSize bytes');
// //
// //         // Verify file exists and has content
// //         if (await file.exists() && fileSize > 0) {
// //           if (mounted) {
// //             Helpers.showSnackBar(
// //               context,
// //               'Download completed: $fileName',
// //               bgColor: Colors.green,
// //             );
// //           }
// //
// //           // Try to open the file
// //           try {
// //             final openResult = await OpenFilex.open(file.path);
// //             print('📂 Open file result: ${openResult.type}');
// //             print('📂 Open file message: ${openResult.message}');
// //
// //             if (openResult.type != ResultType.done) {
// //               if (mounted) {
// //                 Helpers.showSnackBar(
// //                   context,
// //                   'File downloaded to MediConnect folder',
// //                   bgColor: Colors.blue,
// //                 );
// //               }
// //             }
// //           } catch (e) {
// //             print('⚠ Cannot open file automatically: $e');
// //             if (mounted) {
// //               Helpers.showSnackBar(
// //                 context,
// //                 'File downloaded to MediConnect folder',
// //                 bgColor: Colors.green,
// //               );
// //             }
// //           }
// //
// //           // Show file location
// //           print('📍 File saved at: ${file.path}');
// //
// //         } else {
// //           throw Exception('File was written but is empty or cannot be accessed');
// //         }
// //       } else {
// //         throw Exception('HTTP ${response.statusCode} - ${response.reasonPhrase}');
// //       }
// //
// //       client.close();
// //     } catch (e) {
// //       print('❌ Enhanced fallback download failed: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   Future<Directory> _getReliableDownloadDirectory() async {
// //     try {
// //       // For Android 10+, use scoped storage - app-specific directory
// //       if (Platform.isAndroid) {
// //         // Try external storage first (visible in file managers)
// //         final externalDir = await getExternalStorageDirectory();
// //         if (externalDir != null) {
// //           return externalDir;
// //         }
// //       }
// //
// //       // Fallback to application documents directory
// //       return await getApplicationDocumentsDirectory();
// //     } catch (e) {
// //       print('⚠ Error getting directory: $e');
// //       return await getApplicationDocumentsDirectory();
// //     }
// //   }
// //
// //   String _cleanFileName(String fileName) {
// //     // Remove invalid characters for file names
// //     // We will explicitly replace each character to avoid regex issues
// //     String cleaned = fileName
// //         .replaceAll('<', '_')
// //         .replaceAll('>', '_')
// //         .replaceAll(':', '_')
// //         .replaceAll('"', '_')
// //         .replaceAll('/', '_')
// //         .replaceAll('\\', '_')
// //         .replaceAll('|', '_')
// //         .replaceAll('?', '_')
// //         .replaceAll('*', '_');
// //
// //     // Replace multiple spaces with single underscore
// //     cleaned = cleaned.replaceAll(RegExp(r'\s+'), '_');
// //
// //     // Remove leading/trailing spaces and underscores
// //     cleaned = cleaned.trim().replaceAll(RegExp(r'^_+|_+$'), '');
// //
// //     // If filename is empty after cleaning, use a default name
// //     if (cleaned.isEmpty) {
// //       cleaned = 'downloaded_file_${DateTime.now().millisecondsSinceEpoch}';
// //     }
// //
// //     return cleaned;
// //   }
// //
// //   // Send message
// //   Future<void> sendMessage(String text) async {
// //     if (text.trim().isEmpty) return;
// //     if (isReadOnly) {
// //       Helpers.showSnackBar(context, 'Cannot send messages in completed order', bgColor: Colors.orange);
// //       return;
// //     }
// //
// //     try {
// //       final String url = "${ApiConfig.baseUrl}/sendMessageDoctor/${widget.order.orderId}";
// //       final Map<String, dynamic> requestBody = {
// //         'text': text,
// //         'isBot': false,
// //         'userName': 'Doctor',
// //         'userId': 'doctor',
// //         'patientUserId': widget.order.userId,
// //         'patientUserName': widget.order.userName,
// //       };
// //
// //       print('📤 Sending message to: $url');
// //       print('📦 Request body: $requestBody');
// //
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode(requestBody),
// //       );
// //
// //       print('📥 Response status: ${response.statusCode}');
// //       print('📥 Response body: ${response.body}');
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body)['data'];
// //         setState(() {
// //           messages.add(Message.fromMap(data));
// //         });
// //         _controller.clear();
// //         _scrollToBottom();
// //       } else {
// //         final errorBody = jsonDecode(response.body);
// //         final errorMessage = errorBody['message'] ?? 'Failed to send message';
// //         Helpers.showSnackBar(context, 'Error: $errorMessage', bgColor: Colors.red);
// //       }
// //     } catch (e) {
// //       print('❌ sendMessage error: $e');
// //       Helpers.showSnackBar(context, 'Network error: $e', bgColor: Colors.red);
// //     }
// //   }
// //
// //   // End Session
// //   Future<void> _endSession() async {
// //     if (isReadOnly) {
// //       Helpers.showSnackBar(context, 'This order is already completed', bgColor: Colors.orange);
// //       return;
// //     }
// //
// //     bool confirmEnd = await showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text("End Session"),
// //           content: const Text("Are you sure you want to end this session? This will complete the order and reset the chat for the patient."),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.of(context).pop(false),
// //               child: const Text("Cancel"),
// //             ),
// //             ElevatedButton(
// //               onPressed: () => Navigator.of(context).pop(true),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.green,
// //               ),
// //               child: const Text("End Session", style: TextStyle(color: Colors.white)),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //
// //     if (confirmEnd != true) return;
// //
// //     try {
// //       final String url = "${ApiConfig.baseUrl}/completeOrder/${widget.order.orderId}";
// //
// //       print('🚀 Ending session for order: ${widget.order.orderId}');
// //
// //       final requestBody = {
// //         'status': 'completed',
// //         'completedAt': DateTime.now().toIso8601String(),
// //         'completedBy': 'Doctor',
// //         'resetChat': true,
// //       };
// //
// //       final response = await http.put(
// //         Uri.parse(url),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode(requestBody),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final responseData = jsonDecode(response.body);
// //
// //         if (responseData['success'] == true) {
// //           Helpers.showSnackBar(
// //             context,
// //             'Session ended successfully! Order completed and chat reset.',
// //             bgColor: Colors.green,
// //           );
// //
// //           if (widget.onSessionEnded != null) {
// //             widget.onSessionEnded!();
// //           }
// //
// //           Navigator.of(context).pop(true);
// //         } else {
// //           throw Exception(responseData['message'] ?? 'Failed to complete order');
// //         }
// //       } else {
// //         throw Exception('HTTP ${response.statusCode}: ${response.body}');
// //       }
// //     } catch (e) {
// //       print('❌ End session error: $e');
// //       Helpers.showSnackBar(
// //         context,
// //         'Failed to end session: ${e.toString()}',
// //         bgColor: Colors.red,
// //       );
// //     }
// //   }
// //
// //   // Build file item widget
// //   Widget _buildFileItem(Map<String, dynamic> file) {
// //     final fileName = file['fileName']?.toString() ?? 'Unknown File';
// //     final fileSize = file['fileSize'] ?? 0;
// //     final fileType = file['fileType']?.toString() ?? 'file';
// //     final uploadedBy = file['uploadedBy']?.toString() ?? 'Unknown';
// //     final category = file['category']?.toString() ?? 'Uncategorized';
// //     final uploadDate = file['uploadDate'] != null
// //         ? DateTime.tryParse(file['uploadDate'])?.toLocal() ?? DateTime.now()
// //         : DateTime.now();
// //
// //     // Check if this file is currently downloading
// //     bool isDownloadingThisFile = _isDownloading && _downloadingFileName == fileName;
// //
// //     return Container(
// //       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: Colors.grey.shade300),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 4,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               color: AppColors.primary.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Icon(
// //               _getFileIcon(fileType),
// //               color: AppColors.primary,
// //               size: 24,
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   fileName,
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 14,
// //                   ),
// //                   maxLines: 2,
// //                   overflow: TextOverflow.ellipsis,
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(
// //                   'Category: $category',
// //                   style: TextStyle(
// //                     color: Colors.grey.shade600,
// //                     fontSize: 12,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Row(
// //                   children: [
// //                     Text(
// //                       _formatFileSize(fileSize is int ? fileSize : 0),
// //                       style: TextStyle(
// //                         color: Colors.grey.shade600,
// //                         fontSize: 12,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Container(
// //                       width: 4,
// //                       height: 4,
// //                       decoration: BoxDecoration(
// //                         color: Colors.grey.shade400,
// //                         shape: BoxShape.circle,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Text(
// //                       fileType.split('/').last.toUpperCase(),
// //                       style: TextStyle(
// //                         color: Colors.grey.shade600,
// //                         fontSize: 12,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Row(
// //                   children: [
// //                     Icon(
// //                       uploadedBy == 'patient' ? Icons.person : Icons.medical_services,
// //                       size: 12,
// //                       color: Colors.grey.shade600,
// //                     ),
// //                     const SizedBox(width: 4),
// //                     Text(
// //                       'Uploaded by ${uploadedBy == 'patient' ? 'Patient' : 'Doctor'}',
// //                       style: TextStyle(
// //                         color: Colors.grey.shade600,
// //                         fontSize: 11,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Text(
// //                       '${uploadDate.day}/${uploadDate.month}/${uploadDate.year}',
// //                       style: TextStyle(
// //                         color: Colors.grey.shade600,
// //                         fontSize: 11,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 if (isDownloadingThisFile) ...[
// //                   const SizedBox(height: 8),
// //                   LinearProgressIndicator(
// //                     backgroundColor: Colors.grey.shade300,
// //                     valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     'Downloading...',
// //                     style: const TextStyle(
// //                       color: Colors.blue,
// //                       fontSize: 10,
// //                     ),
// //                   ),
// //                 ],
// //               ],
// //             ),
// //           ),
// //           if (isDownloadingThisFile)
// //             const Padding(
// //               padding: EdgeInsets.all(8.0),
// //               child: SizedBox(
// //                 width: 24,
// //                 height: 24,
// //                 child: CircularProgressIndicator(strokeWidth: 2),
// //               ),
// //             )
// //           else
// //             IconButton(
// //               icon: Icon(
// //                 Icons.download,
// //                 color: AppColors.primary,
// //               ),
// //               onPressed: () => _downloadFile(file),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // Helper methods for file display
// //   IconData _getFileIcon(String fileType) {
// //     if (fileType.toLowerCase().contains('image')) return Icons.image;
// //     if (fileType.toLowerCase().contains('pdf')) return Icons.picture_as_pdf;
// //     if (fileType.toLowerCase().contains('word') || fileType.toLowerCase().contains('document'))
// //       return Icons.description;
// //     return Icons.insert_drive_file;
// //   }
// //
// //   String _formatFileSize(int bytes) {
// //     if (bytes < 1024) return '$bytes B';
// //     if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
// //     return '${(bytes / 1048576).toStringAsFixed(1)} MB';
// //   }
// //
// //   // Build message bubble
// //   Widget _buildMessageBubble(Message msg) {
// //     final isDoctor = msg.userName == "Doctor";
// //     final alignment = isDoctor ? Alignment.centerRight : Alignment.centerLeft;
// //     final bgColor = isDoctor
// //         ? AppColors.textLight.withOpacity(0.9)
// //         : AppColors.primary.withOpacity(0.9);
// //     final textColor = isDoctor ? Colors.black87 : Colors.white;
// //
// //     return Container(
// //       alignment: alignment,
// //       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// //       child: Container(
// //         padding: const EdgeInsets.all(12),
// //         constraints: const BoxConstraints(maxWidth: 280),
// //         decoration: BoxDecoration(
// //           color: bgColor,
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: isDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               msg.text,
// //               style: TextStyle(color: textColor, fontSize: 15),
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               "${msg.createdAt?.hour.toString().padLeft(2, '0')}:${msg.createdAt?.minute.toString().padLeft(2, '0')}",
// //               style: TextStyle(
// //                 color: textColor.withOpacity(0.7),
// //                 fontSize: 10,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<void> _refreshFiles() async {
// //     print('🔄 Manually refreshing files...');
// //     await _loadOrderFiles();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey[100],
// //       appBar: AppBar(
// //         backgroundColor: isReadOnly ? Colors.grey : AppColors.primary,
// //         iconTheme: const IconThemeData(color: Colors.white),
// //         toolbarHeight: 75,
// //         title: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               widget.order.userName,
// //               style: const TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             if (isReadOnly)
// //               const Text(
// //                 "COMPLETED - VIEW ONLY",
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 10,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //           ],
// //         ),
// //
// //         actions: [
// //           // Upload Access Button - Only in AppBar (Chat section)
// //           if (!isReadOnly && !_hasUploadAccess)
// //             Padding(
// //               padding: const EdgeInsets.only(right: 8.0),
// //               child: ElevatedButton.icon(
// //                 onPressed: _isGrantingUploadAccess ? null : _grantUploadAccess,
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.orange,
// //                   foregroundColor: Colors.white,
// //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                 ),
// //                 icon: _isGrantingUploadAccess
// //                     ? const SizedBox(
// //                   width: 16,
// //                   height: 16,
// //                   child: CircularProgressIndicator(
// //                     strokeWidth: 2,
// //                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// //                   ),
// //                 )
// //                     : const Icon(Icons.upload_file, size: 16),
// //                 label: _isGrantingUploadAccess
// //                     ? const Text(
// //                   "Granting...",
// //                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
// //                 )
// //                     : const Text(
// //                   "Allow Upload",
// //                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
// //                 ),
// //               ),
// //             ),
// //           if (!isReadOnly)
// //             Padding(
// //               padding: const EdgeInsets.only(right: 11.0),
// //               child: ElevatedButton.icon(
// //                 onPressed: _endSession,
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.green,
// //                   foregroundColor: Colors.white,
// //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                 ),
// //                 icon: const Icon(Icons.done_all, size: 16),
// //                 label: const Text(
// //                   "End Session",
// //                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
// //                 ),
// //               ),
// //             ),
// //         ],
// //         bottom: PreferredSize(
// //           preferredSize: const Size.fromHeight(48.0),
// //           child: Container(
// //             color: AppColors.primary,
// //             child: TabBar(
// //               controller: _tabController,
// //               indicatorColor: Colors.white,
// //               labelColor: Colors.white,
// //               unselectedLabelColor: Colors.white70,
// //               tabs: const [
// //                 Tab(
// //                   icon: Icon(Icons.chat, size: 20),
// //                   text: 'Chat',
// //                 ),
// //                 Tab(
// //                   icon: Icon(Icons.attach_file, size: 20),
// //                   text: 'Files',
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //       body: TabBarView(
// //         controller: _tabController,
// //         children: [
// //           // Chat Tab
// //           _buildChatTab(),
// //
// //           // Files Tab
// //           _buildFilesTab(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildChatTab() {
// //     return Column(
// //       children: [
// //         // Order Info Card with Upload Access Button
// //         Container(
// //           width: double.infinity,
// //           padding: const EdgeInsets.all(12),
// //           margin: const EdgeInsets.all(8),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(12),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.grey.withOpacity(0.2),
// //                 blurRadius: 4,
// //                 offset: const Offset(0, 2),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text(
// //                     "Consultation Details",
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.bold,
// //                       color: AppColors.primary,
// //                     ),
// //                   ),
// //                   // Upload Access Button in the card
// //                   if (!isReadOnly && !_hasUploadAccess)
// //                     ElevatedButton.icon(
// //                       onPressed: _isGrantingUploadAccess ? null : _grantUploadAccess,
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.orange,
// //                         foregroundColor: Colors.white,
// //                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(20),
// //                         ),
// //                       ),
// //                       icon: _isGrantingUploadAccess
// //                           ? const SizedBox(
// //                         width: 16,
// //                         height: 16,
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// //                         ),
// //                       )
// //                           : const Icon(Icons.upload_file, size: 16),
// //                       label: _isGrantingUploadAccess
// //                           ? const Text(
// //                         "Granting...",
// //                         style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
// //                       )
// //                           : const Text(
// //                         "Allow Upload",
// //                         style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
// //                 ],
// //               ),
// //               const SizedBox(height: 8),
// //               Row(
// //                 children: [
// //                   Icon(Icons.medical_services, size: 16, color: Colors.grey),
// //                   const SizedBox(width: 8),
// //                   Text("${widget.order.doctorType} - ${widget.order.speciality}"),
// //                 ],
// //               ),
// //               const SizedBox(height: 4),
// //               Row(
// //                 children: [
// //                   Icon(Icons.person, size: 16, color: Colors.grey),
// //                   const SizedBox(width: 8),
// //                   Text("Patient: ${widget.order.userName}"),
// //                 ],
// //               ),
// //               // Upload Access Status
// //               if (_hasUploadAccess)
// //                 Container(
// //                   margin: const EdgeInsets.only(top: 8),
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                     color: Colors.green.shade50,
// //                     borderRadius: BorderRadius.circular(8),
// //                     border: Border.all(color: Colors.green.shade200),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Icon(Icons.check_circle, color: Colors.green.shade700, size: 16),
// //                       const SizedBox(width: 8),
// //                       Text(
// //                         "Patient can upload additional reports",
// //                         style: TextStyle(
// //                           color: Colors.green.shade800,
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //             ],
// //           ),
// //         ),
// //         Expanded(
// //           child: messages.isEmpty
// //               ? const Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
// //                 SizedBox(height: 16),
// //                 Text(
// //                   "No messages yet",
// //                   style: TextStyle(
// //                     color: Colors.grey,
// //                     fontSize: 16,
// //                   ),
// //                 ),
// //                 Text(
// //                   "Start the conversation with your patient",
// //                   style: TextStyle(
// //                     color: Colors.grey,
// //                     fontSize: 12,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           )
// //               : ListView.builder(
// //             controller: _scrollController,
// //             padding: const EdgeInsets.all(10),
// //             itemCount: messages.length,
// //             itemBuilder: (context, index) {
// //               return _buildMessageBubble(messages[index]);
// //             },
// //           ),
// //         ),
// //         if (!isReadOnly) _buildMessageInput(),
// //         if (isReadOnly) _buildReadOnlyMessage(),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildFilesTab() {
// //     return Column(
// //       children: [
// //         // Header with file count and refresh
// //         Container(
// //           padding: const EdgeInsets.all(16),
// //           color: Colors.white,
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     "Medical Reports & Files",
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 16,
// //                       color: AppColors.primary,
// //                     ),
// //                   ),
// //                   Text(
// //                     "${files.length} file(s) found",
// //                     style: TextStyle(
// //                       color: Colors.grey.shade600,
// //                       fontSize: 12,
// //                     ),
// //                   ),
// //                   // Upload Access Info in Files Tab
// //                   if (_hasUploadAccess)
// //                     Container(
// //                       margin: const EdgeInsets.only(top: 4),
// //                       child: Text(
// //                         "Patient can upload more files",
// //                         style: TextStyle(
// //                           color: Colors.green.shade700,
// //                           fontSize: 11,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ),
// //                 ],
// //               ),
// //               IconButton(
// //                 icon: Icon(Icons.refresh, color: AppColors.primary),
// //                 onPressed: _loadOrderFiles,
// //                 tooltip: 'Refresh Files',
// //               ),
// //             ],
// //           ),
// //         ),
// //
// //         // Debug info panel
// //         if (files.isNotEmpty)
// //           Container(
// //             padding: const EdgeInsets.all(8),
// //             margin: const EdgeInsets.symmetric(horizontal: 8),
// //             decoration: BoxDecoration(
// //               color: Colors.blue.shade50,
// //               borderRadius: BorderRadius.circular(8),
// //               border: Border.all(color: Colors.blue.shade100),
// //             ),
// //             child: Row(
// //               children: [
// //                 Icon(Icons.info, color: Colors.blue.shade600, size: 16),
// //                 SizedBox(width: 8),
// //                 Expanded(
// //                   child: Text(
// //                     'Files will be saved in /MediConnect folder in your device storage',
// //                     style: TextStyle(
// //                       color: Colors.blue.shade800,
// //                       fontSize: 12,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //         // Files list
// //         Expanded(
// //           child: _buildFilesList(),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildFilesList() {
// //     if (_isLoadingFiles) {
// //       return const Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             CircularProgressIndicator(),
// //             SizedBox(height: 16),
// //             Text("Loading medical reports..."),
// //           ],
// //         ),
// //       );
// //     }
// //
// //     if (files.isEmpty) {
// //       return Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(Icons.folder_open, size: 64, color: Colors.grey),
// //           SizedBox(height: 16),
// //           Text(
// //             "No medical reports uploaded yet",
// //             style: TextStyle(
// //               color: Colors.grey,
// //               fontSize: 16,
// //             ),
// //           ),
// //           Text(
// //             "Patient uploaded files will appear here",
// //             style: TextStyle(
// //               color: Colors.grey,
// //               fontSize: 12,
// //             ),
// //           ),
// //         ],
// //       );
// //     }
// //
// //     return RefreshIndicator(
// //       onRefresh: _refreshFiles,
// //       child: ListView.builder(
// //         padding: const EdgeInsets.all(8),
// //         itemCount: files.length,
// //         itemBuilder: (context, index) {
// //           final file = files[index];
// //           if (file is Map<String, dynamic>) {
// //             return _buildFileItem(file);
// //           } else {
// //             return Container(
// //               margin: const EdgeInsets.symmetric(vertical: 4),
// //               padding: const EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(8),
// //                 border: Border.all(color: Colors.red),
// //               ),
// //               child: Text(
// //                 'Invalid file format at index $index: ${file.toString()}',
// //                 style: const TextStyle(color: Colors.red),
// //               ),
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _buildMessageInput() {
// //     return SafeArea(
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// //         decoration: BoxDecoration(
// //           color: AppColors.primary,
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.grey.withOpacity(0.2),
// //               blurRadius: 4,
// //               offset: const Offset(0, -1),
// //             ),
// //           ],
// //         ),
// //         child: Row(
// //           children: [
// //             Expanded(
// //               child: Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(21),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.grey.withOpacity(0.2),
// //                       blurRadius: 4,
// //                       offset: const Offset(0, 1),
// //                     ),
// //                   ],
// //                 ),
// //                 child: TextField(
// //                   controller: _controller,
// //                   keyboardType: TextInputType.multiline,
// //                   textInputAction: TextInputAction.newline,
// //                   minLines: 1,
// //                   maxLines: 4,
// //                   decoration: const InputDecoration.collapsed(
// //                     hintText: "Type your message here",
// //                   ),
// //                   onChanged: (text) {
// //                     WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
// //                   },
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(width: 8),
// //             CircleAvatar(
// //               backgroundColor: AppColors.textLight,
// //               child: IconButton(
// //                 icon: const Icon(Icons.send, color: AppColors.primary),
// //                 onPressed: () => sendMessage(_controller.text),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildReadOnlyMessage() {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// //       decoration: BoxDecoration(
// //         color: Colors.grey,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.2),
// //             blurRadius: 4,
// //             offset: const Offset(0, -1),
// //           ),
// //         ],
// //       ),
// //       child: const Center(
// //         child: Text(
// //           "This order is completed - Chat history view only",
// //           style: TextStyle(
// //             color: Colors.white,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
//
//
//
//
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:math';
// import 'order.dart';
// import 'message.dart';
// import 'helper.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:open_filex/open_filex.dart';
//
// class OrderChatPage extends StatefulWidget {
//   final Order order;
//   final VoidCallback? onSessionEnded;
//   final bool isReadOnly;
//   final bool isDoctorView;
//
//   const OrderChatPage({
//     super.key,
//     required this.order,
//     this.onSessionEnded,
//     this.isReadOnly = false,
//     this.isDoctorView = false,
//   });
//
//   @override
//   State<OrderChatPage> createState() => _OrderChatPageState();
// }
//
// class _OrderChatPageState extends State<OrderChatPage> with SingleTickerProviderStateMixin {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   List<Message> messages = [];
//   List<dynamic> files = [];
//   bool _isLoadingFiles = false;
//   late TabController _tabController;
//   int _currentTabIndex = 0;
//   bool _isDownloading = false;
//   String _downloadingFileName = '';
//
//   // Upload access variables
//   bool _isGrantingUploadAccess = false;
//   bool _hasUploadAccess = false;
//
//   // Download tracking variables
//   final Set<String> _downloadingTaskIds = {};
//   final Map<String, double> _downloadProgress = {};
//
//   bool get isReadOnly => widget.isReadOnly || widget.order.status?.toLowerCase() == 'completed';
//
//   @override
//   void initState() {
//     super.initState();
//     messages = widget.order.messages ?? [];
//     files = widget.order.files ?? [];
//
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(_handleTabChange);
//
//     // Initialize downloader callbacks
//     _initializeDownloader();
//
//     // Check if upload access is already granted
//     _checkUploadAccess();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollToBottom();
//       _loadOrderFiles();
//     });
//   }
//
//   // Check if upload access is already granted
//   void _checkUploadAccess() {
//     // Check if there's any message indicating upload access was granted
//     for (var message in messages) {
//       if (message.text.toLowerCase().contains('upload access granted') ||
//           message.text.toLowerCase().contains('can upload more reports')) {
//         setState(() {
//           _hasUploadAccess = true;
//         });
//         break;
//       }
//     }
//   }
//
//   // Initialize downloader callbacks
//   void _initializeDownloader() {
//     FlutterDownloader.registerCallback((id, status, progress) {
//       if (_downloadingTaskIds.contains(id)) {
//         print('Download task $id: $status ($progress%)');
//
//         setState(() {
//           _downloadProgress[id] = progress.toDouble();
//         });
//
//         if (status == DownloadTaskStatus.complete) {
//           _downloadingTaskIds.remove(id);
//           _downloadProgress.remove(id);
//           if (mounted) {
//             Helpers.showSnackBar(
//               context,
//               'Download completed!',
//               bgColor: Colors.green,
//             );
//           }
//         } else if (status == DownloadTaskStatus.failed) {
//           _downloadingTaskIds.remove(id);
//           _downloadProgress.remove(id);
//           if (mounted) {
//             Helpers.showSnackBar(
//               context,
//               'Download failed!',
//               bgColor: Colors.red,
//             );
//           }
//         } else if (status == DownloadTaskStatus.canceled) {
//           _downloadingTaskIds.remove(id);
//           _downloadProgress.remove(id);
//         }
//       }
//     });
//   }
//
//   void _handleTabChange() {
//     if (_tabController.index != _currentTabIndex) {
//       setState(() {
//         _currentTabIndex = _tabController.index;
//       });
//
//       if (_tabController.index == 1) {
//         print('🔄 Switched to Files tab, refreshing files...');
//         _loadOrderFiles();
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     // Cancel all ongoing downloads when the page is disposed
//     for (String taskId in _downloadingTaskIds) {
//       FlutterDownloader.cancel(taskId: taskId);
//     }
//     _downloadingTaskIds.clear();
//     _downloadProgress.clear();
//
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }
//
//   // Grant upload access to patient
//   Future<void> _grantUploadAccess() async {
//     if (_isGrantingUploadAccess) return;
//
//     try {
//       setState(() {
//         _isGrantingUploadAccess = true;
//       });
//
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//
//       if (token == null) {
//         Helpers.showSnackBar(context, 'Authentication required', bgColor: Colors.red);
//         return;
//       }
//
//       final String url = "${ApiConfig.baseUrl}/update-report-permission";
//
//       print('📤 Granting upload access for patient: ${widget.order.userId}');
//
//       final response = await http.post(
//
//
//
//
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'userId': widget.order.userId,
//           'canSendReports': true,
//         }),
//       );
//
//       print('📥 Grant upload access response: ${response.statusCode}');
//       print('📥 Response body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//
//         if (data['success'] == true) {
//           // Send a message to the chat about upload access
//           await _sendUploadAccessMessage();
//
//           setState(() {
//             _hasUploadAccess = true;
//           });
//
//           Helpers.showSnackBar(
//             context,
//             'Upload access granted to patient!',
//             bgColor: Colors.green,
//           );
//         } else {
//           throw Exception(data['message'] ?? 'Failed to grant upload access');
//         }
//       } else {
//         throw Exception('HTTP ${response.statusCode}: ${response.body}');
//       }
//     } catch (e) {
//       print('❌ Grant upload access error: $e');
//       Helpers.showSnackBar(
//         context,
//         'Failed to grant upload access: ${e.toString()}',
//         bgColor: Colors.red,
//       );
//     } finally {
//       setState(() {
//         _isGrantingUploadAccess = false;
//       });
//     }
//   }
//
//   // Send message about upload access
//   Future<void> _sendUploadAccessMessage() async {
//     try {
//       final String url = "${ApiConfig.baseUrl}/sendMessageDoctor/${widget.order.orderId}";
//
//       final messageText = "📎 Upload Access Granted!\n\nThe patient can now upload additional medical reports for this consultation. They will see an upload button in their chat to add more files.";
//
//       final Map<String, dynamic> requestBody = {
//         'text': messageText,
//         'isBot': false,
//         'userName': 'Doctor',
//         'userId': 'doctor',
//         'patientUserId': widget.order.userId,
//         'patientUserName': widget.order.userName,
//         'isSystemMessage': true,
//         'hasUploadPermission': true,
//       };
//
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestBody),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body)['data'];
//         setState(() {
//           messages.add(Message.fromMap(data));
//         });
//         _scrollToBottom();
//       }
//     } catch (e) {
//       print('❌ Error sending upload access message: $e');
//     }
//   }
//
//   Future<void> _loadOrderFiles() async {
//     if (_isLoadingFiles) return;
//
//     try {
//       setState(() {
//         _isLoadingFiles = true;
//       });
//
//       if (widget.order.files != null && widget.order.files!.isNotEmpty) {
//         print('🔄 Using files from order object (passed from HomePage)');
//         setState(() {
//           files = widget.order.files!;
//         });
//         print('✅ Loaded ${files.length} files from order object');
//         return;
//       }
//
//       print('ℹ No files in order object, trying API...');
//
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//       final doctorId = prefs.getString('doctorId');
//       final doctorType = prefs.getString('doctorType');
//
//       if (token == null || token.isEmpty) {
//         print('❌ No token available for loading files');
//         return;
//       }
//
//       if (doctorId == null || doctorType == null) {
//         print('❌ Doctor information not available');
//         return;
//       }
//
//       print('🔐 Using token: ${token.substring(0, min(20, token.length))}...');
//       print('👨‍⚕ Doctor: $doctorId, Type: $doctorType');
//
//       final String url = "${ApiConfig.baseUrl}/getOrders?doctorType=$doctorType&doctorId=$doctorId";
//       print('📤 Loading files from: $url');
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       print('📥 Files API Response Status: ${response.statusCode}');
//
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         print('📦 Files API Response Body: ${jsonEncode(decoded)}');
//
//         if (decoded['success'] == true) {
//           List<dynamic> allOrdersData = [];
//
//           if (decoded['data'] is Map && decoded['data']['orders'] != null) {
//             allOrdersData = decoded['data']['orders'];
//           } else if (decoded['data'] is List) {
//             allOrdersData = decoded['data'];
//           } else if (decoded['orders'] is List) {
//             allOrdersData = decoded['orders'];
//           }
//
//           print('🔍 Searching for order: ${widget.order.orderId} in ${allOrdersData.length} orders');
//
//           Map<String, dynamic>? currentOrderData;
//           for (var order in allOrdersData) {
//             if (order is Map<String, dynamic>) {
//               final orderId = order['orderId']?.toString() ?? order['_id']?.toString();
//               if (orderId == widget.order.orderId) {
//                 currentOrderData = order;
//                 break;
//               }
//             }
//           }
//
//           if (currentOrderData != null) {
//             print('✅ Found current order data');
//
//             List<dynamic> allFiles = _extractFilesFromOrderData(currentOrderData);
//
//             print('✅ Extracted ${allFiles.length} files for order ${widget.order.orderId}');
//
//             for (int i = 0; i < allFiles.length; i++) {
//               final file = allFiles[i];
//               if (file is Map<String, dynamic>) {
//                 print('📄 File $i: ${file['fileName']}');
//                 print('   - fileType: ${file['fileType']}');
//                 print('   - uploadedBy: ${file['uploadedBy']}');
//                 print('   - filePath: ${file['filePath']}');
//                 print('   - downloadUrl: ${file['downloadUrl']}');
//               }
//             }
//
//             setState(() {
//               files = allFiles;
//             });
//
//             print('✅ UI Updated with ${files.length} files');
//           } else {
//             print('❌ Order ${widget.order.orderId} not found in response');
//           }
//         } else {
//           print('❌ API returned success: false');
//           print('❌ Message: ${decoded['message']}');
//         }
//       } else {
//         print('❌ Failed to load files: ${response.statusCode}');
//         print('❌ Response body: ${response.body}');
//       }
//     } catch (e, stackTrace) {
//       print('❌ Error loading files: $e');
//       print('❌ Stack trace: $stackTrace');
//     } finally {
//       setState(() {
//         _isLoadingFiles = false;
//       });
//     }
//   }
//
//   List<dynamic> _extractFilesFromOrderData(Map<String, dynamic> orderData) {
//     List<dynamic> allFiles = [];
//
//     try {
//       print('🔍 Extracting files from order data structure...');
//
//       // Method 1: Extract from reports.files.all (main location)
//       if (orderData['reports'] != null && orderData['reports'] is Map<String, dynamic>) {
//         final reports = orderData['reports'] as Map<String, dynamic>;
//
//         if (reports['files'] != null && reports['files'] is Map<String, dynamic>) {
//           final filesMap = reports['files'] as Map<String, dynamic>;
//
//           // Get files from 'all' array
//           if (filesMap['all'] != null && filesMap['all'] is List) {
//             final allFilesList = filesMap['all'] as List<dynamic>;
//             print('✅ Found ${allFilesList.length} files in reports.files.all');
//
//             for (var file in allFilesList) {
//               if (file is Map<String, dynamic>) {
//                 // Ensure file has all required fields and normalize filePath
//                 final normalizedFile = _normalizeFileData(file);
//                 if (normalizedFile != null) {
//                   allFiles.add(normalizedFile);
//                 }
//               }
//             }
//           }
//         }
//       }
//
//       // Method 2: Extract from messages with attachedFiles
//       if (orderData['messages'] != null && orderData['messages'] is List) {
//         final messages = orderData['messages'] as List<dynamic>;
//         for (var message in messages) {
//           if (message is Map<String, dynamic> &&
//               message['attachedFiles'] != null &&
//               message['attachedFiles'] is List) {
//             final attachedFiles = message['attachedFiles'] as List<dynamic>;
//             for (var file in attachedFiles) {
//               if (file is Map<String, dynamic>) {
//                 // Create a file object from message attachment
//                 final fileFromMessage = {
//                   'fileName': file['fileName'],
//                   'filePath': file['filePath'],
//                   'fileType': _getFileTypeFromFileName(file['fileName']),
//                   'fileSize': 0, // Size might not be available in messages
//                   'uploadedBy': 'patient', // Assuming from message context
//                   'category': file['category'] ?? 'Uncategorized',
//                   'source': 'messages',
//                   'messageText': message['text'],
//                   'messageCreatedAt': message['createdAt'],
//                 };
//                 final normalizedFile = _normalizeFileData(fileFromMessage);
//                 if (normalizedFile != null) {
//                   allFiles.add(normalizedFile);
//                 }
//               }
//             }
//           }
//         }
//       }
//
//       print('✅ Total normalized files extracted: ${allFiles.length}');
//
//       // Log all extracted files for debugging
//       for (int i = 0; i < allFiles.length; i++) {
//         final file = allFiles[i];
//         if (file is Map<String, dynamic>) {
//           print('📄 File $i: ${file['fileName']}');
//           print('   - filePath: ${file['filePath']}');
//           print('   - downloadUrl: ${file['downloadUrl']}');
//           print('   - fileSize: ${file['fileSize']}');
//           print('   - uploadedBy: ${file['uploadedBy']}');
//         }
//       }
//
//       return allFiles;
//
//     } catch (e) {
//       print('❌ Error extracting files: $e');
//       return allFiles;
//     }
//   }
//
//   String getFileTypeFromFileName(String fileName) {
//     final extension = fileName.toLowerCase().split('.').last;
//     switch (extension) {
//       case 'pdf':
//         return 'application/pdf';
//       case 'jpg':
//       case 'jpeg':
//         return 'image/jpeg';
//       case 'png':
//         return 'image/png';
//       case 'doc':
//       case 'docx':
//         return 'application/msword';
//       case 'xls':
//       case 'xlsx':
//         return 'application/vnd.ms-excel';
//       default:
//         return 'application/octet-stream';
//     }
//   }
//
//   Map<String, dynamic>? _normalizeFileData(Map<String, dynamic> file) {
//     try {
//       final fileName = file['fileName']?.toString();
//       if (fileName == null || fileName.isEmpty) {
//         print('⚠ Skipping file with no fileName: $file');
//         return null;
//       }
//
//       String filePath = file['filePath']?.toString() ?? '';
//
//       // Normalize file path - replace backslashes with forward slashes
//       if (filePath.isNotEmpty) {
//         filePath = filePath.replaceAll('\\', '/');
//         print('📝 Normalized file path: $filePath');
//       }
//
//       // Create download URL using the dedicated base FILE URL
//       String downloadUrl;
//       if (filePath.startsWith('http')) {
//         // If the path is already a full URL, use it as is
//         downloadUrl = filePath;
//       } else if (filePath.isNotEmpty) {
//         // Construct the URL from the base FILE URL and the relative path
//         // Ensure there's no double slash
//         final String base = ApiConfig.baseFileUrl.endsWith('/')
//             ? ApiConfig.baseFileUrl.substring(0, ApiConfig.baseFileUrl.length - 1)
//             : ApiConfig.baseFileUrl;
//         final String path = filePath.startsWith('/') ? filePath : '/$filePath';
//
//         downloadUrl = '$base$path';
//         print('🔗 CORRECTLY Constructed download URL: $downloadUrl');
//       } else {
//         print('⚠ No filePath available for: $fileName');
//         return null;
//       }
//
//       final fileType = file['fileType']?.toString() ?? getFileTypeFromFileName(fileName) ?? 'application/octet-stream';
//
//       return {
//         'fileName': fileName,
//         'filePath': filePath,
//         'downloadUrl': downloadUrl,
//         'fileType': fileType,
//         'fileSize': (file['fileSize'] is int)
//             ? file['fileSize']
//             : (file['fileSize'] is String)
//             ? int.tryParse(file['fileSize']) ?? 0
//             : 0,
//         'uploadedBy': file['uploadedBy']?.toString() ?? 'unknown',
//         'category': file['category']?.toString() ?? 'Uncategorized',
//         'source': file['source']?.toString() ?? 'reports',
//         'uploadDate': file['uploadDate']?.toString() ?? DateTime.now().toIso8601String(),
//         'originalData': file,
//       };
//     } catch (e) {
//       print('❌ Error normalizing file data: $e');
//       return null;
//     }
//   }
//
//   String _getFileTypeFromFileName(String fileName) {
//     final extension = fileName.toLowerCase().split('.').last;
//     switch (extension) {
//       case 'pdf':
//         return 'application/pdf';
//       case 'jpg':
//       case 'jpeg':
//         return 'image/jpeg';
//       case 'png':
//         return 'image/png';
//       case 'doc':
//       case 'docx':
//         return 'application/msword';
//       case 'xls':
//       case 'xlsx':
//         return 'application/vnd.ms-excel';
//       default:
//         return 'application/octet-stream';
//     }
//   }
//
//   Future<void> _downloadFile(Map<String, dynamic> file) async {
//     final fileName = file['fileName']?.toString() ?? 'Unknown File';
//     String? downloadUrl = file['downloadUrl']?.toString();
//     final filePath = file['filePath']?.toString();
//
//     print('📥 Starting download for: $fileName');
//     print('🔗 Initial Download URL: $downloadUrl');
//     print('📁 File path: $filePath');
//
//     // Fallback: If downloadUrl is still null but we have a filePath, try to construct it one last time
//     if ((downloadUrl == null || downloadUrl.isEmpty) && filePath != null && filePath.isNotEmpty) {
//       print('🔄 Download URL is null, attempting to construct from file path as a last resort');
//
//       String normalizedPath = filePath.replaceAll('\\', '/');
//
//       // USE THE CORRECT BASE FILE URL HERE
//       final String base = ApiConfig.baseFileUrl.endsWith('/')
//           ? ApiConfig.baseFileUrl.substring(0, ApiConfig.baseFileUrl.length - 1)
//           : ApiConfig.baseFileUrl;
//       final String path = normalizedPath.startsWith('/') ? normalizedPath : '/$normalizedPath';
//
//       downloadUrl = '$base$path';
//       print('🔗 CORRECT Fallback constructed download URL: $downloadUrl');
//     }
//
//     if (downloadUrl == null || downloadUrl.isEmpty) {
//       print('❌ No download URL could be determined for $fileName');
//       Helpers.showSnackBar(context, 'Download URL not available for $fileName', bgColor: Colors.red);
//       return;
//     }
//
//     try {
//       setState(() {
//         _isDownloading = true;
//         _downloadingFileName = fileName;
//       });
//
//       Helpers.showSnackBar(context, 'Starting download for $fileName...', bgColor: Colors.blue);
//
//       await _enhancedFallbackDownload(downloadUrl, fileName);
//
//     } catch (e) {
//       print('❌ Download error: $e');
//       Helpers.showSnackBar(
//         context,
//         'Download failed: ${e.toString()}',
//         bgColor: Colors.red,
//       );
//     } finally {
//       setState(() {
//         _isDownloading = false;
//         _downloadingFileName = '';
//       });
//     }
//   }
//
//   Future<void> _enhancedFallbackDownload(String url, String fileName) async {
//     try {
//       print('🔄 Using enhanced fallback download for: $fileName');
//       print('🔗 URL: $url');
//
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//
//       // Create HTTP client
//       final client = http.Client();
//
//       // Make the request
//       final response = await client.get(
//         Uri.parse(url),
//         headers: {
//           if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
//           'Accept': '/',
//         },
//       );
//
//       print('📥 Response status: ${response.statusCode}');
//       print('📥 Content length: ${response.contentLength}');
//
//       if (response.statusCode == 200) {
//         // Get a reliable directory
//         final directory = await _getReliableDownloadDirectory();
//         final String savePath = '${directory.path}/MediConnect';
//         final Directory saveDir = Directory(savePath);
//
//         if (!await saveDir.exists()) {
//           await saveDir.create(recursive: true);
//           print('📁 Created directory: $savePath');
//         }
//
//         // Clean filename
//         final cleanFileName = _cleanFileName(fileName);
//         final File file = File('$savePath/$cleanFileName');
//
//         // Write file
//         await file.writeAsBytes(response.bodyBytes);
//
//         final fileSize = await file.length();
//         print('✅ Download successful: ${file.path}');
//         print('📊 File size: $fileSize bytes');
//
//         // Verify file exists and has content
//         if (await file.exists() && fileSize > 0) {
//           if (mounted) {
//             Helpers.showSnackBar(
//               context,
//               'Download completed: $fileName',
//               bgColor: Colors.green,
//             );
//           }
//
//           // Try to open the file
//           try {
//             final openResult = await OpenFilex.open(file.path);
//             print('📂 Open file result: ${openResult.type}');
//             print('📂 Open file message: ${openResult.message}');
//
//             if (openResult.type != ResultType.done) {
//               if (mounted) {
//                 Helpers.showSnackBar(
//                   context,
//                   'File downloaded to MediConnect folder',
//                   bgColor: Colors.blue,
//                 );
//               }
//             }
//           } catch (e) {
//             print('⚠ Cannot open file automatically: $e');
//             if (mounted) {
//               Helpers.showSnackBar(
//                 context,
//                 'File downloaded to MediConnect folder',
//                 bgColor: Colors.green,
//               );
//             }
//           }
//
//           // Show file location
//           print('📍 File saved at: ${file.path}');
//
//         } else {
//           throw Exception('File was written but is empty or cannot be accessed');
//         }
//       } else {
//         throw Exception('HTTP ${response.statusCode} - ${response.reasonPhrase}');
//       }
//
//       client.close();
//     } catch (e) {
//       print('❌ Enhanced fallback download failed: $e');
//       rethrow;
//     }
//   }
//
//   Future<Directory> _getReliableDownloadDirectory() async {
//     try {
//       // For Android 10+, use scoped storage - app-specific directory
//       if (Platform.isAndroid) {
//         // Try external storage first (visible in file managers)
//         final externalDir = await getExternalStorageDirectory();
//         if (externalDir != null) {
//           return externalDir;
//         }
//       }
//
//       // Fallback to application documents directory
//       return await getApplicationDocumentsDirectory();
//     } catch (e) {
//       print('⚠ Error getting directory: $e');
//       return await getApplicationDocumentsDirectory();
//     }
//   }
//
//   String _cleanFileName(String fileName) {
//     // Remove invalid characters for file names
//     // We will explicitly replace each character to avoid regex issues
//     String cleaned = fileName
//         .replaceAll('<', '_')
//         .replaceAll('>', '_')
//         .replaceAll(':', '_')
//         .replaceAll('"', '_')
//         .replaceAll('/', '_')
//         .replaceAll('\\', '_')
//         .replaceAll('|', '_')
//         .replaceAll('?', '_')
//         .replaceAll('*', '_');
//
//     // Replace multiple spaces with single underscore
//     cleaned = cleaned.replaceAll(RegExp(r'\s+'), '_');
//
//     // Remove leading/trailing spaces and underscores
//     cleaned = cleaned.trim().replaceAll(RegExp(r'^_+|_+$'), '');
//
//     // If filename is empty after cleaning, use a default name
//     if (cleaned.isEmpty) {
//       cleaned = 'downloaded_file_${DateTime.now().millisecondsSinceEpoch}';
//     }
//
//     return cleaned;
//   }
//
//   // Send message
//   Future<void> sendMessage(String text) async {
//     if (text.trim().isEmpty) return;
//     if (isReadOnly) {
//       Helpers.showSnackBar(context, 'Cannot send messages in completed order', bgColor: Colors.orange);
//       return;
//     }
//
//     try {
//       final String url = "${ApiConfig.baseUrl}/sendMessageDoctor/${widget.order.orderId}";
//       final Map<String, dynamic> requestBody = {
//         'text': text,
//         'isBot': false,
//         'userName': 'Doctor',
//         'userId': 'doctor',
//         'patientUserId': widget.order.userId,
//         'patientUserName': widget.order.userName,
//       };
//
//       print('📤 Sending message to: $url');
//       print('📦 Request body: $requestBody');
//
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestBody),
//       );
//
//       print('📥 Response status: ${response.statusCode}');
//       print('📥 Response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body)['data'];
//         setState(() {
//           messages.add(Message.fromMap(data));
//         });
//         _controller.clear();
//         _scrollToBottom();
//       } else {
//         final errorBody = jsonDecode(response.body);
//         final errorMessage = errorBody['message'] ?? 'Failed to send message';
//         Helpers.showSnackBar(context, 'Error: $errorMessage', bgColor: Colors.red);
//       }
//     } catch (e) {
//       print('❌ sendMessage error: $e');
//       Helpers.showSnackBar(context, 'Network error: $e', bgColor: Colors.red);
//     }
//   }
//
//   // End Session
//   Future<void> _endSession() async {
//     if (isReadOnly) {
//       Helpers.showSnackBar(context, 'This order is already completed', bgColor: Colors.orange);
//       return;
//     }
//
//     bool confirmEnd = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("End Session"),
//           content: const Text("Are you sure you want to end this session? This will complete the order and reset the chat for the patient."),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//               ),
//               child: const Text("End Session", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (confirmEnd != true) return;
//
//     try {
//       final String url = "${ApiConfig.baseUrl}/completeOrder/${widget.order.orderId}";
//
//       print('🚀 Ending session for order: ${widget.order.orderId}');
//
//       final requestBody = {
//         'status': 'completed',
//         'completedAt': DateTime.now().toIso8601String(),
//         'completedBy': 'Doctor',
//         'resetChat': true,
//       };
//
//       final response = await http.put(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestBody),
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//
//         if (responseData['success'] == true) {
//           Helpers.showSnackBar(
//             context,
//             'Session ended successfully! Order completed and chat reset.',
//             bgColor: Colors.green,
//           );
//
//           if (widget.onSessionEnded != null) {
//             widget.onSessionEnded!();
//           }
//
//           Navigator.of(context).pop(true);
//         } else {
//           throw Exception(responseData['message'] ?? 'Failed to complete order');
//         }
//       } else {
//         throw Exception('HTTP ${response.statusCode}: ${response.body}');
//       }
//     } catch (e) {
//       print('❌ End session error: $e');
//       Helpers.showSnackBar(
//         context,
//         'Failed to end session: ${e.toString()}',
//         bgColor: Colors.red,
//       );
//     }
//   }
//
//   // Build file item widget
//   Widget _buildFileItem(Map<String, dynamic> file) {
//     final fileName = file['fileName']?.toString() ?? 'Unknown File';
//     final fileSize = file['fileSize'] ?? 0;
//     final fileType = file['fileType']?.toString() ?? 'file';
//     final uploadedBy = file['uploadedBy']?.toString() ?? 'Unknown';
//     final category = file['category']?.toString() ?? 'Uncategorized';
//     final uploadDate = file['uploadDate'] != null
//         ? DateTime.tryParse(file['uploadDate'])?.toLocal() ?? DateTime.now()
//         : DateTime.now();
//
//     // Check if this file is currently downloading
//     bool isDownloadingThisFile = _isDownloading && _downloadingFileName == fileName;
//
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               _getFileIcon(fileType),
//               color: AppColors.primary,
//               size: 24,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   fileName,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Category: $category',
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 12,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Text(
//                       _formatFileSize(fileSize is int ? fileSize : 0),
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       width: 4,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade400,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       fileType.split('/').last.toUpperCase(),
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Icon(
//                       uploadedBy == 'patient' ? Icons.person : Icons.medical_services,
//                       size: 12,
//                       color: Colors.grey.shade600,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       'Uploaded by ${uploadedBy == 'patient' ? 'Patient' : 'Doctor'}',
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 11,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       '${uploadDate.day}/${uploadDate.month}/${uploadDate.year}',
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (isDownloadingThisFile) ...[
//                   const SizedBox(height: 8),
//                   LinearProgressIndicator(
//                     backgroundColor: Colors.grey.shade300,
//                     valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Downloading...',
//                     style: const TextStyle(
//                       color: Colors.blue,
//                       fontSize: 10,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           if (isDownloadingThisFile)
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               ),
//             )
//           else
//             IconButton(
//               icon: Icon(
//                 Icons.download,
//                 color: AppColors.primary,
//               ),
//               onPressed: () => _downloadFile(file),
//             ),
//         ],
//       ),
//     );
//   }
//
//   // Helper methods for file display
//   IconData _getFileIcon(String fileType) {
//     if (fileType.toLowerCase().contains('image')) return Icons.image;
//     if (fileType.toLowerCase().contains('pdf')) return Icons.picture_as_pdf;
//     if (fileType.toLowerCase().contains('word') || fileType.toLowerCase().contains('document'))
//       return Icons.description;
//     return Icons.insert_drive_file;
//   }
//
//   String _formatFileSize(int bytes) {
//     if (bytes < 1024) return '$bytes B';
//     if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
//     return '${(bytes / 1048576).toStringAsFixed(1)} MB';
//   }
//
//   // Build message bubble
//   Widget _buildMessageBubble(Message msg) {
//     final isDoctor = msg.userName == "Doctor";
//     final alignment = isDoctor ? Alignment.centerRight : Alignment.centerLeft;
//     final bgColor = isDoctor
//         ? AppColors.textLight.withOpacity(0.9)
//         : AppColors.primary.withOpacity(0.9);
//     final textColor = isDoctor ? Colors.black87 : Colors.white;
//
//     return Container(
//       alignment: alignment,
//       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         constraints: const BoxConstraints(maxWidth: 280),
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: isDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Text(
//               msg.text,
//               style: TextStyle(color: textColor, fontSize: 15),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               "${msg.createdAt?.hour.toString().padLeft(2, '0')}:${msg.createdAt?.minute.toString().padLeft(2, '0')}",
//               style: TextStyle(
//                 color: textColor.withOpacity(0.7),
//                 fontSize: 10,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _refreshFiles() async {
//     print('🔄 Manually refreshing files...');
//     await _loadOrderFiles();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: isReadOnly ? Colors.grey : AppColors.primary,
//         iconTheme: const IconThemeData(color: Colors.white),
//         toolbarHeight: 75,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.order.userName,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             if (isReadOnly)
//               const Text(
//                 "COMPLETED - VIEW ONLY",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//           ],
//         ),
//
//         actions: [
//           // Upload Access Button - Only in AppBar (Chat section)
//           if (!isReadOnly && !_hasUploadAccess)
//             Padding(
//               padding: const EdgeInsets.only(right: 8.0),
//               child: ElevatedButton.icon(
//                 onPressed: _isGrantingUploadAccess ? null : _grantUploadAccess,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 icon: _isGrantingUploadAccess
//                     ? const SizedBox(
//                   width: 16,
//                   height: 16,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//                     : const Icon(Icons.upload_file, size: 16),
//                 label: _isGrantingUploadAccess
//                     ? const Text(
//                   "Granting...",
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                 )
//                     : const Text(
//                   "Allow Upload",
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           if (!isReadOnly)
//             Padding(
//               padding: const EdgeInsets.only(right: 11.0),
//               child: ElevatedButton.icon(
//                 onPressed: _endSession,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 icon: const Icon(Icons.done_all, size: 16),
//                 label: const Text(
//                   "End Session",
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(48.0),
//           child: Container(
//             color: AppColors.primary,
//             child: TabBar(
//               controller: _tabController,
//               indicatorColor: Colors.white,
//               labelColor: Colors.white,
//               unselectedLabelColor: Colors.white70,
//               tabs: const [
//                 Tab(
//                   icon: Icon(Icons.chat, size: 20),
//                   text: 'Chat',
//                 ),
//                 Tab(
//                   icon: Icon(Icons.attach_file, size: 20),
//                   text: 'Files',
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // Chat Tab
//           _buildChatTab(),
//
//           // Files Tab
//           _buildFilesTab(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChatTab() {
//     return Column(
//       children: [
//         // Order Info Card with Upload Access Button
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(12),
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 blurRadius: 4,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Consultation Details",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                   // Upload Access Button in the card
//                   if (!isReadOnly && !_hasUploadAccess)
//                     ElevatedButton.icon(
//                       onPressed: _isGrantingUploadAccess ? null : _grantUploadAccess,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       icon: _isGrantingUploadAccess
//                           ? const SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       )
//                           : const Icon(Icons.upload_file, size: 16),
//                       label: _isGrantingUploadAccess
//                           ? const Text(
//                         "Granting...",
//                         style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                       )
//                           : const Text(
//                         "Allow Upload",
//                         style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(Icons.medical_services, size: 16, color: Colors.grey),
//                   const SizedBox(width: 8),
//                   Text("${widget.order.doctorType} - ${widget.order.speciality}"),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   Icon(Icons.person, size: 16, color: Colors.grey),
//                   const SizedBox(width: 8),
//                   Text("Patient: ${widget.order.userName}"),
//                 ],
//               ),
//               // Upload Access Status
//               if (_hasUploadAccess)
//                 Container(
//                   margin: const EdgeInsets.only(top: 8),
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.green.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.green.shade200),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.check_circle, color: Colors.green.shade700, size: 16),
//                       const SizedBox(width: 8),
//                       Text(
//                         "Patient can upload additional reports",
//                         style: TextStyle(
//                           color: Colors.green.shade800,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: messages.isEmpty
//               ? const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
//                 SizedBox(height: 16),
//                 Text(
//                   "No messages yet",
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 16,
//                   ),
//                 ),
//                 Text(
//                   "Start the conversation with your patient",
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           )
//               : ListView.builder(
//             controller: _scrollController,
//             padding: const EdgeInsets.all(10),
//             itemCount: messages.length,
//             itemBuilder: (context, index) {
//               return _buildMessageBubble(messages[index]);
//             },
//           ),
//         ),
//         if (!isReadOnly) _buildMessageInput(),
//         if (isReadOnly) _buildReadOnlyMessage(),
//       ],
//     );
//   }
//
//   Widget _buildFilesTab() {
//     return Column(
//       children: [
//         // Header with file count and refresh
//         Container(
//           padding: const EdgeInsets.all(16),
//           color: Colors.white,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Medical Reports & Files",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                   Text(
//                     "${files.length} file(s) found",
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 12,
//                     ),
//                   ),
//                   // Upload Access Info in Files Tab
//                   if (_hasUploadAccess)
//                     Container(
//                       margin: const EdgeInsets.only(top: 4),
//                       child: Text(
//                         "Patient can upload more files",
//                         style: TextStyle(
//                           color: Colors.green.shade700,
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               IconButton(
//                 icon: Icon(Icons.refresh, color: AppColors.primary),
//                 onPressed: _loadOrderFiles,
//                 tooltip: 'Refresh Files',
//               ),
//             ],
//           ),
//         ),
//
//         // Debug info panel
//         if (files.isNotEmpty)
//           Container(
//             padding: const EdgeInsets.all(8),
//             margin: const EdgeInsets.symmetric(horizontal: 8),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.blue.shade100),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.info, color: Colors.blue.shade600, size: 16),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'Files will be saved in /MediConnect folder in your device storage',
//                     style: TextStyle(
//                       color: Colors.blue.shade800,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//         // Files list
//         Expanded(
//           child: _buildFilesList(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFilesList() {
//     if (_isLoadingFiles) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 16),
//             Text("Loading medical reports..."),
//           ],
//         ),
//       );
//     }
//
//     if (files.isEmpty) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.folder_open, size: 64, color: Colors.grey),
//           SizedBox(height: 16),
//           Text(
//             "No medical reports uploaded yet",
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: 16,
//             ),
//           ),
//           Text(
//             "Patient uploaded files will appear here",
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       );
//     }
//
//     return RefreshIndicator(
//       onRefresh: _refreshFiles,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(8),
//         itemCount: files.length,
//         itemBuilder: (context, index) {
//           final file = files[index];
//           if (file is Map<String, dynamic>) {
//             return _buildFileItem(file);
//           } else {
//             return Container(
//               margin: const EdgeInsets.symmetric(vertical: 4),
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.red),
//               ),
//               child: Text(
//                 'Invalid file format at index $index: ${file.toString()}',
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   Widget _buildMessageInput() {
//     return SafeArea(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//         decoration: BoxDecoration(
//           color: AppColors.primary,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               blurRadius: 4,
//               offset: const Offset(0, -1),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(21),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       blurRadius: 4,
//                       offset: const Offset(0, 1),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: _controller,
//                   keyboardType: TextInputType.multiline,
//                   textInputAction: TextInputAction.newline,
//                   minLines: 1,
//                   maxLines: 4,
//                   decoration: const InputDecoration.collapsed(
//                     hintText: "Type your message here",
//                   ),
//                   onChanged: (text) {
//                     WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             CircleAvatar(
//               backgroundColor: AppColors.textLight,
//               child: IconButton(
//                 icon: const Icon(Icons.send, color: AppColors.primary),
//                 onPressed: () => sendMessage(_controller.text),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildReadOnlyMessage() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, -1),
//           ),
//         ],
//       ),
//       child: const Center(
//         child: Text(
//           "This order is completed - Chat history view only",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }






import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'order.dart';
import 'message.dart';
import 'helper.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_filex/open_filex.dart';

class OrderChatPage extends StatefulWidget {
  final Order order;
  final VoidCallback? onSessionEnded;
  final bool isReadOnly;
  final bool isDoctorView;

  const OrderChatPage({
    super.key,
    required this.order,
    this.onSessionEnded,
    this.isReadOnly = false,
    this.isDoctorView = false,
  });

  @override
  State<OrderChatPage> createState() => _OrderChatPageState();
}

class _OrderChatPageState extends State<OrderChatPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
  List<dynamic> files = [];
  bool _isLoadingFiles = false;
  late TabController _tabController;
  int _currentTabIndex = 0;
  bool _isDownloading = false;
  String _downloadingFileName = '';

  // Upload access variables
  bool _isGrantingUploadAccess = false;
  bool _hasUploadAccess = false;

  // Download tracking variables
  final Set<String> _downloadingTaskIds = {};
  final Map<String, double> _downloadProgress = {};

  bool get isReadOnly => widget.isReadOnly || widget.order.status?.toLowerCase() == 'completed';

  @override
  void initState() {
    super.initState();
    messages = widget.order.messages ?? [];
    files = widget.order.files ?? [];

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Initialize downloader callbacks
    _initializeDownloader();

    // Check if upload access is already granted
    _checkUploadAccess();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      _loadOrderFiles();
    });
  }

  // Check if upload access is already granted
  void _checkUploadAccess() {
    // Check if there's any message indicating upload access was granted
    for (var message in messages) {
      if (message.text.toLowerCase().contains('upload access granted') ||
          message.text.toLowerCase().contains('can upload more reports')) {
        setState(() {
          _hasUploadAccess = true;
        });
        break;
      }
    }
  }

  // Initialize downloader callbacks
  void _initializeDownloader() {
    FlutterDownloader.registerCallback((id, status, progress) {
      if (_downloadingTaskIds.contains(id)) {
        print('Download task $id: $status ($progress%)');

        setState(() {
          _downloadProgress[id] = progress.toDouble();
        });

        if (status == DownloadTaskStatus.complete) {
          _downloadingTaskIds.remove(id);
          _downloadProgress.remove(id);
          if (mounted) {
            Helpers.showSnackBar(
              context,
              'Download completed!',
              bgColor: Colors.green,
            );
          }
        } else if (status == DownloadTaskStatus.failed) {
          _downloadingTaskIds.remove(id);
          _downloadProgress.remove(id);
          if (mounted) {
            Helpers.showSnackBar(
              context,
              'Download failed!',
              bgColor: Colors.red,
            );
          }
        } else if (status == DownloadTaskStatus.canceled) {
          _downloadingTaskIds.remove(id);
          _downloadProgress.remove(id);
        }
      }
    });
  }

  void _handleTabChange() {
    if (_tabController.index != _currentTabIndex) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });

      if (_tabController.index == 1) {
        print('🔄 Switched to Files tab, refreshing files...');
        _loadOrderFiles();
      }
    }
  }

  @override
  void dispose() {
    // Cancel all ongoing downloads when the page is disposed
    for (String taskId in _downloadingTaskIds) {
      FlutterDownloader.cancel(taskId: taskId);
    }
    _downloadingTaskIds.clear();
    _downloadProgress.clear();

    _tabController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Grant upload access to patient
  Future<void> _grantUploadAccess() async {
    if (_isGrantingUploadAccess) return;

    try {
      setState(() {
        _isGrantingUploadAccess = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Helpers.showSnackBar(context, 'Authentication required', bgColor: Colors.red);
        return;
      }

      final String url = "${ApiConfig.baseUrl}/update-report-permission";

      print('📤 Granting upload access for patient: ${widget.order.userId}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userId': widget.order.userId,
          'canSendReports': true,
        }),
      );

      print('📥 Grant upload access response: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          // Send a message to the chat about upload access
          await _sendUploadAccessMessage();

          setState(() {
            _hasUploadAccess = true;
          });

          Helpers.showSnackBar(
            context,
            'Upload access granted to patient!',
            bgColor: Colors.green,
          );
        } else {
          throw Exception(data['message'] ?? 'Failed to grant upload access');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Grant upload access error: $e');
      Helpers.showSnackBar(
        context,
        'Failed to grant upload access: ${e.toString()}',
        bgColor: Colors.red,
      );
    } finally {
      setState(() {
        _isGrantingUploadAccess = false;
      });
    }
  }

  // Send message about upload access
  Future<void> _sendUploadAccessMessage() async {
    try {
      final String url = "${ApiConfig.baseUrl}/sendMessageDoctor/${widget.order.orderId}";

      final messageText = "📎 Upload Access Granted!\n\nThe patient can now upload additional medical reports for this consultation. They will see an upload button in their chat to add more files.";

      final Map<String, dynamic> requestBody = {
        'text': messageText,
        'isBot': false,
        'userName': 'Doctor',
        'userId': 'doctor',
        'patientUserId': widget.order.userId,
        'patientUserName': widget.order.userName,
        'isSystemMessage': true,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          messages.add(Message.fromMap(data));
        });
        _scrollToBottom();
      }
    } catch (e) {
      print('❌ Error sending upload access message: $e');
    }
  }

  Future<void> _loadOrderFiles() async {
    if (_isLoadingFiles) return;

    try {
      setState(() {
        _isLoadingFiles = true;
      });

      if (widget.order.files != null && widget.order.files!.isNotEmpty) {
        print('🔄 Using files from order object (passed from HomePage)');
        setState(() {
          files = widget.order.files!;
        });
        print('✅ Loaded ${files.length} files from order object');
        return;
      }

      print('ℹ No files in order object, trying API...');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final doctorId = prefs.getString('doctorId');
      final doctorType = prefs.getString('doctorType');

      if (token == null || token.isEmpty) {
        print('❌ No token available for loading files');
        return;
      }

      if (doctorId == null || doctorType == null) {
        print('❌ Doctor information not available');
        return;
      }

      print('🔐 Using token: ${token.substring(0, min(20, token.length))}...');
      print('👨‍⚕ Doctor: $doctorId, Type: $doctorType');

      final String url = "${ApiConfig.baseUrl}/getOrders?doctorType=$doctorType&doctorId=$doctorId";
      print('📤 Loading files from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Files API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print('📦 Files API Response Body: ${jsonEncode(decoded)}');

        if (decoded['success'] == true) {
          List<dynamic> allOrdersData = [];

          if (decoded['data'] is Map && decoded['data']['orders'] != null) {
            allOrdersData = decoded['data']['orders'];
          } else if (decoded['data'] is List) {
            allOrdersData = decoded['data'];
          } else if (decoded['orders'] is List) {
            allOrdersData = decoded['orders'];
          }

          print('🔍 Searching for order: ${widget.order.orderId} in ${allOrdersData.length} orders');

          Map<String, dynamic>? currentOrderData;
          for (var order in allOrdersData) {
            if (order is Map<String, dynamic>) {
              final orderId = order['orderId']?.toString() ?? order['_id']?.toString();
              if (orderId == widget.order.orderId) {
                currentOrderData = order;
                break;
              }
            }
          }

          if (currentOrderData != null) {
            print('✅ Found current order data');

            List<dynamic> allFiles = _extractFilesFromOrderData(currentOrderData);

            print('✅ Extracted ${allFiles.length} files for order ${widget.order.orderId}');

            for (int i = 0; i < allFiles.length; i++) {
              final file = allFiles[i];
              if (file is Map<String, dynamic>) {
                print('📄 File $i: ${file['fileName']}');
                print('   - fileType: ${file['fileType']}');
                print('   - uploadedBy: ${file['uploadedBy']}');
                print('   - filePath: ${file['filePath']}');
                print('   - downloadUrl: ${file['downloadUrl']}');
              }
            }

            setState(() {
              files = allFiles;
            });

            print('✅ UI Updated with ${files.length} files');
          } else {
            print('❌ Order ${widget.order.orderId} not found in response');
          }
        } else {
          print('❌ API returned success: false');
          print('❌ Message: ${decoded['message']}');
        }
      } else {
        print('❌ Failed to load files: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('❌ Error loading files: $e');
      print('❌ Stack trace: $stackTrace');
    } finally {
      setState(() {
        _isLoadingFiles = false;
      });
    }
  }

  List<dynamic> _extractFilesFromOrderData(Map<String, dynamic> orderData) {
    List<dynamic> allFiles = [];

    try {
      print('🔍 Extracting files from order data structure...');

      // Method 1: Extract from reports.files.all (main location)
      if (orderData['reports'] != null && orderData['reports'] is Map<String, dynamic>) {
        final reports = orderData['reports'] as Map<String, dynamic>;

        if (reports['files'] != null && reports['files'] is Map<String, dynamic>) {
          final filesMap = reports['files'] as Map<String, dynamic>;

          // Get files from 'all' array
          if (filesMap['all'] != null && filesMap['all'] is List) {
            final allFilesList = filesMap['all'] as List<dynamic>;
            print('✅ Found ${allFilesList.length} files in reports.files.all');

            for (var file in allFilesList) {
              if (file is Map<String, dynamic>) {
                // Ensure file has all required fields and normalize filePath
                final normalizedFile = _normalizeFileData(file);
                if (normalizedFile != null) {
                  allFiles.add(normalizedFile);
                }
              }
            }
          }
        }
      }

      // Method 2: Extract from messages with attachedFiles
      if (orderData['messages'] != null && orderData['messages'] is List) {
        final messages = orderData['messages'] as List<dynamic>;
        for (var message in messages) {
          if (message is Map<String, dynamic> &&
              message['attachedFiles'] != null &&
              message['attachedFiles'] is List) {
            final attachedFiles = message['attachedFiles'] as List<dynamic>;
            for (var file in attachedFiles) {
              if (file is Map<String, dynamic>) {
                // Create a file object from message attachment
                final fileFromMessage = {
                  'fileName': file['fileName'],
                  'filePath': file['filePath'],
                  'fileType': _getFileTypeFromFileName(file['fileName']),
                  'fileSize': 0, // Size might not be available in messages
                  'uploadedBy': 'patient', // Assuming from message context
                  'category': file['category'] ?? 'Uncategorized',
                  'source': 'messages',
                  'messageText': message['text'],
                  'messageCreatedAt': message['createdAt'],
                };
                final normalizedFile = _normalizeFileData(fileFromMessage);
                if (normalizedFile != null) {
                  allFiles.add(normalizedFile);
                }
              }
            }
          }
        }
      }

      print('✅ Total normalized files extracted: ${allFiles.length}');

      // Log all extracted files for debugging
      for (int i = 0; i < allFiles.length; i++) {
        final file = allFiles[i];
        if (file is Map<String, dynamic>) {
          print('📄 File $i: ${file['fileName']}');
          print('   - filePath: ${file['filePath']}');
          print('   - downloadUrl: ${file['downloadUrl']}');
          print('   - fileSize: ${file['fileSize']}');
          print('   - uploadedBy: ${file['uploadedBy']}');
        }
      }

      return allFiles;

    } catch (e) {
      print('❌ Error extracting files: $e');
      return allFiles;
    }
  }

  String getFileTypeFromFileName(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'doc':
      case 'docx':
        return 'application/msword';
      case 'xls':
      case 'xlsx':
        return 'application/vnd.ms-excel';
      default:
        return 'application/octet-stream';
    }
  }

  Map<String, dynamic>? _normalizeFileData(Map<String, dynamic> file) {
    try {
      final fileName = file['fileName']?.toString();
      if (fileName == null || fileName.isEmpty) {
        print('⚠ Skipping file with no fileName: $file');
        return null;
      }

      String filePath = file['filePath']?.toString() ?? '';

      // Normalize file path - replace backslashes with forward slashes
      if (filePath.isNotEmpty) {
        filePath = filePath.replaceAll('\\', '/');
        print('📝 Normalized file path: $filePath');
      }

      // Create download URL using the dedicated base FILE URL
      String downloadUrl;
      if (filePath.startsWith('http')) {
        // If the path is already a full URL, use it as is
        downloadUrl = filePath;
      } else if (filePath.isNotEmpty) {
        // Construct the URL from the base FILE URL and the relative path
        // Ensure there's no double slash
        final String base = ApiConfig.baseFileUrl.endsWith('/')
            ? ApiConfig.baseFileUrl.substring(0, ApiConfig.baseFileUrl.length - 1)
            : ApiConfig.baseFileUrl;
        final String path = filePath.startsWith('/') ? filePath : '/$filePath';

        downloadUrl = '$base$path';
        print('🔗 CORRECTLY Constructed download URL: $downloadUrl');
      } else {
        print('⚠ No filePath available for: $fileName');
        return null;
      }

      final fileType = file['fileType']?.toString() ?? getFileTypeFromFileName(fileName) ?? 'application/octet-stream';

      return {
        'fileName': fileName,
        'filePath': filePath,
        'downloadUrl': downloadUrl,
        'fileType': fileType,
        'fileSize': (file['fileSize'] is int)
            ? file['fileSize']
            : (file['fileSize'] is String)
            ? int.tryParse(file['fileSize']) ?? 0
            : 0,
        'uploadedBy': file['uploadedBy']?.toString() ?? 'unknown',
        'category': file['category']?.toString() ?? 'Uncategorized',
        'source': file['source']?.toString() ?? 'reports',
        'uploadDate': file['uploadDate']?.toString() ?? DateTime.now().toIso8601String(),
        'originalData': file,
      };
    } catch (e) {
      print('❌ Error normalizing file data: $e');
      return null;
    }
  }

  String _getFileTypeFromFileName(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'doc':
      case 'docx':
        return 'application/msword';
      case 'xls':
      case 'xlsx':
        return 'application/vnd.ms-excel';
      default:
        return 'application/octet-stream';
    }
  }

  Future<void> _downloadFile(Map<String, dynamic> file) async {
    final fileName = file['fileName']?.toString() ?? 'Unknown File';
    String? downloadUrl = file['downloadUrl']?.toString();
    final filePath = file['filePath']?.toString();

    print('📥 Starting download for: $fileName');
    print('🔗 Initial Download URL: $downloadUrl');
    print('📁 File path: $filePath');

    // Fallback: If downloadUrl is still null but we have a filePath, try to construct it one last time
    if ((downloadUrl == null || downloadUrl.isEmpty) && filePath != null && filePath.isNotEmpty) {
      print('🔄 Download URL is null, attempting to construct from file path as a last resort');

      String normalizedPath = filePath.replaceAll('\\', '/');

      // USE THE CORRECT BASE FILE URL HERE
      final String base = ApiConfig.baseFileUrl.endsWith('/')
          ? ApiConfig.baseFileUrl.substring(0, ApiConfig.baseFileUrl.length - 1)
          : ApiConfig.baseFileUrl;
      final String path = normalizedPath.startsWith('/') ? normalizedPath : '/$normalizedPath';

      downloadUrl = '$base$path';
      print('🔗 CORRECT Fallback constructed download URL: $downloadUrl');
    }

    if (downloadUrl == null || downloadUrl.isEmpty) {
      print('❌ No download URL could be determined for $fileName');
      Helpers.showSnackBar(context, 'Download URL not available for $fileName', bgColor: Colors.red);
      return;
    }

    try {
      setState(() {
        _isDownloading = true;
        _downloadingFileName = fileName;
      });

      Helpers.showSnackBar(context, 'Starting download for $fileName...', bgColor: Colors.blue);

      await _enhancedFallbackDownload(downloadUrl, fileName);

    } catch (e) {
      print('❌ Download error: $e');
      Helpers.showSnackBar(
        context,
        'Download failed: ${e.toString()}',
        bgColor: Colors.red,
      );
    } finally {
      setState(() {
        _isDownloading = false;
        _downloadingFileName = '';
      });
    }
  }

  Future<void> _enhancedFallbackDownload(String url, String fileName) async {
    try {
      print('🔄 Using enhanced fallback download for: $fileName');
      print('🔗 URL: $url');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Create HTTP client
      final client = http.Client();

      // Make the request
      final response = await client.get(
        Uri.parse(url),
        headers: {
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
          'Accept': '/',
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Content length: ${response.contentLength}');

      if (response.statusCode == 200) {
        // Get a reliable directory
        final directory = await _getReliableDownloadDirectory();
        final String savePath = '${directory.path}/MediConnect';
        final Directory saveDir = Directory(savePath);

        if (!await saveDir.exists()) {
          await saveDir.create(recursive: true);
          print('📁 Created directory: $savePath');
        }

        // Clean filename
        final cleanFileName = _cleanFileName(fileName);
        final File file = File('$savePath/$cleanFileName');

        // Write file
        await file.writeAsBytes(response.bodyBytes);

        final fileSize = await file.length();
        print('✅ Download successful: ${file.path}');
        print('📊 File size: $fileSize bytes');

        // Verify file exists and has content
        if (await file.exists() && fileSize > 0) {
          if (mounted) {
            Helpers.showSnackBar(
              context,
              'Download completed: $fileName',
              bgColor: Colors.green,
            );
          }

          // Try to open the file
          try {
            final openResult = await OpenFilex.open(file.path);
            print('📂 Open file result: ${openResult.type}');
            print('📂 Open file message: ${openResult.message}');

            if (openResult.type != ResultType.done) {
              if (mounted) {
                Helpers.showSnackBar(
                  context,
                  'File downloaded to MediConnect folder',
                  bgColor: Colors.blue,
                );
              }
            }
          } catch (e) {
            print('⚠ Cannot open file automatically: $e');
            if (mounted) {
              Helpers.showSnackBar(
                context,
                'File downloaded to MediConnect folder',
                bgColor: Colors.green,
              );
            }
          }

          // Show file location
          print('📍 File saved at: ${file.path}');

        } else {
          throw Exception('File was written but is empty or cannot be accessed');
        }
      } else {
        throw Exception('HTTP ${response.statusCode} - ${response.reasonPhrase}');
      }

      client.close();
    } catch (e) {
      print('❌ Enhanced fallback download failed: $e');
      rethrow;
    }
  }

  Future<Directory> _getReliableDownloadDirectory() async {
    try {
      // For Android 10+, use scoped storage - app-specific directory
      if (Platform.isAndroid) {
        // Try external storage first (visible in file managers)
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          return externalDir;
        }
      }

      // Fallback to application documents directory
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      print('⚠ Error getting directory: $e');
      return await getApplicationDocumentsDirectory();
    }
  }

  String _cleanFileName(String fileName) {
    // Remove invalid characters for file names
    // We will explicitly replace each character to avoid regex issues
    String cleaned = fileName
        .replaceAll('<', '_')
        .replaceAll('>', '_')
        .replaceAll(':', '_')
        .replaceAll('"', '_')
        .replaceAll('/', '_')
        .replaceAll('\\', '_')
        .replaceAll('|', '_')
        .replaceAll('?', '_')
        .replaceAll('*', '_');

    // Replace multiple spaces with single underscore
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), '_');

    // Remove leading/trailing spaces and underscores
    cleaned = cleaned.trim().replaceAll(RegExp(r'^_+|_+$'), '');

    // If filename is empty after cleaning, use a default name
    if (cleaned.isEmpty) {
      cleaned = 'downloaded_file_${DateTime.now().millisecondsSinceEpoch}';
    }

    return cleaned;
  }

  // Send message
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    if (isReadOnly) {
      Helpers.showSnackBar(context, 'Cannot send messages in completed order', bgColor: Colors.orange);
      return;
    }

    try {
      final String url = "${ApiConfig.baseUrl}/sendMessageDoctor/${widget.order.orderId}";
      final Map<String, dynamic> requestBody = {
        'text': text,
        'isBot': false,
        'userName': 'Doctor',
        'userId': 'doctor',
        'patientUserId': widget.order.userId,
        'patientUserName': widget.order.userName,
      };

      print('📤 Sending message to: $url');
      print('📦 Request body: $requestBody');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          messages.add(Message.fromMap(data));
        });
        _controller.clear();
        _scrollToBottom();
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['message'] ?? 'Failed to send message';
        Helpers.showSnackBar(context, 'Error: $errorMessage', bgColor: Colors.red);
      }
    } catch (e) {
      print('❌ sendMessage error: $e');
      Helpers.showSnackBar(context, 'Network error: $e', bgColor: Colors.red);
    }
  }

  // End Session
  Future<void> _endSession() async {
    if (isReadOnly) {
      Helpers.showSnackBar(context, 'This order is already completed', bgColor: Colors.orange);
      return;
    }

    bool confirmEnd = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("End Session"),
          content: const Text("Are you sure you want to end this session? This will complete the order and reset the chat for the patient."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text("End Session", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirmEnd != true) return;

    try {
      final String url = "${ApiConfig.baseUrl}/completeOrder/${widget.order.orderId}";

      print('🚀 Ending session for order: ${widget.order.orderId}');

      final requestBody = {
        'status': 'completed',
        'completedAt': DateTime.now().toIso8601String(),
        'completedBy': 'Doctor',
        'resetChat': true,
      };

      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          Helpers.showSnackBar(
            context,
            'Session ended successfully! Order completed and chat reset.',
            bgColor: Colors.green,
          );

          if (widget.onSessionEnded != null) {
            widget.onSessionEnded!();
          }

          Navigator.of(context).pop(true);
        } else {
          throw Exception(responseData['message'] ?? 'Failed to complete order');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ End session error: $e');
      Helpers.showSnackBar(
        context,
        'Failed to end session: ${e.toString()}',
        bgColor: Colors.red,
      );
    }
  }

  // Build file item widget
  Widget _buildFileItem(Map<String, dynamic> file) {
    final fileName = file['fileName']?.toString() ?? 'Unknown File';
    final fileSize = file['fileSize'] ?? 0;
    final fileType = file['fileType']?.toString() ?? 'file';
    final uploadedBy = file['uploadedBy']?.toString() ?? 'Unknown';
    final category = file['category']?.toString() ?? 'Uncategorized';
    final uploadDate = file['uploadDate'] != null
        ? DateTime.tryParse(file['uploadDate'])?.toLocal() ?? DateTime.now()
        : DateTime.now();

    // Check if this file is currently downloading
    bool isDownloadingThisFile = _isDownloading && _downloadingFileName == fileName;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              _getFileIcon(fileType),
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Category: $category',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _formatFileSize(fileSize is int ? fileSize : 0),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      fileType.split('/').last.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      uploadedBy == 'patient' ? Icons.person : Icons.medical_services,
                      size: 12,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Uploaded by ${uploadedBy == 'patient' ? 'Patient' : 'Doctor'}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${uploadDate.day}/${uploadDate.month}/${uploadDate.year}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                if (isDownloadingThisFile) ...[
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Downloading...',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isDownloadingThisFile)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: Icon(
                Icons.download,
                color: AppColors.primary,
              ),
              onPressed: () => _downloadFile(file),
            ),
        ],
      ),
    );
  }

  // Helper methods for file display
  IconData _getFileIcon(String fileType) {
    if (fileType.toLowerCase().contains('image')) return Icons.image;
    if (fileType.toLowerCase().contains('pdf')) return Icons.picture_as_pdf;
    if (fileType.toLowerCase().contains('word') || fileType.toLowerCase().contains('document'))
      return Icons.description;
    return Icons.insert_drive_file;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }

  // Build message bubble
  Widget _buildMessageBubble(Message msg) {
    final isDoctor = msg.userName == "Doctor";
    final alignment = isDoctor ? Alignment.centerRight : Alignment.centerLeft;
    final bgColor = isDoctor
        ? AppColors.textLight.withOpacity(0.9)
        : AppColors.primary.withOpacity(0.9);
    final textColor = isDoctor ? Colors.black87 : Colors.white;

    return Container(
      alignment: alignment,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              "${msg.createdAt?.hour.toString().padLeft(2, '0')}:${msg.createdAt?.minute.toString().padLeft(2, '0')}",
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshFiles() async {
    print('🔄 Manually refreshing files...');
    await _loadOrderFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: isReadOnly ? Colors.grey : AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 75,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.order.userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isReadOnly)
              const Text(
                "COMPLETED - VIEW ONLY",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),

        actions: [
          // Upload Access Button - Only in AppBar (Chat section)
          if (!isReadOnly && !_hasUploadAccess)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton.icon(
                onPressed: _isGrantingUploadAccess ? null : _grantUploadAccess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: _isGrantingUploadAccess
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Icon(Icons.upload_file, size: 16),
                label: _isGrantingUploadAccess
                    ? const Text(
                  "Granting...",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                )
                    : const Text(
                  "Allow Upload",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (!isReadOnly)
            Padding(
              padding: const EdgeInsets.only(right: 11.0),
              child: ElevatedButton.icon(
                onPressed: _endSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.done_all, size: 16),
                label: const Text(
                  "End Session",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            color: AppColors.primary,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(
                  icon: Icon(Icons.chat, size: 20),
                  text: 'Chat',
                ),
                Tab(
                  icon: Icon(Icons.attach_file, size: 20),
                  text: 'Files',
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Chat Tab
          _buildChatTab(),

          // Files Tab
          _buildFilesTab(),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        // Order Info Card with Upload Access Button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Consultation Details",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  // Upload Access Button in the card
                  if (!isReadOnly && !_hasUploadAccess)
                    ElevatedButton.icon(
                      onPressed: _isGrantingUploadAccess ? null : _grantUploadAccess,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: _isGrantingUploadAccess
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Icon(Icons.upload_file, size: 16),
                      label: _isGrantingUploadAccess
                          ? const Text(
                        "Granting...",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      )
                          : const Text(
                        "Allow Upload",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.medical_services, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text("${widget.order.doctorType} - ${widget.order.speciality}"),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text("Patient: ${widget.order.userName}"),
                ],
              ),
              // Upload Access Status
              if (_hasUploadAccess)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade700, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        "Patient can upload additional reports",
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: messages.isEmpty
              ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No messages yet",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Start the conversation with your patient",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(10),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return _buildMessageBubble(messages[index]);
            },
          ),
        ),
        if (!isReadOnly) _buildMessageInput(),
        if (isReadOnly) _buildReadOnlyMessage(),
      ],
    );
  }

  Widget _buildFilesTab() {
    return Column(
      children: [
        // Header with file count and refresh
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Medical Reports & Files",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    "${files.length} file(s) found",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  // Upload Access Info in Files Tab
                  if (_hasUploadAccess)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Patient can upload more files",
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: AppColors.primary),
                onPressed: _loadOrderFiles,
                tooltip: 'Refresh Files',
              ),
            ],
          ),
        ),

        // Debug info panel
        if (files.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue.shade600, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Files will be saved in /MediConnect folder in your device storage',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Files list
        Expanded(
          child: _buildFilesList(),
        ),
      ],
    );
  }

  Widget _buildFilesList() {
    if (_isLoadingFiles) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Loading medical reports..."),
          ],
        ),
      );
    }

    if (files.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No medical reports uploaded yet",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          Text(
            "Patient uploaded files will appear here",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshFiles,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          if (file is Map<String, dynamic>) {
            return _buildFileItem(file);
          } else {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Text(
                'Invalid file format at index $index: ${file.toString()}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(21),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration.collapsed(
                    hintText: "Type your message here",
                  ),
                  onChanged: (text) {
                    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.textLight,
              child: IconButton(
                icon: const Icon(Icons.send, color: AppColors.primary),
                onPressed: () => sendMessage(_controller.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "This order is completed - Chat history view only",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}