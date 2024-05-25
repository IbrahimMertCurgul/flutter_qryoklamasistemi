import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'student_page.dart';

class ScanQR extends StatefulWidget {
  final String studentId;
  final String number;
  final int hafta;
  final String ders;

  const ScanQR(
      {super.key,
      required this.studentId,
      required this.number,
      required this.hafta,
      required this.ders});

  @override
  State<StatefulWidget> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  late String qrText = '';
  String hintText = '';
  Timer? timer;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.scannedDataStream.listen((scandata) {
        if (!isProcessing) {
          setState(() {
            qrText = scandata.code!;
            hintText = "Hazır!";
            isProcessing = true; // İşlem başladığında flag'i ayarla
          });

          // Her 2 saniyede bir firestorequery fonksiyonunu çalıştır
          timer?.cancel(); // Eski timer'ı iptal et
          timer = Timer.periodic(Duration(seconds: 2), (timer) {
            firestorequery();
          });
        }
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

          // 'passValue' ile 'qrText' eşleşirse 'number'ı listeye ekle
          if (passValue == qrText) {
            haftaList.add(widget.number);

            // Firestore'da güncelle
            await docRef.update({week: haftaList});

            // İşlem başarıyla tamamlandığında hintText güncelle
            setState(() {
              hintText = "İşlem Başarılı!";
            });

            // 2 saniye bekle ve ardından yönlendir
            timer?.cancel();
            await Future.delayed(Duration(seconds: 2), () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Başarılı'),
                    content: Text('Ana sayfaya yönlendiriliyorsunuz...'),
                  );
                },
              );

              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => StudentPage(
                            studentId: widget.studentId,
                          )),
                );
              });
            });
            return; // İşlem başarılı, fonksiyondan çık
          }
        }
        setState(() {
          hintText = 'Geçersiz QR kodu.';
          isProcessing = false; // İşlem başarısız, tekrar tarama yapılabilir
        });
      } else {
        setState(() {
          hintText = 'Belge bulunamadı.';
          isProcessing = false; // İşlem başarısız, tekrar tarama yapılabilir
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        hintText = 'Hata oluştu.';
        isProcessing = false; // İşlem başarısız, tekrar tarama yapılabilir
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Positioned(
            top: 300.0,
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
          Align(
            alignment: Alignment.center,
            child: FractionalTranslation(
              translation: Offset(0, 5), // Bu değer widget'ı aşağı taşır
              child: Text(
                hintText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
              bottom: 80.0,
              left: 150,
              child: RawMaterialButton(
                onPressed: () {
                  firestorequery();
                },
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.check,
                  size: 35.0,
                ),
              )),
        ],
      ),
    );
  }
}
