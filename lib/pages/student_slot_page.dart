import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qryoklamasistemi/pages/student_page.dart';

class StudentSlotsPage extends StatefulWidget {
  final String ders;
  final String studentId;
  StudentSlotsPage({Key? key, required this.studentId, required this.ders})
      : super(key: key);

  @override
  State<StudentSlotsPage> createState() => _StudentSlotsPageState();
}

class _StudentSlotsPageState extends State<StudentSlotsPage> {
  final collection = FirebaseFirestore.instance.collection("classes");
  final studentsCollection = FirebaseFirestore.instance.collection("students");

  Future<int> GetWeekCount(String ders) async {
    var querySnapshot =
        await collection.where('classname', isEqualTo: ders).get();

    if (querySnapshot.docs.isEmpty) {
      return 0;
    }

    var document = querySnapshot.docs.first;
    var data = document.data();

    int fieldCount = data.length;

    return fieldCount - 1;
  }

  Future<String?> getNumberByStudentId(String studentId) async {
    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get();
      return docSnapshot.get('number')?.toString();
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  Future<List<List<String>>> GetWeekDetails(
      String ders, String studentId) async {
    var studentDoc = await studentsCollection.doc(studentId).get();
    if (!studentDoc.exists) {
      // Öğrenci bulunamadıysa boş liste döndür
      return [
        ["Öğrenci Bulunamadı"]
      ];
    }

    var querySnapshot =
        await collection.where('classname', isEqualTo: ders).get();

    if (querySnapshot.docs.isEmpty) {
      return [
        ["Boş Hafta"]
      ];
    }

    var document = querySnapshot.docs.first;
    var data = document.data();
    var studentnumber = await getNumberByStudentId(
        widget.studentId); // Bekleme yapılması gerekiyor

    List<List<String>> weeklist = [];

    for (var i = 1; i <= data.length; i++) {
      var weekKey = 'Hafta $i';
      var weekData = data[weekKey];

      if (weekData is List) {
        List<String> weekStudentStatuses = [];
        if (weekData.contains(studentnumber)) {
          weekStudentStatuses.add("Katıldı");
        } else {
          weekStudentStatuses.add("Katılmadı");
        }
        weeklist.add(weekStudentStatuses);
      }
    }

    return weeklist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentPage(
                        studentId: widget.studentId,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                width: 100,
              ),
              Image.asset(
                'assets/images/topkapilogo.png',
                fit: BoxFit.contain,
                height: 85.0,
              ),
              Expanded(
                child: Container(),
              ),
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
        child: FutureBuilder<int>(
          future: GetWeekCount(widget.ders),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final weekCount = snapshot.data ?? 0;
              final List<String> weeks =
                  List.generate(weekCount, (index) => 'Hafta ${index + 1}');
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: weekCount,
                      itemBuilder: (context, index) {
                        return FutureBuilder<List<List<String>>>(
                          future: GetWeekDetails(widget.ders, widget.studentId),
                          builder: (context, detailsSnapshot) {
                            if (detailsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (detailsSnapshot.hasError) {
                              return Center(
                                  child:
                                      Text('Error: ${detailsSnapshot.error}'));
                            } else {
                              final weekDetails = detailsSnapshot.data ?? [];
                              return WeekTile(
                                  week: weeks[index],
                                  items: weekDetails.isNotEmpty
                                      ? weekDetails[index]
                                      : []);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class WeekTile extends StatefulWidget {
  final String week;
  final List<String> items;

  const WeekTile({Key? key, required this.week, required this.items})
      : super(key: key);

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: widget.items
                    .map((item) => ListTile(
                          title: Text(
                            item,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
