import 'package:flutter/material.dart';
import 'package:flutter_qryoklamasistemi/main.dart';

void main() {
  runApp(SlotPage());
}

class SlotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '12 Haftalık Ders Slotu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<String> weeks = List.generate(12, (index) => 'Hafta ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Varsayılan geri butonunu kaldır
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 138, 35, 50),
                Color.fromARGB(255, 78, 4, 19),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  // Geri butonuna basıldığında yapılacak işlemler
                  // Navigator.pop(context);
                },
              ),
              SizedBox(
                  width: 110), // Geri butonu ile logo arasında biraz boşluk
              Image.asset(
                'assets/images/topkapilogo.png', // PNG resminizin yolu
                fit: BoxFit.contain,
                height: 85.0, // AppBar yüksekliğiyle uyumlu olacak şekilde
              ),
              Expanded(child: Container()), // Geriye kalan alanı doldurmak için
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 138, 35, 50),
              Color.fromARGB(255, 78, 4, 19),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: weeks.length,
                itemBuilder: (context, index) {
                  return WeekTile(week: weeks[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Çıkış butonuna basıldığında yapılacak işlemler
                  // Örneğin, uygulamadan çıkış yapmak için:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QRyoklamasistemi()), // QRyoklamasistemi sayfasına geçiş
                  );
                },
                child: Text('Çıkış'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white.withOpacity(0.8),
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16.0), // Köşeleri hafif yuvarlat
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0), // Buton boyutları
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeekTile extends StatefulWidget {
  final String week;

  WeekTile({required this.week});

  @override
  _WeekTileState createState() => _WeekTileState();
}

class _WeekTileState extends State<WeekTile> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.week,
              style: TextStyle(color: Colors.white),
            ),
            onTap: _toggleExpand,
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Bu hafta için detaylar buraya gelecek.',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
