import 'package:flutter/material.dart';
import 'package:flutter_qryoklamasistemi/auth.dart';
import 'package:flutter_qryoklamasistemi/main.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("giriş yapıldı");
          return const QRyoklamasistemi();
        } else {
          print("hata oluştu");
          return const QRyoklamasistemi();
        }
      },
    );
  }
}
