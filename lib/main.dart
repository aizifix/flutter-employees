import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      
      ),
      home: const EmployeeSearchPage(),
    );
  }
  



}

class EmployeeSearchPage extends StatefulWidget {
  const EmployeeSearchPage({super.key});

  @override
  _EmployeeSearchPageState createState() => _EmployeeSearchPageState();
}

class _EmployeeSearchPageState extends State<EmployeeSearchPage> {
  TextEditingController _controller = TextEditingController();
  String _name = '';
  String _department = '';
  String _status = '';
  String _basicSalary = '';
  String _errorMessage = '';

  Future<void> _searchEmployee(String id) async {
    final url = Uri.parse('http://localhost/employee-api/employee.php?action=search&emp_id=$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['error'] != null) {
          setState(() {
            _errorMessage = data['error'];
            _name = '';
            _department = '';
            _status = '';
            _basicSalary = '';
          });
        } else {
          setState(() {
            _name = data['emp_name'];
            _department = data['department_text'];
            _status = data['stat_text'];
            _basicSalary = data['emp_basic_salary'].toString();
            _errorMessage = '';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load data';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Employee ID',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final id = _controller.text;
                      if (id.isNotEmpty) {
                        _searchEmployee(id);
                      }
                    },
                    child: const Text('Search', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 188, 174, 18),
                    )
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: $_name', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('Department: $_department', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('Status', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('$_status', style: TextStyle(backgroundColor: Color.fromARGB(255, 25, 143, 38), color: Colors.white),),
                  Text('Basic Salary: $_basicSalary', style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
          ],
        ),
      ),
    );
  }
}