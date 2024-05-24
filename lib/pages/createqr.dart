import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_qryoklamasistemi/pages/lecturer_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import 'package:timer_count_down/timer_count_down.dart';

class CreateQR extends StatelessWidget {
  final String ders;
  final int hafta;
  final String lecturerId;

  const CreateQR({
    required this.ders,
    required this.hafta,
    required this.lecturerId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 138, 35, 50),
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          "İstanbul Topkapı\nÜniversitesi",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ), // Logoyu AppBar'ın ortasına yerleştirir
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 138, 35, 50),
            Color.fromARGB(255, 78, 4, 19),
          ]),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 180,
            ),
            const Center(
              child: Text(
                "QR Kodu Okutun",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FutureBuilder<int>(
              future: generateRandomNumber(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  sendPassCode(ders, snapshot.data.toString(),
                      hafta); // sendPassCode'ı burada çağır
                  return Container(
                    margin: EdgeInsets.fromLTRB(65, 0, 65, 0),
                    color: Colors.white,
                    alignment: Alignment.topCenter,
                    child: QrImageView(
                      data: snapshot.data.toString(),
                      size: 250.0,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 50),
            Countdown(
              seconds: 600,
              build: (BuildContext context, double time) => Text(
                'Kalan Süre: ${time.toInt()} saniye',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              interval: const Duration(seconds: 1),
              onFinished: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LecturerPage(
                              lecturerId: lecturerId,
                            )));
              },
            ),
            const SizedBox(height: 60),
            Text(
              "$ders Dersi \n $hafta. Hafta Yoklaması",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

Future<int> generateRandomNumber() async {
  var rng = Random();
  return rng.nextInt(999999);
}

Future<void> sendPassCode(String ders, String passCode, int hafta) async {
  final collection = FirebaseFirestore.instance.collection("classes");
  var querySnapshot =
      await collection.where('classname', isEqualTo: ders).get();

  if (querySnapshot.docs.isEmpty) {
    print('No documents found for class: $ders');
    return;
  }

  var document = querySnapshot.docs.first;

  // Hafta X alanını güncelle veya oluştur ve bir dizi olarak ayarla
  await FirebaseFirestore.instance
      .collection('classes')
      .doc(document.id)
      .update({
    'Hafta $hafta': [
      {'pass': passCode}
    ]
  });
}
