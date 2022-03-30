import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController name = TextEditingController();

  var supabaseurl = "https://bnjptzhrjghpqqnoytxf.supabase.co";
  var supabasekey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuanB0emhyamdocHFxbm95dHhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDg2MjYxMzUsImV4cCI6MTk2NDIwMjEzNX0.nTA6kwHsiIYobGpzIQhaLoJbf1n6tqTBPu11tU0zJ3Y";


  insertUser() async {
    var client = SupabaseClient(supabaseurl, supabasekey);

    
    var response = await client.from('kisiler').insert([
      {'name': 'deneme'}
    ]).execute();

    print(response.data);

  }

  loadImage()
  async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(allowMultiple: false, dialogTitle: "Seçiniz");
    final file = File(pickedFile!.files.first.path.toString());
    var client = SupabaseClient(supabaseurl, supabasekey);
    await client.storage.from("profile-photos").upload(pickedFile.files.first.name, file).then((value) =>
    {
      print(value)
    }
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supabase"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [

                TextButton(
                    onPressed: (){
                      insertUser();
                    },
                    child: Text("Ekle"))
              ],
            ),
            Row(
              children: [

                TextButton(
                    onPressed: (){
                      loadImage();
                    },
                    child: Text("Yükle"))
              ],
            )
          ],
        ),
      ),
    );
  }
}


