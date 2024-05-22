import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart'; // Intl kütüphanesini ekledik
import 'dart:async'; // Timer sınıfını kullanmak için ekledik
import 'package:flutter_qryoklamasistemi/main.dart';

void main() {
  initializeDateFormatting('tr_TR', ''); // Türkçe yerel ayarları başlatıyoruz
  runApp(const StudentHome());
}

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Öğrenci Ana-Sayfa',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String formattedDateTime =
      ''; // Saat bilgisini saklamak için bir değişken tanımladık
  late Timer _timer; // Timer nesnesini burada tanımlıyoruz

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
  }

  @override
  void dispose() {
    _timer.cancel(); // Timer'ı dispose() yönteminde iptal ediyoruz
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          width: 100, // Genişlik
                          height: 100, // Yükseklik
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
                        const Text(
                          'example@topkapi.com',
                          style: TextStyle(
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
                        builder: (context) => const QRyoklamasistemi(),
                      ),
                    );
                    // Çıkış butonuna tıklandığında yapılacak işlemler
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
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      "Hoş Geldiniz\nSn. İsim Soyisim",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  Padding(
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
                            child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0) {
                                  return const SizedBox.shrink();
                                }
                                return Container(
                                  decoration: const BoxDecoration(
                                    border:
                                        BorderDirectional(top: BorderSide()),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      'Ders $index',
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
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
