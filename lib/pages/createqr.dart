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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              "QR Kodu Okutun",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
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
                color: Colors.black54,
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
          const SizedBox(height: 100),
          Text(
            "$ders Dersi \n $hafta. Hafta Yoklaması",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
  var document = querySnapshot.docs.first;
  FirebaseFirestore.instance.collection('classes').doc(document.id).update({
    'Hafta $hafta': {'pass': passCode}
  });
}
