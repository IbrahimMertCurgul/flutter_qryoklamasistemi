import 'package:flutter/material.dart';
import 'package:flutter_qryoklamasistemi/pages/teacher-login.dart';
import 'pages/student-login.dart';
<<<<<<< HEAD
=======
import 'pages/teacher-login.dart';
import 'pages/teacher-page.dart';
>>>>>>> parent of effa27f (TeacherPage1.1)
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MaterialApp(home: QRyoklamasistemi()),
  );
}

class QRyoklamasistemi extends StatelessWidget {
  const QRyoklamasistemi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 138, 35, 50),
            Color.fromARGB(255, 78, 4, 19),
          ]),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 125.0),
              child: SizedBox(
                height: 200,
                width: 200,
                child:
                    Image(image: AssetImage('assets/images/topkapilogo.png')),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Hoşgeldiniz',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentLoginPage()));
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'ÖĞRENCİ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
<<<<<<< HEAD
                            const MyHomePage())); //const TeacherLoginPage()
=======
                            TeacherLoginPage())); //const TeacherLoginPage()
>>>>>>> bbe7607460b2acf46ee889d1a5c4968cc001120a
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'AKADEMİSYEN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'İSTANBUL TOPKAPI ÜNİVERSİTESİ',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
