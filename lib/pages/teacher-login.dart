import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'teacher-page.dart'; // TeacherHomePage sayfasının import edildiği yer
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('tr_TR', ''); // Türkçe yerel ayarları başlatıyoruz
  runApp(TeacherLoginPage());
}

class TeacherLoginPage extends StatefulWidget {
  @override
  State<TeacherLoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<TeacherLoginPage> {
  final TextEditingController _controllerUser = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();

  final CollectionReference _lecturersCollection =
      FirebaseFirestore.instance.collection('lecturers');

  Widget _entryUser(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      obscureText: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        labelText: 'Kullanıcı Adı',
      ),
    );
  }

  Widget _entryPass(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      obscureText: true, //ŞİFREYİ GİZLİ YAPMA
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        labelText: 'Şifre',
      ),
    );
  }

  Future<void> _signIn() async {
    final String username = _controllerUser.text;
    final String password = _controllerPass.text;

    try {
      QuerySnapshot<Map<String, dynamic>> lecturerSnapshots =
          await _lecturersCollection
              .where('username', isEqualTo: username)
              .get() as QuerySnapshot<Map<String, dynamic>>;

      if (lecturerSnapshots.docs.isNotEmpty) {
        // Username ile eşleşen bir döküman bulundu
        final DocumentSnapshot<Map<String, dynamic>> lecturerSnapshot =
            lecturerSnapshots.docs.first;

        final Map<String, dynamic>? data = lecturerSnapshot.data();

        // Veri null değilse kontrol et
        if (data != null) {
          // Şifreyi kontrol et
          if (data['password'] == password) {
            // Giriş başarılı olduğunda MyHomePage sayfasına yönlendir
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TeacherPage(lecturerId: lecturerSnapshot.id),
              ),
            );
          } else {
            print('Hatalı şifre');
          }
        } else {
          print('Hata: Veri bulunamadı');
        }
      } else {
        print('Öğrenci bulunamadı');
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (width < 700 && width / height < 0.8)
                Column(
                  children: [
                    Container(
                      height: height * .45,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage("assets/images/arkaplan.png"))),
                      child: Column(
                        children: [
                          AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            leading: const BackButton(color: Colors.white),
                          ),
                          Container(
                            height: height * .25,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image: AssetImage(
                                        "assets/images/topkapilogo.png"))),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                  fontSize: 24.0, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Öğretmen',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32.0),
                                ),
                                TextSpan(
                                  text: '\nGirişi',
                                ),
                              ],
                            ),
                          ),
                          ////////////////////////////ÖĞRENCİ INPUT/////////////////////////////////
                          Padding(
                              padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                              child: _entryUser("username", _controllerUser)),
                          ////////////////////////////ŞİFRE INPUT/////////////////////////////////
                          Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: _entryPass("password", _controllerPass)),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _signIn();
                          },
                          child: const Text(
                            'Giriş Yap',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        )),
                  ],
                )
              else
                Container(
                  height: height,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 138, 35, 50),
                    Color.fromARGB(255, 78, 4, 19),
                  ])),
                  child: Column(
                    children: [
                      Container(
                        height: height * .25,
                        margin: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: AssetImage(
                                    "assets/images/topkapilogo.png"))),
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                              child: Text(
                                "Öğretmen Girişi",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                              child: SizedBox(
                                  width: 500,
                                  child: _entryUser(
                                      "Kullanıcı Adı", _controllerUser)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                              child: SizedBox(
                                  width: 500,
                                  child: _entryPass("şifre", _controllerPass)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: SizedBox(
                                height: 50.0,
                                width: 200.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _signIn,
                                    child: const Text(
                                      'Giriş Yap',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
