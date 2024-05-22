import 'package:flutter/material.dart';
import 'teacher-page.dart';

void main() {
  runApp(const SlotsPage());
}

class SlotsPage extends StatelessWidget {
  const SlotsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '12 Haftalık Ders Slotu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Slots(
          lecturerID: 'your_lecturer_id'), // lecturerID değeri buraya ekleniyor
      routes: {
        '/teacher-page': (context) =>
            const TeacherHome(), // TeacherHome sayfası
      },
    );
  }
}

class Slots extends StatelessWidget {
  final List<String> weeks = List.generate(12, (index) => 'Hafta ${index + 1}');
  final String lecturerID; // lecturerID burada tanımlandı

  Slots({Key? key, required this.lecturerID}) : super(key: key);

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
                  Navigator.pushReplacement(
                    // PushReplacement kullanıldı
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const TeacherHome(), // TeacherHome sayfasına geri dön
                    ),
                  );
                },
              ),
              const SizedBox(
                width: 100,
              ), // Geri butonu ile logo arasında biraz boşluk
              Image.asset(
                'assets/images/topkapilogo.png', // PNG resminizin yolu
                fit: BoxFit.contain,
                height: 85.0, // AppBar yüksekliğiyle uyumlu olacak şekilde
              ),
              Expanded(
                child: Container(),
              ), // Geriye kalan alanı doldurmak için
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
          ],
        ),
      ),
    );
  }
}

class WeekTile extends StatefulWidget {
  final String week;

  const WeekTile({Key? key, required this.week}) : super(key: key);

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
