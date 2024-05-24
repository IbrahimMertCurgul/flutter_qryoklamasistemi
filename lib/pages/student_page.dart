import 'package:flutter/material.dart';
import 'package:flutter_qryoklamasistemi/pages/student_login.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'student_slot_page.dart';

class StudentPage extends StatefulWidget {
  final String studentId;
  const StudentPage({required this.studentId, super.key});

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  String formattedDateTime = ''; // Saat bilgisini saklayan değişken
  late Timer _timer; // Timer nesnesini burada tanımlıyoruz
  String studentName = ''; //Öğrenci ismi
  String studentEmail = ''; //öğrenci maili

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR', ''); // DateFormat için tr_TR dil

    // Zamanlayıcıyı başlatmak için initState içinde Timer.periodic'i kullanıyoruz
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      // Saat bilgisini her dakika başında güncelliyoruz
      setState(() {
        formattedDateTime =
            DateFormat('dd MMMM yyy\nHH:mm', 'tr_TR').format(DateTime.now());
      });
    });
    // Başlangıçta saat bilgisini de güncelliyoruz
    formattedDateTime =
        DateFormat('dd MMMM yyy\nHH:mm', 'tr_TR').format(DateTime.now());

    //Firestore'dan veri alma işlemleri:
    FirebaseFirestore.instance
        .collection('students')
        .doc(widget.studentId)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          studentName = (snapshot.data() as Map<String, dynamic>)['name'];
          studentEmail = (snapshot.data() as Map<String, dynamic>)['email'];
        });
      } else {
        setState(() {
          studentName =
              'Bilinmeyen Öğrenci'; // Eğer belge bulunamazsa varsayılan değeri kullan
        });
      }
    }).catchError((error) {
      setState(() {
        studentName = 'Hata: $error'; // Hata durumunda hata mesajını kullan
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Timer'ı dispose() yönteminde iptal ediyoruz
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Firestore bağlantısı:
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return MaterialApp(
      routes: {
        '/student-page': (context) => StudentPage(
              studentId: widget.studentId,
            ),
      },
      home: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    //Drawer Kodları:
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 138, 35, 50),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            padding: EdgeInsets.zero,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/topkapilogo.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              studentEmail,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const StudentLoginPage(), // Bu sınıfın mevcut olduğundan emin olun
                        ),
                      );
                    },
                    child: const ListTile(
                      title: Center(child: Text('Çıkış')),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromARGB(255, 138, 35, 50),
                  Color.fromARGB(255, 78, 4, 19),
                ],
              ),
            ),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(Icons.menu),
                        color: Colors.white,
                        iconSize: 40,
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        "Hoş Geldiniz\n$studentName",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                    if (studentName.length <=
                        14) //İsim uzunluğu 14 karakterden kısaysa profil ikonu ekle
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child:
                            Icon(Icons.person, size: 65, color: Colors.white),
                      )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                      child: Text(
                        formattedDateTime,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 26),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.height / 3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 20.0)),
                            const Text(
                              "Derslerim",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 0),
                            Expanded(
                              child: FutureBuilder<DocumentSnapshot>(
                                future: firestore
                                    .collection('students')
                                    .doc(widget.studentId)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  }

                                  if (!snapshot.hasData ||
                                      !snapshot.data!.exists) {
                                    return const Center(
                                        child: Text('Veri Bulunamadı'));
                                  }

                                  var studentData = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                  List<String> classes =
                                      List<String>.from(studentData['classes']);

                                  return ListView.builder(
                                    itemCount: classes.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentSlotsPage(
                                                studentId: widget.studentId,
                                                ders: classes[index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: const BorderSide(
                                                  color: Colors
                                                      .grey), // Her öğe için üst kenarlık
                                              bottom: index ==
                                                      classes.length - 1
                                                  ? const BorderSide(
                                                      color: Colors.grey)
                                                  : BorderSide
                                                      .none, // Son öğe için alt kenarlık, diğerleri için yok
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Text(classes[index]),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: GestureDetector(
                          onTap: () {
                            // QR Okuma ekranına yönlendir
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Yoklamaya Katıl',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.qr_code,
                                  size: 30, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
