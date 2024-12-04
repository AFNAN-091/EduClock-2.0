import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';
import '../pdf_api/save_open.dart';
import '../pdf_api/simple_pdf.dart';


class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen>  {
  final MyData data = MyData();
  late String dept = '';
  late String semester = '';

  Future<void> getSavedDepartment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dept = prefs.getString("department") ?? "";
      semester = prefs.getString("semester") ?? "";
    });
    print("Department: $dept");
    print("Semester: $semester");
  }

  @override
  void initState() {
    super.initState();
    getSavedDepartment();
  }


  @override
  void dispose() {
    data.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MarkSheet'),
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.angleLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final simple = await PdfInvoiceApi.generateInvoice( data.getTableData());
              SaveOpen.openPdf(simple);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                color: Colors.white,
                width: 1000,
                child: PaginatedDataTable(
                  columns: const [
                    DataColumn(label: Text('Course Name')),
                    DataColumn(label: Text('Credit'), numeric: true),
                    DataColumn(label: Text('TT1 (10)'), numeric: true),
                    DataColumn(label: Text('TT2 (10)'), numeric: true),
                    DataColumn(label: Text('TT3 (10)'), numeric: true),
                    DataColumn(label: Text('Quiz (10)'), numeric: true),
                    DataColumn(label: Text('Final (60)'), numeric: true),
                    DataColumn(label: Text('Total'), numeric: true),
                    DataColumn(label: Text('CGPA'), numeric: true),
                    DataColumn(label: Text('Grade')),
                    DataColumn(label: Text('')),
                  ],
                  source: data,
                  columnSpacing: 50,
                  header: Text("Semester $semester"),
                  rowsPerPage: 5,
                  horizontalMargin: 20,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  data.addRow(); // Add new row
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Row'),
            ),
          ],
        ),
      ),
    );
  }






}


class MyData extends DataTableSource {
  final List<Map<String, dynamic>> _data = [];
  final Map<int, List<TextEditingController>> _controllersMap = {};
  int? _newRowId;

  MyData() {
    _loadData(); // Load data from the database when initializing
  }

  Future<void> _loadData() async {
    final rows = await DatabaseHelper.instance.queryAllRows();
    _data.addAll(rows);
    notifyListeners();
  }

  Future<void> addRow() async {
    final newRow = {
      'courseName': '',
      'credit': 0,
      'tt1': 0,
      'tt2': 0,
      'tt3': 0,
      'quiz': 0,
      'final': 0,
      'total': 0,
      'cgpa': 0.0,
      'grade': 'F',
    };
    final id = await DatabaseHelper.instance.insert(newRow);
    newRow['id'] = id;
    _data.add(newRow);
    _newRowId = id;
    _controllersMap[id] = _createControllers(newRow);
    notifyListeners();
  }

  double _calculateCgpa(int total)
  {
    if(total >=80){
      return 4.0;
    }
    else if(total >=75){
      return 3.75;
    }
    else if(total >=70){
      return 3.50;
    }
    else if(total >=65){
      return 3.25;
    }
    else if(total >=60){
      return 3.0;
    }
    else if(total >=55){
      return 2.75;
    }
    else if(total >=50){
      return 2.50;
    }
    else if(total >=45){
      return 2.25;
    }
    else if(total >=40){
      return 2.0;
    }
    else{
      return 0.0;
    }

  }


  Future<void> updateRow(Map<String, dynamic> row) async {

    int total = row['tt1'] + row['tt2'] + row['tt3'] + row['quiz'] + row['final'];
    row['total'] = total;
    row['cgpa'] = _calculateCgpa(total);
    if (row['cgpa'] >= 4.0) {
      row['grade'] = 'A+';
    } else if (row['cgpa'] >= 3.75) {
      row['grade'] = 'A';
    } else if (row['cgpa'] >= 3.50) {
      row['grade'] = 'A-';
    } else if (row['cgpa'] >= 3.25) {
      row['grade'] = 'B+';
    } else if (row['cgpa'] >= 3.00) {
      row['grade'] = 'B';
    } else if (row['cgpa'] >= 2.75) {
      row['grade'] = 'B-';
    } else if (row['cgpa'] >= 2.50) {
      row['grade'] = 'C+';
    } else if (row['cgpa'] >= 2.25) {
      row['grade'] = 'C';
    } else if (row['cgpa'] >= 2.00) {
      row['grade'] = 'C-';
    } else {
      row['grade'] = 'F';
    }
    await DatabaseHelper.instance.update(row);
    _data[_data.indexWhere((element) => element['id'] == row['id'])] = row;
    notifyListeners();
  }

