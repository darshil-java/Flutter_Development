import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),//Make drawer Icon White With This
        backgroundColor: Color(0xFF0D4F45),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text("VSGLogic ChatApp",
              style: TextStyle(
                  color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: (){

            }, icon: Icon(Icons.person_outline_sharp,)),
          )
        ],

      ),

      drawer: Drawer(
        backgroundColor: Color(0xFF0D4F45),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                ListTile(
                  tileColor: Colors.teal,
                  leading: Icon(
                    Icons.home,
                    size: 25,
                    color: Colors.teal.shade100,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Home",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ),
                SizedBox(height: 10),


                new Divider(
                  color: Colors.teal.shade100,
                  thickness: 2,
                  indent: 12,
                ),

                SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.add,
                    size: 25,
                    color: Colors.teal.shade100,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Doctor",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ),

                SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.file_copy_sharp,
                    size: 25,
                    color: Colors.teal.shade100,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Orders",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ),

                SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.privacy_tip,
                    size: 25,
                    color: Colors.teal.shade100,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Terms & Privacy",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ),

                SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.logout_sharp,
                    size: 25,
                    color: Colors.teal.shade100,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("LogOut",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ),

                SizedBox(height: 10),
                new Divider(
                  color: Colors.teal.shade100,
                  thickness: 2,
                  indent: 12,
                ),


                SizedBox(height: 50),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text("Made With",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 12),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(Icons.favorite,color: Colors.teal.shade100,size: 14,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text("By VSGLogic",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 12),),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

          ),
        ),
      ),


      body: Column(
        children: [
          Expanded(
              child: Container()
          ),
          SafeArea(
            child: Container(
               padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
               color: Color(0xFF0D4F45),
               child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/upload'),
                      child: Icon(Icons.attach_file, color: Colors.teal.shade100),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21)
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Type A Message",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    Icon(Icons.send,color: Colors.teal.shade100),
                  ],
                ),
             ),
          ),
        ],
      ),
    );
  }
}
