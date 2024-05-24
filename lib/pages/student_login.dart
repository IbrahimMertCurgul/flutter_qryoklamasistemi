import 'package:flutter/material.dart';
import 'package:flutter_qryoklamasistemi/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_page.dart'; // StudentPage sayfasının import edildiği yer
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('tr_TR', ''); // Türkçe yerel ayarları başlatıyoruz
  runApp(const StudentLoginPage());
}

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({super.key});

  @override
  State<StudentLoginPage> createState() => _LoginPageState();
}

class PasswordField extends StatefulWidget {
  final String title;
  final TextEditingController controller;

  PasswordField({required this.title, required this.controller});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        labelText: widget.title,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}

class _LoginPageState extends State<StudentLoginPage> {
  final TextEditingController _controllerUser = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();

  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('students');

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
        labelText: 'Öğrenci Numarası',
      ),
    );
  }

  String _errorMessage = "";

  Future<void> _signIn() async {
    final String number = _controllerUser.text;
    final String password = _controllerPass.text;

    try {
      QuerySnapshot<Map<String, dynamic>> studentSnapshots =
          await _studentsCollection.where('number', isEqualTo: number).get()
              as QuerySnapshot<Map<String, dynamic>>;

      if (studentSnapshots.docs.isNotEmpty) {
        // Numara ile eşleşen bir döküman bulundu
        final DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
            studentSnapshots.docs.first;

        final Map<String, dynamic>? data = studentSnapshot.data();

        // Veri null değilse kontrol et
        if (data != null) {
          // Şifreyi kontrol et
          if (data['password'] == password) {
            // Giriş başarılı olduğunda LecturerPage sayfasına yönlendir
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    StudentPage(studentId: studentSnapshot.id),
              ),
            );
          } else {
            // Hatalı şifre durumunda hata mesajını göster
            setState(() {
              _errorMessage = 'Hatalı şifre';
            });
          }
        } else {
          // Veri bulunamadığında hata mesajını göster
          setState(() {
            _errorMessage = 'Hata: Veri bulunamadı';
          });
        }
      } else {
        // Öğretmen bulunamadığında hata mesajını göster
        setState(() {
          _errorMessage =
              'Kayıt bulunamadı. Giriş bilgilerinizi kontrol ediniz.';
        });
      }
    } catch (e) {
      // Diğer hata durumlarında hata mesajını göster
      setState(() {
        _errorMessage = 'Hata: $e';
      });
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
                            leading: BackButton(
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const QRyoklamasistemi(),
                                  ),
                                );
                              },
                            ),
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
                                  text: 'Öğrenci',
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
                          if (_errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ////////////////////////////ÖĞRENCİ INPUT/////////////////////////////////
                          Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: _entryUser("number", _controllerUser)),
                          ////////////////////////////ŞİFRE INPUT/////////////////////////////////
                          Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: PasswordField(
                                  title: "Şifre", controller: _controllerPass)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          _signIn();
                        },
                        child: const Text(
                          'Giriş Yap',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ),
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
                                "Öğrenci Girişi",
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
                                      "Öğrenci numarası", _controllerUser)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                              child: SizedBox(
                                  width: 500,
                                  child: PasswordField(
                                      title: "Şifre",
                                      controller: _controllerPass)),
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
                            if (_errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  _errorMessage,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                      ),
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
