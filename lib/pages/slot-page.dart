import 'package:flutter/material.dart';
import 'teacher-page.dart';

void main() {
  runApp(const SlotPage());
}

class SlotPage extends StatelessWidget {
  const SlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '12 Haftalık Ders Slotu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: slotsPage(),
      routes: {
        '/teacher-page': (context) => const TeacherHome(), // TeacherHome sayfası
      },
    );
  }
}

class slotsPage extends StatelessWidget {
  final List<String> weeks = List.generate(12, (index) => 'Hafta ${index + 1}');

  slotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Varsayılan geri butonunu kaldır
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/teacher-page');
                },
              ),
              const SizedBox(
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
        decoration: const BoxDecoration(
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
                            const TeacherHome()), // QRyoklamasistemi sayfasına geçiş
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.white.withOpacity(0.8), // Correct property name
                  foregroundColor: Colors.black, // Correct property name
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16.0), // Köşeleri hafif yuvarlat
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0), // Buton boyutları
                ),
                child: const Text('Çıkış'),
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

  const WeekTile({super.key, required this.week});

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
      margin: const EdgeInsets.all(8.0),
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
              style: const TextStyle(color: Colors.white),
            ),
            onTap: _toggleExpand,
          ),
          if (_isExpanded)
            const Padding(
              padding: EdgeInsets.all(8.0),
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
