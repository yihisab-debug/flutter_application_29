import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NoteListPage(),
    );
  }
}

class NoteListPage extends StatefulWidget {
  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List<String> _notes1 = [];
  TextEditingController _noteController1 = TextEditingController();
  List<String> _notes2 = [];
  TextEditingController _noteController2 = TextEditingController();
  List<String> _notes3 = [];
  TextEditingController _noteController3 = TextEditingController();
  List<String> _notes4 = [];
  TextEditingController _noteController4 = TextEditingController();
    List<String> _notes5 = [];

  int _totalStudents = 0;
  int _absentStudents = 0;
  
  List<Map<String, dynamic>> _history = [];
  
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes1 = prefs.getStringList('notes') ?? [];
      _notes2 = prefs.getStringList('notes') ?? [];
      _notes3 = prefs.getStringList('notes') ?? [];
      _notes4 = prefs.getStringList('notes') ?? [];
    });
  }

  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes', _notes1);
    await prefs.setStringList('notes2', _notes2);
    await prefs.setStringList('notes3', _notes3);
    await prefs.setStringList('notes4', _notes4);
  }

  void _addNote() {
    String text = _noteController1.text.trim();
    String text2 = _noteController2.text.trim();
    String text3 = _noteController3.text.trim();
    String text4 = _noteController4.text.trim();
    if (text.isNotEmpty) {
      
      setState(() {
        _notes1.add(text);
        _notes2.add(text2);
        _notes3.add(text3);
        _notes4.add(text4);

        List<String> students = text4.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
        _totalStudents = students.length;
        _absentStudents = 0;
        
        _history.add({
          'group': text,
          'lesson': text2,
          'date': text3,
          'totalStudents': _totalStudents,
          'absentStudents': 0,
          'students': List<String>.from(students),
        });
        
        for (String student in students) {
          _notes4.add(student);
        }
        
        _noteController1.clear();
        _noteController2.clear();
        _noteController3.clear();
        _noteController4.clear();
      });
      _saveNotes();
    }
  }

void _deleteNote(int index) {
  setState(() {
    _notes1.removeAt(index);
    _notes2.removeAt(index);
    _notes3.removeAt(index);
    _notes4.removeAt(index);
    _absentStudents++;
    
    if (_history.isNotEmpty) {
      _history.last['absentStudents'] = _absentStudents;
    }
  });
  _saveNotes();
}

Widget _buildTextField(TextEditingController controller, String label) {
  return Container(
    width: 220,
    child: TextField(
       controller: controller,
       decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
         isDense: true,
         contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView (
          child: 
        
        Center(
          child: Row(
          children: [
            Center(
              child: 
              Column( 
                children: [

          Container(
            width:  1000,
            height: 800,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                ),
              ],
            ),

            child: Column(
            children: [

              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        'Учёт посещаемости студентов',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [


                      Row(
                        children: [

                      SizedBox(
                        width: 200,
                        height: 50,
                        child: _buildTextField(_noteController1, 'Название тренировки'),
                      ),

                      SizedBox(width: 10),

                      SizedBox(
                        width: 200,
                        height: 50,
                        child: _buildTextField(_noteController2, 'Длительность (сек)'),
                      ),

                      SizedBox(width: 10),

                      SizedBox(
                        width: 200,
                        height: 50,
                        child: _buildTextField(_noteController3, 'Калории'),
                      ),

                      SizedBox(width: 10),

                      SizedBox(
                        width: 200,
                        height: 50,
                        child: _buildTextField(_noteController4, 'Отдых (сек)'),
                      ),

                        ],
                      ),
                     
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.only(bottom: 16, top: 16, left: 16, right: 16),
                child: ElevatedButton(
                onPressed: _addNote,
                  child: Text('Собрать упражнение'),
                ),
              ),

              SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.only(bottom: 16, top: 16, left: 16, right: 16),
                child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Story(history: _history),
                    ),
                  );
                },
                  child: Text('История'),
                ),
              ),

              SizedBox(height: 10),

              Divider(
                color: Colors.blue[700],
                thickness: 3,
              ),


Expanded(
  child: _notes1.isEmpty
      ? Center(child: Text('Заметок пока нет'))
      : ListView.builder(
          itemCount: _notes1.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          width: 250,
                          height: 35,
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [

                              Text(
                                'Мои тренировки',
                                style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                              ),

                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              width: 250,
                              height: 35,
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [

                                  Text(
                                    _notes1[index],
                                    style: TextStyle(fontSize: 12, color: Colors.black),
                                  ),

                                ],
                              ),
                            ),

                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    height: 35,
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [

                                        Icon(Icons.watch_later_outlined, size: 12, color: Colors.blue),

                                        SizedBox(width: 10),

                                        Text(_notes2[index], style: TextStyle(fontSize: 12, color: Colors.black)),

                                        SizedBox(width: 10),

                                        Text('мин', style: TextStyle(fontSize: 12, color: Colors.black)),

                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 5),

                                  Container(
                                    height: 35,
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [

                                        Icon(Icons.local_fire_department_outlined, size: 12, color: Colors.red),
                                        SizedBox(width: 10),

                                        Text(_notes3[index], style: TextStyle(fontSize: 12, color: Colors.black)),

                                        SizedBox(width: 10),

                                        Text('ккал', style: TextStyle(fontSize: 12, color: Colors.black)),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    height: 35,
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        
                                        Icon(Icons.restart_alt_sharp, size: 12, color: Colors.black),

                                        SizedBox(width: 10),

                                        Text(_notes4[index], style: TextStyle(fontSize: 12, color: Colors.black)),

                                        SizedBox(width: 10),

                                        Text('сек', style: TextStyle(fontSize: 12, color: Colors.black)),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Spacer(),

                    Container(
                      padding: EdgeInsets.all(7),
                      child: IconButton(
                        onPressed: () => _deleteNote(index),
                        icon: Icon( Icons.clear_rounded, color: Colors.black, size: 20,),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),

    ],
  ),
),

],
),
),        

],
),
),
),
),
);
}
}

class Story extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const Story({required this.history, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('История',
        style: TextStyle( color:Colors.white,),),
        backgroundColor: Colors.blue[700],
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: history.isEmpty
            ? Center(

                child: Text(
                  'История пока пуста',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )

            : ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final record = history[index];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            'Тренировка ${index + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          SizedBox(height: 8),

                          Row(
                            children: [

                              Text(
                                'Название тренировки: ',
                                style: TextStyle(fontSize: 12,),
                              ),
                              Text(record['group'] ?? '', style: TextStyle(fontSize: 12, color: Colors.black)),

                            ],
                          ),

                          SizedBox(height: 8),

                          Row(
                            children: [

                              Text(
                                'Длительность: ',
                                style: TextStyle(fontSize: 12,),
                              ),
                              Text(record['lesson'] ?? '', style: TextStyle(fontSize: 12, color: Colors.black)),

                            ],
                          ),

                          SizedBox(height: 8),

                          Row(
                            children: [

                              Text(
                                'Калории: ',
                                style: TextStyle(fontSize: 12,),
                              ),
                              Text(record['date'] ?? '', style: TextStyle(fontSize: 12, color: Colors.black)),

                            ],
                          ),

                          SizedBox(height: 8),

                          Row(
                            children: [

                              Text(
                                'Отдых: ',
                                style: TextStyle(fontSize: 12,),
                              ),
                              Text('${record['totalStudents']}', style: TextStyle(fontSize: 12, color: Colors.black)),

                            ],
                          ),


                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}