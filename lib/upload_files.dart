import 'package:flutter/material.dart';

class UploadFiles extends StatefulWidget {
  const UploadFiles({super.key});

  @override
  State<UploadFiles> createState() => _UploadFilesState();
}

class _UploadFilesState extends State<UploadFiles> {
  String? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0D4F45),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Upload files',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    Container(
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey.shade400,
                          style: BorderStyle.solid,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.cloud_upload_outlined,size: 48,),
                            SizedBox(height: 8,),
                            Text(
                              "Tap To browse files",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 12,),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF0D4F45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    )
                              ),
                              onPressed: (){

                            },
                              child: Text("Browse File",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),
                            ),
                          ],

                        ),
                      ),
                    ),

                  SizedBox(height: 24,),
                  if(_selectedFile != null) ...[
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.picture_as_pdf,color: Colors.red,),
                          SizedBox(height: 12,),
                          Expanded(
                            child: Text(
                              _selectedFile!,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: ()=>setState(() =>_selectedFile=null),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24,),
                  ],
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0D4F45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            )
                        ),
                        onPressed: _selectedFile == null ? null : (){},
                        child: Text("Submit report",style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                    ),
                  )
                ],

              ),
      ),
      ),
    );
  }
}
