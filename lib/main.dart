import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:get_it/get_it.dart';
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
  TextEditingController password = TextEditingController();
  String? uid="";
  String src="";

  var supabaseurl = "https://bnjptzhrjghpqqnoytxf.supabase.co";
  var supabasekey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuanB0emhyamdocHFxbm95dHhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDg2MjYxMzUsImV4cCI6MTk2NDIwMjEzNX0.nTA6kwHsiIYobGpzIQhaLoJbf1n6tqTBPu11tU0zJ3Y";


  login()
  async {
    var client = SupabaseClient(supabaseurl, supabasekey);
    final result = await client.auth.signIn(email: name.text, password: password.text);
    uid= result.user?.id;

    print(result.user?.id);

  }

  insertUser() async {
    var client = SupabaseClient(supabaseurl, supabasekey);

    await client.from('kisiler').insert([
      {'name': name.text, 'uid': uid, 'pic_url': src}
    ]).execute();

  }

  loadImage()
  async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(allowMultiple: false, dialogTitle: "Seçiniz");
    final file = File(pickedFile!.files.first.path.toString());
    var client = SupabaseClient(supabaseurl, supabasekey);
    await client.storage.from("profile-photos").upload(uid!, file).then((value) =>
    {
      print(value)
    }
    );

    print("DOSYA İSMİ $uid");
    final urlResponse = await client.storage.from('profile-photos').createSignedUrl(uid!, 60);

    src=urlResponse.data!;

    await client.from('kisiler').update({'pic_url': src}).match({'uid': uid}).execute();// Profil fotoğrafı url'si kişi tablosuna yazılması gerekli. Bunu giriş yaptıktan sonra yapabiliyor.

    setState(() {

    });

  }

  signUp()
  async {

    GetIt getIt = GetIt.instance;
    getIt.registerSingleton<SupabaseClient>(SupabaseClient(supabaseurl,supabasekey));
    await GetIt.instance<SupabaseClient>().auth.signUp(name.text, password.text).then((value) =>
    {
      print(value.data?.user?.id),
      uid=value.data?.user?.id // Posta kutusuna giden emaili doğrulamadan user id gönderilmiyor.
    });

    insertUser();

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

                Container(
                  width: 200,
                  child: TextFormField(
                    controller: name,
                  ),
                )
              ],
            ),
            Row(
              children: [

                Container(
                  width: 200,
                  child: TextFormField(
                    controller: password,
                  ),
                )
              ],
            ),
            Row(
              children: [

                TextButton(
                    onPressed: (){
                      login();
                    },
                    child: Text("Giriş"))
              ],
            ),
            Row(
              children: [

                TextButton(
                    onPressed: (){
                      signUp();
                    },
                    child: Text("Kayıt"))
              ],
            ),
            Row(
              children: [

                TextButton(
                    onPressed: (){
                      loadImage();
                    },
                    child: Text("Resim ekle"))
              ],
            ),
            Row(
              children: [

                Container(
                    width: 300,
                    height: 300,
                    child: Image.network(src)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
