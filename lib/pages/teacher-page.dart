import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart'; // Intl kütüphanesini ekledik
import 'dart:async'; // Timer sınıfını kullanmak için ekledik
import 'package:cloud_firestore/cloud_firestore.dart';
import 'slot-page.dart'; // Bu sayfanın bulunduğundan emin olun

void main() {
  initializeDateFormatting('tr_TR', ''); // Türkçe yerel ayarları başlatıyoruz
  runApp(const TeacherHome());
}

class TeacherHome extends StatelessWidget {
  const TeacherHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Öğretmen Ana-Sayfa',
      initialRoute: '/',
      routes: {
        '/': (context) => const TeacherPage(
            lecturerId: '2ejyrhmrJVdLfDCyjF8n'), // Ana sayfa buraya gelecek
        '/slot-page': (context) => const SlotsPage(), // SlotPage sayfası
        // Diğer sayfaların rotalarını da ekleyebilirsiniz
      },
    );
  }
}

class TeacherPage extends StatefulWidget {
  final String lecturerId; // ÖĞRENCİ ID
  const TeacherPage({required this.lecturerId, super.key});

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  String formattedDateTime =
      ''; // Saat bilgisini saklamak için bir değişken tanımladık
  late Timer _timer; // Timer nesnesini burada tanımlıyoruz
  String teacherName = ''; //Öğretmen ismi
  String teacherEmail = ''; //öğretmen maili

  Future<String> getTeacherImage(String lecturerId) async {
    String defaultImage =
        "assets/images/default_image.png"; // Varsayılan bir resim

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('lecturers')
          .doc(lecturerId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('img')) {
          // 'img' alanı mevcutsa resim referansını döndür
          return data['img'];
        }
      }
    } catch (e) {
      print("Error getting teacher image: $e");
    }

    return defaultImage; // Hata durumunda veya resim bulunamadığında varsayılan resmi döndür
  }

  @override
  void initState() {
    super.initState();
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
    FirebaseFirestore.instance
        .collection('lecturers')
        .doc(widget.lecturerId)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          teacherName = (snapshot.data() as Map<String, dynamic>)['name'];
          teacherEmail = (snapshot.data() as Map<String, dynamic>)[
              'email']; // Firestore'daki 'name' alanından değeri al
        });
      } else {
        setState(() {
          teacherName =
              'Bilinmeyen Öğretmen'; // Eğer belge bulunamazsa varsayılan değeri kullan
        });
      }
    }).catchError((error) {
      setState(() {
        teacherName = 'Hata: $error'; // Hata durumunda hata mesajını kullan
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
    final FirebaseFirestore firestore =
        FirebaseFirestore.instance; // Firestore bağlantısı

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
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
                        Text(
                          teacherEmail,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
                            const TeacherHome(), // Bu sınıfın mevcut olduğundan emin olun
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
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      "Hoş Geldiniz\n$teacherName",
                      style: const TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Icon(Icons.person, size: 65, color: Colors.white),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                    child: Text(
                      formattedDateTime,
                      style: const TextStyle(color: Colors.white, fontSize: 26),
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
                                  .collection('lecturers')
                                  .doc(widget.lecturerId)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }

                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return const Center(
                                      child: Text('No data found'));
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
                                        // 'slotsPage' sayfasına yönlendir
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Slots(
                                              lecturerID: widget.lecturerId,
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
                                            bottom: index == classes.length - 1
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
                          )
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
                          /* Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QRyoklamasistemi(),
                            ),
                          ); */
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Yoklama Başlat',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.qr_code, size: 30, color: Colors.black),
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
    );
  }
}
