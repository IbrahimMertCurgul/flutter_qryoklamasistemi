// ignore_for_file: file_names
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_qryoklamasistemi/main.dart';
=======

void main() {
  runApp(const TeacherHome());
}

class TeacherHome extends StatelessWidget {
  const TeacherHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Öğretmen Ana-Sayfa',
      home: MyHomePage(),
    );
  }
}
>>>>>>> bbe7607460b2acf46ee889d1a5c4968cc001120a

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 138, 35, 50),
              ),
              child: Text(
                'Drawer Başlık',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Öğe 1'),
              onTap: () {
                // Drawer öğesine tıklandığında yapılacak işlemler
              },
            ),
            ListTile(
              title: const Text('Öğe 2'),
              onTap: () {
                // Drawer öğesine tıklandığında yapılacak işlemler
              },
            ),
          ],
        ),
      ),
      /************************GÖVDE******************************/
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 138, 35, 50),
                Color.fromARGB(255, 78, 4, 19),
              ], // İstediğiniz renkleri burada tanımlayabilirsiniz
            ),
          ),
          child: Column(
            children: [
              /*************/
              AppBar(
                backgroundColor: Colors.transparent,
                // Hamburger menü
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
              /**************/
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                        style: TextStyle(color: Colors.white, fontSize: 30),
                        "Hoş Geldiniz\nSn. İsim Soyisim"),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Icon(Icons.person, size: 65, color: Colors.white),
                  )
                ],
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                    child: Text(
                        style: TextStyle(color: Colors.white, fontSize: 26),
                        "13 Nisan 2024\n13:45"),
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
                      /**************************DERSLERİM***************************/
<<<<<<< HEAD
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            // return the header
                            return const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Derslerim",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(height: 15),
                              ],
                            );
                          }
                          // index değerine bağlı olarak arkaplan rengini değiştir
                          return Container(
                            decoration: const BoxDecoration(
                                border: BorderDirectional(top: BorderSide())),
                            child: ListTile(
                              title: Text(
                                'Ders $index',
                                style: const TextStyle(color: Colors.black),
                              ),
=======
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(padding: const EdgeInsets.only(top: 20.0)),
                          Text(
                            "Derslerim",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 0),
                          Expanded(
                            child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0) {
                                  // return the header
                                  return SizedBox.shrink();
                                }
                                // index değerine bağlı olarak arkaplan rengini değiştir
                                return Container(
                                  decoration: BoxDecoration(
                                    border:
                                        BorderDirectional(top: BorderSide()),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      'Ders ${index}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              },
>>>>>>> bbe7607460b2acf46ee889d1a5c4968cc001120a
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
<<<<<<< HEAD
                                      const QRyoklamasistemi())); // QR Okuma ekranı ***********************
                        },
                        child: const Center(
                          child: Text(
                            'Yoklama Başlat',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
=======
                                      const TeacherHome())); // QR Okuma ekranı ***********************
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Yoklama Başlat',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
>>>>>>> bbe7607460b2acf46ee889d1a5c4968cc001120a
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
