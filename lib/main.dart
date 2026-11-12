import 'package:flutter/material.dart';

void main() {
  runApp(const GradesApp());
}

/// Lowest grade that counts as a pass.
const int passingGrade = 55;

class Student {
  Student(this.name, this.grade);

  final String name;
  int grade;

  bool get passed => grade >= passingGrade;
}

class GradesApp extends StatelessWidget {
  const GradesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ציונים',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      // The whole app is in Hebrew, so lay it out right-to-left.
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const GradesPage(),
    );
  }
}

enum SortOrder { none, highFirst, lowFirst }

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final List<Student> _students = [
    Student('נועה', 92),
    Student('דנה', 71),
    Student('יוסף', 54),
    Student('עומר', 48),
  ];

  SortOrder _sortOrder = SortOrder.none;

  double get _average =>
      _students.map((s) => s.grade).reduce((a, b) => a + b) /
      _students.length;

  List<Student> get _visibleStudents {
    final list = [..._students];
    switch (_sortOrder) {
      case SortOrder.highFirst:
        list.sort((a, b) => b.grade.compareTo(a.grade));
      case SortOrder.lowFirst:
        list.sort((a, b) => a.grade.compareTo(b.grade));
      case SortOrder.none:
        break;
    }
    return list;
  }

  void _changeGrade(Student student, int delta) {
    setState(() => student.grade = (student.grade + delta).clamp(0, 100));
  }

  void _cycleSort() {
    setState(() {
      _sortOrder =
          SortOrder.values[(_sortOrder.index + 1) % SortOrder.values.length];
    });
  }

  String get _sortTooltip => switch (_sortOrder) {
        SortOrder.none => 'מיין מהגבוה לנמוך',
        SortOrder.highFirst => 'מיין מהנמוך לגבוה',
        SortOrder.lowFirst => 'בטל מיון',
      };

  @override
  Widget build(BuildContext context) {
    final students = _visibleStudents;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('ממוצע: ${_average.toStringAsFixed(1)}'),
        actions: [
          IconButton.filledTonal(
            onPressed: _cycleSort,
            tooltip: _sortTooltip,
            icon: const Icon(Icons.sort, textDirection: TextDirection.ltr),
            isSelected: _sortOrder != SortOrder.none,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return StudentTile(
            key: ValueKey(student.name),
            student: student,
            onIncrease: () => _changeGrade(student, 1),
            onDecrease: () => _changeGrade(student, -1),
          );
        },
      ),
    );
  }
}

class StudentTile extends StatelessWidget {
  const StudentTile({
    super.key,
    required this.student,
    required this.onIncrease,
    required this.onDecrease,
  });

  final Student student;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        student.passed ? Icons.check_circle : Icons.cancel,
        color: student.passed ? Colors.green : Colors.red,
        semanticLabel: student.passed ? 'עבר' : 'נכשל',
      ),
      title: Text(student.name),
      subtitle: Text('ציון: ${student.grade}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: student.grade > 0 ? onDecrease : null,
            icon: const Icon(Icons.remove),
            tooltip: 'הורד ציון',
          ),
          IconButton(
            onPressed: student.grade < 100 ? onIncrease : null,
            icon: const Icon(Icons.add),
            tooltip: 'העלה ציון',
          ),
        ],
      ),
    );
  }
}
