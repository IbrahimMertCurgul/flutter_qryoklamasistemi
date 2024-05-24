import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQR extends StatefulWidget {
  final String studentId;
  final String number;
  final int hafta;
  final String ders;

  const ScanQR(
      {Key? key,
      required this.studentId,
      required this.number,
      required this.hafta,
      required this.ders})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  late String qrText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.scannedDataStream.listen((scandata) {
        setState(() {
          qrText = scandata.code!;
          print('QR Kodu: $qrText'); // Log ekle
        });
      });
    });
  }

  Future<void> firestorequery() async {
    String week = 'Hafta ${widget.hafta}';
    try {
      // Ders adıyla eşleşen belgeyi bul
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('classes')
          .where('classname', isEqualTo: widget.ders)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // İlk eşleşen belgeyi al
        DocumentSnapshot doc = querySnapshot.docs.first;
        DocumentReference docRef = doc.reference;

        // 'week' değişkeniyle eşleşen alanı bul
        List<dynamic> haftaList = doc[week];

        if (haftaList.isNotEmpty && haftaList[0] is Map) {
          Map<String, dynamic> firstElement = haftaList[0];
          String passValue = firstElement['pass'];
          print('First element "pass" value: $passValue');

          // 'passValue' ile 'qrText' eşleşirse 'number'ı listeye ekle
          if (passValue == qrText) {
            haftaList.add(widget.number);

            // Firestore'da güncelle
            await docRef.update({week: haftaList});
            print('Number added to the week list.');
          }
        }
      } else {
        print('Belge bulunamadı.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Telefonunuzu sabit tutun metnini number değişkenine göre güncelle
    String hintText = '${widget.number},${qrText}';
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Positioned(
            top: 600.0,
            right: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hintText,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            top: 300.0, // İsteğe bağlı olarak ayarlanabilir
            right: 90.0,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset("assets/images/scanner.png"),
            ),
          ),
          Positioned(
            bottom: 30.0, // İsteğe bağlı olarak ayarlanabilir
            left: 100, // İsteğe bağlı olarak ayarlanabilir
            child: ElevatedButton(
              onPressed: () {
                // Butona basıldığında Firestore sorgusunu yap
                firestorequery();
              },
              child: Text(
                'Veritabanına Ekle',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