  Future<void> deleteRow(int id) async {
    await DatabaseHelper.instance.delete(id);
    _data.removeWhere((element) => element['id'] == id);
    _controllersMap.remove(id);
    notifyListeners();
  }

  List<TextEditingController> _createControllers(Map<String, dynamic> row) {
    return [
      TextEditingController(text: row['courseName']),
      TextEditingController(text: row['credit'].toString()),
      TextEditingController(text: row['tt1'].toString()),
      TextEditingController(text: row['tt2'].toString()),
      TextEditingController(text: row['tt3'].toString()),
      TextEditingController(text: row['quiz'].toString()),
      TextEditingController(text: row['final'].toString()),
      // TextEditingController(text: row['cgpa'].toString()),
      // TextEditingController(text: row['grade']),
    ];
  }

  @override
  DataRow getRow(int index) {
    final row = _data[index];
    final isNewRow = row['id'] == _newRowId;
    final controllers = _controllersMap[row['id']] ?? _createControllers(row);

    _controllersMap[row['id']] = controllers;

    return DataRow(cells: [
      DataCell(Center(
        child: isNewRow
            ? TextField(
          controller: controllers[0],
          onChanged: (val) {
            row['courseName'] = val;
            updateRow(row);
          },
          decoration: const InputDecoration(
              hintText: 'Machine Leaning',
              hintStyle: TextStyle(color: Colors.black12,
                fontSize: 16,

              ),
              border: InputBorder.none),
        )
            : Text(row['courseName']),
      ), showEditIcon: isNewRow),
      DataCell(Center(
        child: isNewRow
            ? TextField(
          controller: controllers[1],
          onChanged: (val) {
            row['credit'] = int.tryParse(val) ?? 0;
            updateRow(row);
          },
          decoration: const InputDecoration(border: InputBorder.none),
        )
            : Text(row['credit'].toString()),
      ), showEditIcon: isNewRow),
      DataCell(
          isNewRow
              ? TextField(
            controller: controllers[2],
            onChanged: (val) {
              row['tt1'] = int.tryParse(val) ?? 0;
              updateRow(row);
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: InputBorder.none),
          )
              : Text(row['tt1'].toString()),
          showEditIcon: isNewRow),
      DataCell(
          isNewRow
              ? TextField(
            controller: controllers[3],
            onChanged: (val) {
              row['tt2'] = int.tryParse(val) ?? 0;
              updateRow(row);
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: InputBorder.none),
          )
              : Text(row['tt2'].toString()),
          showEditIcon: isNewRow),
      DataCell(
          isNewRow
              ? TextField(
            controller: controllers[4],
            onChanged: (val) {
              row['tt3'] = int.tryParse(val) ?? 0;
              updateRow(row);
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: InputBorder.none),
          )
              : Text(row['tt3'].toString()),
          showEditIcon: isNewRow),
      DataCell(
          isNewRow
              ? TextField(
            controller: controllers[5],
            onChanged: (val) {
              row['quiz'] = int.tryParse(val) ?? 0;
              updateRow(row);
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: InputBorder.none),
          )
              : Text(row['quiz'].toString()),
          showEditIcon: isNewRow),
      DataCell(
          isNewRow
              ? TextField(
            controller: controllers[6],
            onChanged: (val) {
              row['final'] = int.tryParse(val) ?? 0;
              updateRow(row);
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: InputBorder.none),
          )
              : Text(row['final'].toString()),
          showEditIcon: isNewRow),
      DataCell(
          Text(row['total'].toString())
      ),
      DataCell(
          Text(row['cgpa'].toString())),
      DataCell(
        Text(row['grade']),),
      DataCell(Center(
        child: IconButton(
          icon: const Icon(Icons.delete, size: 20),
          onPressed: () {
            deleteRow(row['id']);
          },
        ),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

  @override
  void dispose() {
    for (final controllers in _controllersMap.values) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  List<List> getTableData() {
    return _data.map((row) {
      return [
        row['courseName'] ?? '',
        row['credit'].toString(),
        row['tt1'].toString(),
        row['tt2'].toString(),
        row['tt3'].toString(),
        row['quiz'].toString(),
        row['final'].toString(),
        row['total'].toString(),
        row['cgpa'].toString(),
        row['grade'] ?? '',
      ];
    }).toList();
  }
}
